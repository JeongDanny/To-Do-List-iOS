//
//  MainViewController.swift
//  TodoList
//
//  Created by paytalab on 2021/08/02.
//

import UIKit
import RxSwift

class MainViewController: UITabBarController {
    static func newInstance() -> MainViewController {
        let vc = MainViewController(nibName: "MainViewController", bundle: nil)
        return vc
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toDoListVC = ToDoListViewController.newInstance(viewModel: ToDoListViewModel(toDoDB: ToDoDatabase()))
        let toDoListNC = UINavigationController(rootViewController: toDoListVC)
        toDoListNC.navigationBar.prefersLargeTitles = true
        toDoListNC.tabBarItem = .init(title: "To Do", image: nil, tag: 0)
        
        let profileVC = ProfileViewController.newInstance(viewModel: ProfileViewModel(userDB: gDB))
        let profileNC = UINavigationController(rootViewController: profileVC)
        profileNC.navigationBar.prefersLargeTitles = true
        profileNC.tabBarItem = .init(title: "Profile", image: nil, tag: 1)
        
        DispatchQueue.main.async { [weak self] in
            guard let s = self else { return }
            s.viewControllers = [toDoListNC, profileNC]
        }
        
        // for new user
        gDB.observeUser()
            .skip(1)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] user in
                if user == nil && udm.userId == nil {
                    let signUpVC = SignUpViewController.newInstance(viewModel: SignUpViewModel())
                    self?.present(signUpVC, animated: true)
                }
            }).disposed(by: disposeBag)
    }
}
