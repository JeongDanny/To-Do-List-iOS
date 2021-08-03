//
//  GlobalDataBase.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift

protocol UserDatabase {
    func update(user: User, completion: (() -> Void))
    func observeUser() -> Observable<User>
}

let gDB = GlobalDataBase.shared

struct GlobalDataBase {
    static let shared = GlobalDataBase()
    private let user = PublishRelay<User>()
    private let realm = try! Realm()
    
    private init() {    }
    
    func sync() {
        // user
        if let userId = udm.userId,
           let user = realm.object(ofType: UserRealm.self, forPrimaryKey: userId) {
            self.user.accept(user.convertToUser())
        }
    }
}

extension GlobalDataBase: UserDatabase {
    func update(user: User, completion: (() -> Void)) {
        do {
            try realm.write {
                realm.add(user.convertToUserRealm(), update: .modified)
                self.user.accept(user)
                udm.userId = user.id
                completion()
            }
        } catch {
            print(" GlobalDataBase Realm Write Error")
        }
    }
    
    func observeUser() -> Observable<User> {
        user.asObservable()
    }
}
