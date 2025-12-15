//
//  UITextField+extensions.swift
//  clock2go2020
//
//  Created by Admin on 12/22/19.
//

import UIKit

extension UITextField {

    func addCloseToolbar(onClose: (target: Any, action: Selector)? = nil) {

        let onClose = onClose ?? (target: self, action: #selector(closeButtonTapped))

        let toolbar: UIToolbar  = UIToolbar()
        toolbar.barStyle        = .default
        toolbar.backgroundColor = #colorLiteral(red: 0.7417061925, green: 0.8273479342, blue: 0.9135255218, alpha: 1)

        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Close", style: .done, target: onClose.target, action: onClose.action)
        ]

        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }

    // Default close actions:
    @objc func closeButtonTapped() { self.resignFirstResponder() }

    func oneTimeCodeTextField() {
        if #available(iOS 12.0, *) {
            keyboardType = .numberPad
            textContentType = .oneTimeCode
        }
    }

    // Set placeholder color
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
            ] as [NSAttributedString.Key: Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }

    // Set padding
    func setPaddingPoints(right: CGFloat = 0, left: CGFloat = 0) {
        if right > 0 {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }

        if left > 0 {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }

    // Set padding

    func setPadding(rightImage: UIImage? = nil, rightPadding: CGFloat = 0,
                    leftImage: UIImage? = nil, leftPadding: CGFloat = 0) {
        if rightPadding > 0 {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: self.frame.size.height))

            let image = UIImageView(image: rightImage)
            image.frame = paddingView.bounds
            image.contentMode = .center
            paddingView.addSubview(image)

            self.rightView = paddingView
            self.rightViewMode = .always
        }

        if leftPadding > 0 {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.size.height))

            let image = UIImageView(image: leftImage)
            image.frame = paddingView.bounds
            image.contentMode = .center
            paddingView.addSubview(image)

            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
}


extension UITextView {
    func addCloseToolbar(onClose: (target: Any, action: Selector)? = nil) {

        let onClose = onClose ?? (target: self, action: #selector(closeButtonTapped))

        let toolbar: UIToolbar  = UIToolbar()
        toolbar.barStyle        = .default
        toolbar.backgroundColor = #colorLiteral(red: 0.7417061925, green: 0.8273479342, blue: 0.9135255218, alpha: 1)

        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Close", style: .done, target: onClose.target, action: onClose.action)
        ]

        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }

    // Default close actions:
    @objc func closeButtonTapped() { self.resignFirstResponder() }

    
}
