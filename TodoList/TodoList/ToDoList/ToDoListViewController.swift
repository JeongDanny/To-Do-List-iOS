//
//  ToDoListViewController.swift
//  TodoList
//
//  Created by paytalab on 2021/08/02.
//

import UIKit
import RxDataSources
import RxSwift

protocol ToDoListCell {
    static var cellId: String { get }
    func apply(cellData: ToDoListCellData, toDoDB: ToDoDatabase)
    static func cellHeight(cellData: ToDoListCellData) -> CGFloat
}

class ToDoListViewController: UIViewController {
    static func newInstance(viewModel: ToDoListViewModel) -> ToDoListViewController {
        let vc = ToDoListViewController(nibName: "ToDoListViewController", bundle: nil)
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var generateButton: UIButton!
    private var viewModel: ToDoListViewModel!
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfToDoList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To Do"
        tableView.contentInset = .zero
        tableView.separatorStyle = .none
        tableView.delegate = self
        generateButton.backgroundColor = .white
        generateButton.layer.borderColor = UIColor.lightGray.cgColor
        generateButton.layer.borderWidth = 0.05
        generateButton.layer.cornerRadius = generateButton.frame.height / 2
        generateButton.clipsToBounds = true
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfToDoList> { [weak self] dataSource, tableView, indexPath, item in
            guard let s = self else { return UITableViewCell() }
            let cellId = item.cellStyle.cellId
            tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            (cell as? ToDoListCell)?.apply(cellData: item, toDoDB: s.viewModel.toDoDB)
            
            if let generateCell = cell as? GenerateToDoCell {
                generateCell.generateButton.rx.tap.bind(onNext: { [weak self] in
                    self?.showGenerateToDoAlert()
                }).disposed(by: generateCell.disposeBag)
            }
            
            if let toDoCell = cell as? ToDoCell, case let .toDo(id) = item {
                toDoCell.doneButton.rx.tap.bind(onNext: { [weak self] in
                    self?.viewModel.toggleToDoIsDone(id: id)
                }).disposed(by: toDoCell.disposeBag)
            }
            
            return cell
        }

        self.dataSource = dataSource
        
        disposeBag.insert(
            viewModel.sections
                .observe(on: MainScheduler.instance)
                .bind(to: tableView.rx.items(dataSource: dataSource)),
            gDB.observeUser()
                .observe(on: MainScheduler.instance)
                .compactMap({ $0?.id })
                .distinctUntilChanged()
                .bind(onNext: { [weak self] _ in
                    self?.viewModel.syncDB()
                }),
            tableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
                do {
                    guard let cellData = try dataSource.model(at: indexPath) as? ToDoListCellData else { return }
                    if case let .toDo(id) = cellData,
                       let toDo = self?.viewModel.toDoDB.toDo(id: id) {
                        self?.showEditToDoAlert(currentToDo: toDo)
                    }
                } catch {   }
            }),
            tableView.rx.didEndDecelerating
                .startWith(())
                .withLatestFrom(tableView.rx.contentOffset)
                .map({ [weak self] contentOffset -> Bool in
                    guard let s = self else { return false }
                    let tableViewHeight = s.tableView.frame.height - (self?.navigationController?.navigationBar.frame.height ?? 0)
                    let contentHeight = s.tableView.contentSize.height
                    let generateCellHeight = GenerateToDoCell.cellHeight(cellData: .generateButton)
                    let generateCellY = contentHeight - generateCellHeight
                    return contentOffset.y + tableViewHeight > generateCellY
                })
                .observe(on: MainScheduler.instance)
                .bind(to: generateButton.rx.isHidden),
            generateButton.rx.tap
                .bind(onNext: { [weak self] _ in
                    self?.showGenerateToDoAlert()
                })
        )
    }
    
    private func showGenerateToDoAlert() {
        let alert = UIAlertController(title: "", message: "To Do", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "title (required)"
        }
        alert.addTextField { textField in
            textField.placeholder = "subtitle"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] okAction in
            let title = alert.textFields?[0].text ?? ""
            let subTitle = alert.textFields?[1].text
            self?.viewModel.generateToDo(title: title, subTitle: subTitle)
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showEditToDoAlert(currentToDo: ToDo) {
        let alert = UIAlertController(title: "", message: "Edit To Do", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "title (required)"
            textField.text = currentToDo.title
        }
        alert.addTextField { textField in
            textField.placeholder = "subtitle"
            textField.text = currentToDo.subTitle
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] okAction in
            let title = alert.textFields?[0].text ?? ""
            let subTitle = alert.textFields?[1].text
            let newToDo = ToDo(id: currentToDo.id, title: title,
                               subTitle: subTitle, isDone: currentToDo.isDone)
            
            self?.viewModel.editToDo(id: currentToDo.id, toDo: newToDo)
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        do {
            if let cellData = try dataSource?.model(at: indexPath) as? ToDoListCellData {
                return cellData.cellStyle.cellHeight(cellData: cellData)
            } else {
                return 0
            }
        } catch {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            do {
                if let cellData = try dataSource?.model(at: indexPath) as? ToDoListCellData,
                   case let .toDo(id) = cellData {
                    return [.init(style: .destructive, title: "????", handler: { [weak self] _, _ in
                        self?.viewModel.deleteToDo(id: id)
                    })]
                } else {
                    return []
                }
            } catch {
                return []
            }
    }
}
