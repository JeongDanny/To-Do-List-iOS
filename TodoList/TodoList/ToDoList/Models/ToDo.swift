//
//  ToDo.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation
import RealmSwift

struct ToDo {
    var id: String
    var title: String
    var subTitle: String?
    var isDone: Bool
    
    init(toDoRealm: ToDoRealm) {
        self.id = toDoRealm.id
        self.title = toDoRealm.title
        self.subTitle = toDoRealm.subTitle
        self.isDone = toDoRealm.isDone
    }
    
    init(id: String, title: String, subTitle: String?, isDone: Bool) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.isDone = isDone
    }
    
    func convertToToDoRealm() -> ToDoRealm {
        ToDoRealm(toDo: self)
    }
}

class ToDoRealm: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var subTitle: String? = nil
    @objc dynamic var isDone: Bool = false
    
    override class func primaryKey() -> String? { return "id" }
    
    convenience init(toDo: ToDo) {
        self.init()
        self.id = toDo.id
        self.title = toDo.title
        self.subTitle = toDo.subTitle
        self.isDone = toDo.isDone
    }
    
    func convertToToDo() -> ToDo {
        ToDo(toDoRealm: self)
    }
}
