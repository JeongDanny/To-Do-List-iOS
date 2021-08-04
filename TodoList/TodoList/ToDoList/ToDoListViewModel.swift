//
//  ToDoListViewModel.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift

struct ToDoListViewModel {
    let toDoDB: ToDoDatabase
    let sections: Observable<[SectionOfToDoList]>
    
    init(toDoDB: ToDoDatabase) {
        self.toDoDB = toDoDB
        sections = toDoDB.toDoListidsObservable().map({ ids -> [SectionOfToDoList] in
            var sections: [SectionOfToDoList] = []
            if ids.isEmpty {
                sections.append(SectionOfToDoList(id: "To Do Empty", items: [.empty]))
            } else {
                sections.append(SectionOfToDoList(id: "To Do List \(ids.count)",
                                                  items: ids.reversed().map({ .toDo(id: $0) }) ))
            }
            sections.append(SectionOfToDoList(id: "Generate Button", items: [.generateButton]))
            return sections
        })
    }
    
    func generateToDo(title: String, subTitle: String?) {
        let id = UUID().uuidString
        toDoDB.update(id: id, toDo: ToDo(id: id, title: title, subTitle: subTitle, isDone: false))
    }
    
    func editToDo(id: String, toDo: ToDo) {
        toDoDB.update(id: id, toDo: toDo)
    }
    
    func toggleToDoIsDone(id: String) {
        guard var toDo = toDoDB.toDo(id: id) else { return }
        toDo.isDone.toggle()
        toDoDB.update(id: id, toDo: toDo)
    }
    
    func syncDB() {
        toDoDB.sync()
    }
    
    func deleteToDo(id: String) {
        toDoDB.deleteToDo(id: id)
    }
}

struct SectionOfToDoList {
    var id: String
    var items: [Item]
}

extension SectionOfToDoList: SectionModelType {
    typealias Item = ToDoListCellData
    
    init(original: SectionOfToDoList, items: [Item]) {
        self = original
        self.items = items
    }
}
