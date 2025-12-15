//
//  PhoneInputViewController.swift
//  clock2go2020
//
//  Created by Admin on 12/22/19.
//

import UIKit
import OneSignal

class PhoneInputViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneInputLabel: UILabel!
    @IBOutlet weak var phoneInputView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneInputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var readTermsLabel: UILabel!
    @IBOutlet weak var readTermsButton: UIButton!
    @IBOutlet weak var continueView: ContinueRegistrationView!
    @IBOutlet weak var logoView: UIView!

    var viewModel = PhoneInputViewModel()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsManager.clear()
        if (UserDefaultsManager.companiesReminderObj == nil) {
            CompanywiseReminderNotificationManager.shared.removeAllPendingNotificationsFromLocal()
        }

        viewModel.delegate = self

        setupUI()
        setLocalizedStrings()
        setupValues()
        setupPushToNextVC()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    func setupUI() {
        
        logoView.roundCorners([.topLeft, .topRight], radius: 30.0)
        roundedView.roundCorners([.topLeft, .topRight], radius: 30.0)

        readTermsButton.adjustsImageWhenHighlighted = false

        phoneInputView.roundCorners([.allCorners], radius: 30.0)
        phoneInputView.border(width: 1, color: #colorLiteral(red: 0.2758387029, green: 0.5907399058, blue: 0.82116431, alpha: 1))

        phoneTextField.setPadding(rightImage: UIImage(named: "phone_blue"), rightPadding: 50, leftPadding: 50)
        phoneTextField.addCloseToolbar()
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func setupWrongUI(message: String) {
        phoneInputLabel.text = message
        phoneInputLabel.textColor = #colorLiteral(red: 0.9760324359, green: 0.3408361077, blue: 0.3400854468, alpha: 1)

        phoneInputView.border(width: 1, color: #colorLiteral(red: 0.9760324359, green: 0.3408361077, blue: 0.3400854468, alpha: 1))
        phoneTextField.setPadding(rightImage: UIImage(named: "phone_red"), rightPadding: 50, leftPadding: 50)
    }

    func setLocalizedStrings() {
        titleLabel.text = "PHONE_INPUT_TITLE".localized
        phoneInputLabel.text = "PHONE_INPUT_MESSAGE".localized

        let readTermsString = "TERMS_ARGEEMENT_MESSAGE".localized
        let termsString = "TERMS_OF_USE".localized
        readTermsLabel.attributedText = readTermsString.getUnderlined(color: #colorLiteral(red: 0.5400316948, green: 0.5400316948, blue: 0.5400316948, alpha: 1), stringForUnderline: termsString)
        readTermsLabel.isUserInteractionEnabled = true
        readTermsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
    }

    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        showTermsView()
    }

    func setupValues() {
        readTermsButton.setImage(viewModel.getTermsButtonImage(), for: .normal)

        continueView.alpha = viewModel.shouldEnableContinueView() ? 1 : 0.5
        continueView.isUserInteractionEnabled = viewModel.shouldEnableContinueView()
    }

    func showTermsView() {
        let vc = ViewSource.termsScreen()
        vc.viewModel = viewModel.getTermsModel()
        vc.confirmTapped = {
            self.viewModel.selectTerms()
            self.setupValues()
        }
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    func setupPushToNextVC() {
        continueView.continueTapped = {
            self.phoneTextField.resignFirstResponder()
            self.viewModel.sendPhoneNumber()
        }
    }

    @IBAction func readTermsButtonAction(_ sender: UIButton) {
        viewModel.changeTermsSelection()
        setupValues()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.setPhoneNumber(number: textField.text ?? "")
        setupValues()
    }

}

// keyboard
extension PhoneInputViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight = CGFloat(0.0)

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        UIView.animate(withDuration: 3) {
            self.phoneInputViewBottomConstraint.constant = keyboardHeight + 18
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 1) {
            self.phoneInputViewBottomConstraint.constant = 18
            self.view.layoutIfNeeded()
        }
    }
}

extension PhoneInputViewController: PhoneInputViewModelDelegate {
    func shouldShowWrongUI(error: ErrorObject?) {

        var message = "PHONE_WRONG_MESSAGE".localized

        if let errorCode = error?.error_code {
            if Int(String(errorCode).localized) == nil {
                message = String(errorCode).localized
            }
        }
        self.setupWrongUI(message: message)
    }
}
