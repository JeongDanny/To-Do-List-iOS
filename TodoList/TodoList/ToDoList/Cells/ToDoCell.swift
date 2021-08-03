//
//  ToDoCell.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import UIKit
import class RxSwift.DisposeBag

class ToDoCell: UITableViewCell, ToDoListCell {
    static var cellId: String = "ToDoCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeUI()
        selectionStyle = .none
        titleLabel.font = .boldSystemFont(ofSize: 20)
        subTitleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        subTitleLabel.textColor = .gray
        doneButton.setTitle("☑️", for: .normal)
        doneButton.setTitle("✅", for: .selected)
    }
    
    private func initializeUI() {
        titleLabel.text = nil
        subTitleLabel.text = nil
        doneButton.isSelected = false
    }
    
    func apply(cellData: ToDoListCellData, toDoDB: ToDoDatabase) {
        guard case let .toDo(id) = cellData else { fatalError() }
        toDoDB.toDoListObservable(id: id).bind(onNext: { [weak self] toDo in
            guard let toDo = toDo else {
                self?.initializeUI()
                return
            }
            self?.titleLabel.text = toDo.title
            self?.subTitleLabel.text = toDo.subTitle
            self?.doneButton.isSelected = toDo.isDone
        }).disposed(by: disposeBag)
    }
    
    static func cellHeight(cellData: ToDoListCellData) -> CGFloat {
        return 120
    }
}
