//
//  MainViewController.swift
//  TodoList
//
//  Created by paytalab on 2021/08/02.
//

import UIKit

class MainViewController: UITabBarController {
    static func newInstance() -> MainViewController {
        let vc = MainViewController(nibName: "MainViewController", bundle: nil)
        return vc
    }
    
    private let toDoListVC = ToDoListViewController.newInstance(viewModel: ToDoListViewModel(toDoDB: ToDoDatabase()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toDoListNC = UINavigationController(rootViewController: toDoListVC)
        toDoListNC.navigationBar.prefersLargeTitles = true
        DispatchQueue.main.async { [weak self] in
            guard let s = self else { return }
            s.viewControllers = [toDoListNC]
        }
    }
}
