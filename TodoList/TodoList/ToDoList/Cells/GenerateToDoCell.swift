//
//  GenerateToDoCell.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import UIKit
import class RxSwift.DisposeBag

class GenerateToDoCell: UITableViewCell, ToDoListCell {
    static var cellId: String = "GenerateToDoCell"
    var disposeBag = DisposeBag()

    @IBOutlet weak var generateButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func apply(cellData: ToDoListCellData, toDoDB: ToDoDatabase) {
        guard case .generateButton = cellData else { fatalError() }
    }
    
    static func cellHeight(cellData: ToDoListCellData) -> CGFloat {
        return 64
    }
}
