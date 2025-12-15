//
//  UIStoryboard+extensions.swift
//  clock2go2020
//
//  Created by Admin on 12/27/19.
//

import UIKit

extension UIStoryboard {

    static func getViewController(storyboard: String, identifier: String) -> UIViewController {
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        return sb.instantiateViewController(withIdentifier: identifier)
    }

}
