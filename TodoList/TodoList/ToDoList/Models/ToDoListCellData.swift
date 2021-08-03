//
//  ToDoListCellData.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation

enum ToDoListCellData {
    case toDo(id: String)
    case generateButton
    case empty
    
    var cellStyle: ToDoListCell.Type {
        switch self {
        case .toDo: return ToDoCell.self
        case .generateButton: return GenerateToDoCell.self
        case .empty: return ToDoEmptyCell.self
        }
    }
}
