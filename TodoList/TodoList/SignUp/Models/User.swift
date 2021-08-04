//
//  User.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation
import RealmSwift

struct User {
    let id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(userRealm: UserRealm) {
        self.id = userRealm.id
        self.name = userRealm.name
    }
    
    func convertToUserRealm() -> UserRealm {
        UserRealm(user: self)
    }
}

class UserRealm: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    
    override class func primaryKey() -> String? { "id" }
    
    convenience init(user: User) {
        self.init()
        self.id = user.id
        self.name = user.name
    }
    
    func convertToUser() -> User {
        User(userRealm: self)
    }
}
