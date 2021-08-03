//
//  UILabelExtension.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(text: String? = nil, font: UIFont) {
        self.init()
        self.text = text
        self.font = font
    }
}
