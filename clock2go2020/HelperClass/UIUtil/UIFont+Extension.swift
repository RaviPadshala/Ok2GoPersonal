//
//  UIFont+Extension.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 10.12.2021.
//

import UIKit

extension UIFont {
    
    static func appRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Open Sans Hebrew-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func appBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Open Sans Hebrew-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
