//
//  UIViewController+UI.swift
//  Balance
//
//  Created by Raimon Lapuente Ferran on 31/03/2019.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

extension UIViewController: UIGestureRecognizerDelegate {
    func dismissKeyBoardOnScreenTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
