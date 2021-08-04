//
//  UserIdCell.swift
//  TodoList
//
//  Created by paytalab on 2021/08/04.
//

import UIKit

class UserIdCell: UITableViewCell, ProfileCell {
    static var cellId: String = "UserIdCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        titleLabel.text = "id 👉"
        titleLabel.font = .systemFont(ofSize: 16)
        userIdLabel.text = nil
        userIdLabel.font = .systemFont(ofSize: 16)
        userIdLabel.textColor = .gray
    }
    
    func apply(cellData: ProfileCellData) {
        guard case let .userId(id) = cellData else { return }
        userIdLabel.text = id
    }
    
    static func cellHeight(cellData: ProfileCellData) -> CGFloat {
        return 80
    }
}
