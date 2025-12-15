//
//  UIView+extensions.swift
//  clock2go2020
//
//  Created by Admin on 12/22/19.
//

import UIKit

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }

    func shadow(_ offset: CGSize, opacity: Float, radius: CGFloat, color: CGColor) {
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = color
        layer.masksToBounds = false
    }
    
    func RoundCornerRadius(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }

    func border(width: CGFloat, color: CGColor) {
        clipsToBounds = false
        layer.borderWidth = width
        layer.borderColor = color
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        deactivateRTL(of: self)
    }

    func deactivateRTL(of view: UIView) {
        view.semanticContentAttribute = .forceLeftToRight
        for subview in view.subviews {
            subview.semanticContentAttribute = .forceLeftToRight
            deactivateRTL(of: subview)
        }
    }
    
    func addSubviewWithAnimation(_ view: UIView) {
        UIView.transition(with: self, duration: 0.40, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { [weak self] in
            self?.addSubview(view)
        }) { (finish) in
            //
        }
    }
    
    func removeFromSuperViewWithAnimation() {
        if let superView = self.superview {
            UIView.transition(with: superView, duration: 0.40, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { [weak self] in
                self?.removeFromSuperview()
            }) { (finish) in
                //
            }
        }
    }
}

func getTopMostViewController(base: UIViewController? = getKeyWindow()?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
        return getTopMostViewController(base: nav.visibleViewController)
    }

    if let tab = base as? UITabBarController {
        return getTopMostViewController(base: tab.selectedViewController)
    }

    if let presented = base?.presentedViewController {
        return getTopMostViewController(base: presented)
    }

    return base
}

func getKeyWindow() -> UIWindow? {
    if #available(iOS 15.0, *) {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    } else {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
