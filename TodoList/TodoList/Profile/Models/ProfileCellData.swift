//
//  ProfileCellData.swift
//  TodoList
//
//  Created by paytalab on 2021/08/04.
//

import Foundation

enum ProfileCellData {
    case userInfo(name: String)
    case userId(id: String)
    case leaveButton
    
    var cellStyle: ProfileCell.Type {
        switch self {
        case .userInfo: return UserInfoCell.self
        case .userId: return UserIdCell.self
        case .leaveButton: return LeaveButtonCell.self
        }
    }
}
