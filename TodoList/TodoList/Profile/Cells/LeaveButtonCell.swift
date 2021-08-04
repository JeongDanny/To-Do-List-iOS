//
//  LeaveButtonCell.swift
//  TodoList
//
//  Created by paytalab on 2021/08/04.
//

import UIKit
import class RxSwift.DisposeBag

class LeaveButtonCell: UITableViewCell, ProfileCell {
    static var cellId: String = "LeaveButtonCell"

    @IBOutlet weak var leaveButton: UIButton!
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        leaveButton.setTitle("Leave🚪", for: .normal)
        leaveButton.setTitleColor(.lightGray, for: .normal)
    }
    
    func apply(cellData: ProfileCellData) {    }
    
    static func cellHeight(cellData: ProfileCellData) -> CGFloat {
        return 52
    }
}
