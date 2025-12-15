//
//  SalesAmountView.swift
//  clock2go2020
//
//  Created by Admin on 4/28/20.
//

import UIKit

class SalesAmountView: UIViewController {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var salesTitle: UILabel!
    @IBOutlet weak var salesTextField: UITextField!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmViewTitle: UILabel!

    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewTitle: UILabel!

    var confirmTap: ((_ salesAmount: String) -> Void)?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setTextField()
        setLocalizedStrings()
        setupTaps()
        reloadConfirmView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Property
     func setupUI() {
         roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

         iconView.roundCorners([.allCorners], radius: 50)
         iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
         iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

         setupUIForView(confirmView)
         setupUIForView(cancelView)
     }

     func setupUIForView(_ view: UIView) {
         view.roundCorners([.allCorners], radius: 30.0)
         view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
     }

     func setTextField() {
         salesTextField.delegate = self
         salesTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

         salesTextField.roundCorners([.allCorners], radius: 30)
         salesTextField.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
         salesTextField.border(width: 1.3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
         salesTextField.borderStyle = .none

         salesTextField.placeholder = "הזן סכום מכירות".localized
         salesTextField.placeholderColor(color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

         salesTextField.setPadding(rightImage: UIImage(named: "writing"), rightPadding: 50, leftPadding: 50)

         salesTextField.addCloseToolbar()
     }

    func setLocalizedStrings() {
        confirmViewTitle.text = "CONFIRM".localized
        cancelViewTitle.text = "CANCEL".localized
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        backgroundView.addGestureRecognizer(tap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        confirmView.addGestureRecognizer(confirmTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmTapped() {
        dismissView()
        confirmTap?(salesTextField.text ?? "")
    }

    @objc func cancelTapped() {
        dismissView()
    }

    func reloadConfirmView() {
        if salesTextField.text == nil || salesTextField.text == "" {
            confirmView.isUserInteractionEnabled = false
            confirmView.alpha = 0.5
        } else {
            confirmView.isUserInteractionEnabled = true
            confirmView.alpha = 1
        }
    }

}

extension SalesAmountView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 30
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        reloadConfirmView()
    }

}

extension SalesAmountView {

    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.layoutIfNeeded()

        var keyboardHeight = CGFloat(0.0)

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        UIView.animate(withDuration: 3) {
            self.bottomConstraint.constant = keyboardHeight + 40
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.bottomConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }

}
