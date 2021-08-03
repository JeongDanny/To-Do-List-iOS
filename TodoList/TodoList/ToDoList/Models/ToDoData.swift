//
//  ToDoData.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation
import RealmSwift

struct ToDoData {
    var userId: String
    var ids: [String]
    
    init(userId: String) {
        self.userId = userId
        self.ids = []
    }
    
    init(toDoDataRealm: ToDoDataRealm) {
        userId = toDoDataRealm.userId
        ids = toDoDataRealm.ids.map({ $0 })
    }
    
    func convertToToDoDataRealm() -> ToDoDataRealm {
        ToDoDataRealm(toDoData: self)
    }
}

class ToDoDataRealm: Object {
    @objc dynamic var userId: String = ""
    var ids = List<String>()
    override class func primaryKey() -> String? { return "userId" }
    
    convenience init(toDoData: ToDoData) {
        self.init()
        userId = toDoData.userId
        ids.append(objectsIn: toDoData.ids)
    }
    
    func convertToToDoData() -> ToDoData {
        ToDoData(toDoDataRealm: self)
    }
}
