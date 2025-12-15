//
//  PasswordInputViewController.swift
//  clock2go2020
//
//  Created by Admin on 12/22/19.
//

import UIKit

class PasswordInputViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordInputLabel: UILabel!
    @IBOutlet weak var passwordInputView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordInputBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var continueView: ContinueRegistrationView!
    @IBOutlet weak var resendButton: UIButton!
    
    @IBOutlet weak var logoView: UIView!

    var viewModel = PasswordInputViewModel()

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

        setupUI()
        setLocalizedStrings()
        setupTextField()
        setupPushToNextVC()
        setupResendButton()

        viewModel.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    func setupUI() {
        roundedView.roundCorners([.topLeft, .topRight], radius: 30.0)
        logoView.roundCorners([.topLeft, .topRight], radius: 30.0)

        passwordInputView.roundCorners([.allCorners], radius: 30.0)
        passwordInputView.border(width: 1, color: #colorLiteral(red: 0.2758387029, green: 0.5907399058, blue: 0.82116431, alpha: 1))
    }

    func setupWrongUI(_ message: String) {
        passwordInputLabel.text = message//"NOT_ALLOWED_TO_USE_THE_APP".localized
//        "WRONG_CODE_MESSAGE"
        passwordInputLabel.textColor = #colorLiteral(red: 0.9760324359, green: 0.3408361077, blue: 0.3400854468, alpha: 1)

        passwordInputView.border(width: 1, color: #colorLiteral(red: 0.9760324359, green: 0.3408361077, blue: 0.3400854468, alpha: 1))
    }

    func setupTextField() {
        passwordTextField.addCloseToolbar()
        passwordTextField.placeholder = "ENTER_CODE".localized
        passwordTextField.oneTimeCodeTextField()
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func setLocalizedStrings() {
        titleLabel.text = "PASSWORD_INPUT_TITLE".localized
        passwordInputLabel.text = "PASSWORD_SEND_MESSAGE".localized

        let resendTitle = "PASSWORD_RESEND_MESSAGE".localized
       // resendButton.titleLabel?.text = resendTitle
        self.resendButton.setTitle(resendTitle, for: .normal)
//        resendButton.setTitle(resendTitle, for: .normal)
        resendButton.titleLabel?.textColor = #colorLiteral(red: 0.08235294118, green: 0.2823529412, blue: 0.462745098, alpha: 1)
    }

    func setupPushToNextVC() {
        continueView.continueTapped = {
            self.passwordTextField.resignFirstResponder()
            self.viewModel.sendPassword()
        }
    }

    func setupResendButton() {
        self.passwordTextField.text = ""
//        resendButton.isHidden = true
//        _ = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }

//    @objc func timerAction() {
//        resendButton.isHidden = false
//    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.setPassword(password: textField.text ?? "")
    }

    // MARK: Action
    @IBAction func resendButtonAction(_ sender: UIButton) {
        setupResendButton()
        viewModel.resendPassword()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        _ = NavigationController.shared?.popViewController(animated: true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight = CGFloat(0.0)

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        UIView.animate(withDuration: 3) {

            self.passwordInputBottomConstraint.constant = keyboardHeight + 18
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.passwordInputBottomConstraint.constant = 18
            self.view.layoutIfNeeded()
        }
    }
}

extension PasswordInputViewController: PasswordInputViewModelDelegate {
    func shouldShowWrongUI(_ message: String) {
        setupWrongUI(message)
    }
}
