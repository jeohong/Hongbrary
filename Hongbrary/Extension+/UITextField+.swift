//
//  UITextField+.swift
//  Hongbrary
//
//  Created by 홍정민 on 2023/04/17.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftView = paddingView
            self.leftViewMode = ViewMode.always
    }
}
