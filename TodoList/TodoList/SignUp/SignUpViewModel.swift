//
//  SignUpViewModel.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation
import RxCocoa
import RxSwift

struct SignUpViewModel {
    struct Input {
        let nameText = BehaviorSubject<String?>(value: nil)
    }
    
    struct Output {
        let startButtonEnabled: Observable<Bool>
    }
    
    let input: Input
    var output: Output
    
    init() {
        self.input = Input()
        let startButtonEnabled = input.nameText
            .map({ $0?.isEmpty == false })
        self.output = Output(startButtonEnabled: startButtonEnabled)
    }
    
    func start(userName: String, completion: (() -> Void)) {
        let userId = UUID().uuidString
        gDB.update(user: User(id: userId, name: userName)) {
            gDB.sync()
            completion()
        }
    }
}
