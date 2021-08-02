//
//  ToDoListViewController.swift
//  TodoList
//
//  Created by paytalab on 2021/08/02.
//

import UIKit

class ToDoListViewController: UIViewController {
    static func newInstance() -> ToDoListViewController {
        let vc = ToDoListViewController(nibName: "ToDoListViewController", bundle: nil)
        vc.tabBarItem = .init(title: "To Do", image: nil, tag: 0)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To Do"
        
    }
}
