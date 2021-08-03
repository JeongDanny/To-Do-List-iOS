//
//  PreferenceManager.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation
import UIKit

var udm = UserDefaultsManager.shared
struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {    }
    
    var userId: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKeys.userId.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userId.rawValue)
        }
    }
    
    enum UserDefaultsKeys: String {
        case userId
    }
}
