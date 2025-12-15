//
//  CAGradientLayer+extensions.swift
//  clock2go2020
//
//  Created by Admin on 2/7/20.
//

import UIKit

extension CAGradientLayer {

    func get(topColor: UIColor, bottomColor: UIColor, isVertical: Bool, frame: CGRect) -> CAGradientLayer {

        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [topColor.cgColor, bottomColor.cgColor]

        if isVertical {
            gradient.locations = [0.0, 1.0]
        }

        gradient.frame = frame

        return gradient
    }

}
