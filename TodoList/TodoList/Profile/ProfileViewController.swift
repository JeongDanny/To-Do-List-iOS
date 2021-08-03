//
//  ProfileViewController.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import UIKit
import RxDataSources
import class RxSwift.DisposeBag

class ProfileViewController: UIViewController {
    static func newInstance() -> ProfileViewController {
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfToDoList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        tableView.contentInset = .init(top: 24, left: 0, bottom: 24, right: 0)
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        
    }
}

extension ProfileViewController: UITableViewDelegate {
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
}
