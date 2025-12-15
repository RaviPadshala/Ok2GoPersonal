//
//  UnderlineTextButton.swift
//  Panchangam
//
//  Created by Mac on 06/02/25.
//

import Foundation
import UIKit

class UnderlineTextButton: UIButton {

    override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(title, for: .normal)
    self.setAttributedTitle(self.attributedString(), for: .normal)
}

    private func attributedString() -> NSAttributedString? {
    let attributes : [NSAttributedString.Key : Any] = [
//        NSAttributedString.Key.foregroundColor : UIColor.red,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
    ]
    let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
    return attributedString
  }
}
