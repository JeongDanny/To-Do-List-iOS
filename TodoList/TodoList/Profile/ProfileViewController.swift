//
//  ProfileViewController.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import UIKit
import RxDataSources
import RxSwift

protocol ProfileCell {
    static var cellId: String { get }
    func apply(cellData: ProfileCellData)
    static func cellHeight(cellData: ProfileCellData) -> CGFloat
}

class ProfileViewController: UIViewController {
    static func newInstance(viewModel: ProfileViewModel) -> ProfileViewController {
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: ProfileViewModel!
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfProfile>?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        tableView.contentInset = .zero
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfProfile> { [weak self] dataSource, tableView, indexPath, item in
            let cellId = item.cellStyle.cellId
            tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            (cell as? ProfileCell)?.apply(cellData: item)
            
            if let userInfoCell = cell as? UserInfoCell,
               case let .userInfo(name) = item {
                userInfoCell.editButton.rx.tap
                    .bind(onNext: { [weak self] in
                        self?.tapChangeName(currentName: name)
                    }).disposed(by: userInfoCell.disposeBag)
            }
            if let leaveButtonCell = cell as? LeaveButtonCell {
                leaveButtonCell.leaveButton.rx.tap.bind(onNext: { [weak self] in
                    self?.tapLeaveButton()
                }).disposed(by: leaveButtonCell.disposeBag)
            }
            
            return cell
        }
        self.dataSource = dataSource
        
        viewModel.sections
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func tapChangeName(currentName: String) {
        let alert = UIAlertController(title: "", message: "Change Name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "name"
            textField.text = currentName
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] okAction in
            let name = alert.textFields?[0].text ?? ""
            self?.viewModel.changeName(name: name)
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func tapLeaveButton() {
        let alert = UIAlertController(title: "", message: "Goodbye", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "👋", style: .default) { [weak self] okAction in
            self?.viewModel.deleteUser()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        do {
            if let cellData = try dataSource?.model(at: indexPath) as? ProfileCellData {
                return cellData.cellStyle.cellHeight(cellData: cellData)
            } else {
                return 0
            }
        } catch {
            return 0
        }
    }
}
