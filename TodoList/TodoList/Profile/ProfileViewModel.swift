//
//  ProfileViewModel.swift
//  TodoList
//
//  Created by paytalab on 2021/08/04.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift

struct ProfileViewModel {
    let sections: Observable<[SectionOfProfile]>
    let userDB: UserDatabase
    
    init(userDB: UserDatabase) {
        self.userDB = userDB
        sections = userDB.observeUser()
            .map({ user in
                guard let user = user else { return [] }
                return [SectionOfProfile(id: "User Info \(user.name) \(user.id)",
                                         items: [
                                            .userInfo(name: user.name),
                                            .userId(id: user.id),
                                            .leaveButton
                                         ])]
            })
    }
    
    func changeName(name: String) {
        guard var user = userDB.getUser() else { return }
        user.name = name
        userDB.update(user: user) {    }
    }
    
    func deleteUser() {
        guard let userId = udm.userId else { return }
        udm.reset()
        userDB.deleteUser(userId: userId)
    }
}

struct SectionOfProfile {
    var id: String
    var items: [Item]
}

extension SectionOfProfile: SectionModelType {
    typealias Item = ProfileCellData
    
    init(original: SectionOfProfile, items: [Item]) {
        self = original
        self.items = items
    }
}
