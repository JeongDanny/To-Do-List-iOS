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
    let sections: Observable<[SectionOfToDoList]>
    let toDoDB: ToDoDatabase
    
    init(toDoDB: ToDoDatabase) {
        self.toDoDB = toDoDB
        
        self.sections = toDoDB.toDoListidsObservable().map({ ids in
            var sections: [SectionOfToDoList] = []
            if ids.isEmpty {
                sections.append(SectionOfToDoList(id: "To Do Empty", items: [.empty]))
            } else {
                sections.append(SectionOfToDoList(id: "To Do List \(ids.count)",
                                                  items: ids.map({ .toDo(id: $0) }) ))
            }
            sections.append(SectionOfToDoList(id: "Generate Button", items: [.generateButton]))
            return sections
        })
    }
    
    func generateToDo(title: String, subTitle: String?) {
        let id = UUID().uuidString
        toDoDB.update(id: id, toDo: ToDo(id: id, title: title, subTitle: subTitle, isDone: false))
    }
    
    func toggleToDoIsDone(id: String) {
        toDoDB.toggleToDoIsDone(id: id)
    }
    
    func syncDB() {
        toDoDB.sync()
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
