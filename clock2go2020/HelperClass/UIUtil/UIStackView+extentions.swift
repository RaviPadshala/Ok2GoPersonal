//
//  UIStackView+extentions.swift
//  clock2go2020
//
//  Created by Admin on 2/2/20.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor, corners: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        subView.roundCorners([.allCorners], radius: corners)
        insertSubview(subView, at: 0)
    }
}
