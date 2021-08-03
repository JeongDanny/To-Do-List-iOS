//
//  ToDoEmptyCell.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import UIKit

class ToDoEmptyCell: UITableViewCell, ToDoListCell {
    static var cellId: String = "ToDoEmptyCell"
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        descriptionLabel.text = "It's empty.\nTouch ✏️!"
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .lightGray
    }

    func apply(cellData: ToDoListCellData, toDoDB: ToDoDatabase) {  }
    
    static func cellHeight(cellData: ToDoListCellData) -> CGFloat {
        return 88
    }
}
