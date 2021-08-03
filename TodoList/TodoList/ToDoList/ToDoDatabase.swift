//
//  ToDoDatabase.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

struct ToDoDatabase {
    private let toDoData = BehaviorRelay<ToDoData?>(value: nil)
    private let toDoList = BehaviorRelay<[String: ToDo]>(value: [:])
    private let realm = try! Realm()
    
    func sync() {
        guard let userId = udm.userId else { return }
        let toDoRealmList = realm.objects(ToDoRealm.self)
        let toDoList = Dictionary(uniqueKeysWithValues: toDoRealmList.map({ ($0.id, $0.convertToToDo() )}))
        self.toDoList.accept(toDoList)
        let toDoDataRealm = realm.object(ofType: ToDoDataRealm.self, forPrimaryKey: userId)
        self.toDoData.accept(toDoDataRealm?.convertToToDoData())
    }
    
    func update(id: String, toDo: ToDo) {
        guard let userId = udm.userId else { return }
        var toDoData = self.toDoData.value ?? ToDoData(userId: userId)
        if !toDoData.ids.contains(id) {
            toDoData.ids.append(id)
        }
        var toDoList = self.toDoList.value
        toDoList[id] = toDo
        do {
            try realm.write {
                realm.add(toDoData.convertToToDoDataRealm(), update: .modified)
                realm.add(toDo.convertToToDoRealm(), update: .modified)
                self.toDoData.accept(toDoData)
                self.toDoList.accept(toDoList)
            }
        } catch {
            print(" ToDoDatabase Realm Write Error")
        }
    }
    
    func toggleToDoIsDone(id: String) {
        guard var toDo = toDoList.value[id] else { return }
        toDo.isDone.toggle()
        update(id: id, toDo: toDo)
    }
    
    func toDoListidsObservable() -> Observable<[String]> {
        toDoData.map({ $0?.ids ?? [] })
    }
    
    func toDoListObservable(id: String) -> Observable<ToDo?> {
        toDoList.map({ $0[id] })
    }
}
