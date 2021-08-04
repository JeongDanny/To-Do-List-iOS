//
//  UI.swift
//  TodoList
//
//  Created by paytalab on 2021/08/04.
//

import Foundation
import UIKit

let ui = UI.shared

struct UI {
    static let shared = UI()
    private init() {    }
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
}
