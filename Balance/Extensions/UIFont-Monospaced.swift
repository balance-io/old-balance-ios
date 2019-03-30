//
//  UIFont-Monospaced.swift
//  Balance
//
//  Created by Rob Shaw on 3/30/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static func balanceMonospacedDigitSystemFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        var fontName = "Menlo-Regular"

        switch weight {
            case .bold:
                fontName = "Menlo-Bold"
            case .medium:
                fontName = "Menlo-Bold"
            case .heavy:
                fontName = "Menlo-Bold"
            default:
                fontName = "Menlo-Regular"
        }

        let font = UIFont(name: fontName, size: fontSize)
        return font ?? UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: weight)
    }
}
