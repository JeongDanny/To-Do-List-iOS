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
    func getUser() -> User?
    func observeUser() -> Observable<User?>
    func deleteUser(userId: String)
}

let gDB = GlobalDataBase.shared

struct GlobalDataBase {
    static let shared = GlobalDataBase()
    private let user = BehaviorRelay<User?>(value: nil)
    private let realm = try! Realm()
    
    private init() {    }
    
    func sync() {
        // user
        if let userId = udm.userId,
           let user = realm.object(ofType: UserRealm.self, forPrimaryKey: userId) {
            self.user.accept(user.convertToUser())
        } else {
            self.user.accept(nil)
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
            print(" UserDataBase Realm Write Error")
        }
    }
    
    func observeUser() -> Observable<User?> {
        user.asObservable()
    }
    
    func getUser() -> User? {
        user.value
    }
    
    func deleteUser(userId: String) {
        guard let user = realm.object(ofType: UserRealm.self, forPrimaryKey: userId) else { return }
        do {
            try realm.write {
                realm.delete(user)
                self.user.accept(nil)
            }
        } catch {
            print(" UserDataBase Realm Delete Error")
        }
    }
}
