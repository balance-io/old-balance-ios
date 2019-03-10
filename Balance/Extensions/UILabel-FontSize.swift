//
//  UILabel-FontSize.swift
//  Balance
//
//  Created by Benjamin Baron on 3/10/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

extension UILabel {
    var fontSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            if let font = UIFont(name: self.font.fontName, size: newValue) {
                self.font = font
                self.sizeToFit()
            }
        }
    }
}
