//
//  UserInfoCell.swift
//  TodoList
//
//  Created by paytalab on 2021/08/04.
//

import UIKit
import class RxSwift.DisposeBag

class UserInfoCell: UITableViewCell, ProfileCell {
    static var cellId: String = "UserInfoCell"

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        userNameLabel.font = .systemFont(ofSize: 16)
        userNameLabel.textColor = .darkGray
    }
    
    func apply(cellData: ProfileCellData) {
        guard case let .userInfo(name) = cellData else { return }
        userNameLabel.text = name
    }
    
    static func cellHeight(cellData: ProfileCellData) -> CGFloat {
        return ui.screenWidth * 3 / 4
    }
}
