//
//  SetPasswordManagerViewController.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/7/20.
//

import UIKit

class SetPasswordManagerViewController: UIViewController {

    // MARK: Outlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var passwordInputBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordInputLabel: UILabel!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var resendPasswordLabel: UILabel!
    @IBOutlet weak var titleContinueView: UILabel!

    // MARK: Property
    var viewModel = SetPasswordManagerViewModel()

    // MARK: Override
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self)
        viewModel.delegate = self

        setupUI()
        setupTextField()
        setLocalizedStrings()
        setupTap()
    }

    func setupUI() {
        contentView.roundCorners([.topLeft, .topRight], radius: 33.3)
        iconView.roundCorners([.topLeft, .topRight], radius: 30.0)
        passwordTextField.roundCorners(.allCorners, radius: 30.0)
        passwordTextField.border(width: 1.5, color: #colorLiteral(red: 0, green: 0.4392156863, blue: 0.7529411765, alpha: 1))
        continueView.roundCorners(.allCorners, radius: 30)

        resendPasswordLabel.isHidden = true
        forgotPasswordLabel.isHidden = true
    }

    func setupWrongUI() {
        passwordInputLabel.text = "ENTERED_PASSWORD_INVALID_MESSAGE".localized
        passwordInputLabel.textColor = #colorLiteral(red: 0.9760324359, green: 0.3408361077, blue: 0.3400854468, alpha: 1)
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.9760324359, green: 0.3408361077, blue: 0.3400854468, alpha: 1)
    }

    func setupTextField() {
        passwordTextField.addCloseToolbar()
        passwordTextField.placeholder = "ENTER_CODE".localized
        
//        self.passwordTextField.text = "ApKbP35"
    }

    func setLocalizedStrings() {
        // localized
        titleLabel.text = "WELCOME_TITLE".localized
        passwordInputLabel.text = "INPUT_PASSWORD".localized
        passwordTextField.placeholder = "PASSWORD".localized
        titleContinueView.text = "CONTINUE".localized
        forgotPasswordLabel.text = "FORGOT_PASSWORD".localized
        // KGm4373
        let resendTitle = "PASSWORD_RESEND".localized
        resendPasswordLabel.attributedText = resendTitle.getUnderlined(color: #colorLiteral(red: 0.1110283211, green: 0.3229350746, blue: 0.5155410767, alpha: 1))
    }

    func setupTap() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(continueTap))
        continueView.addGestureRecognizer(tap)

        let resendPasswordTap = UITapGestureRecognizer.init(target: self, action: #selector(resendTap))
        resendPasswordLabel.addGestureRecognizer(resendPasswordTap)
    }

    @objc func continueTap() {
        viewModel.setPassword(password: passwordTextField.text)
        viewModel.sendManagerLogin()
        print("push to next vc")
    }

    @objc func resendTap() {
        print("resendPasswordTap")
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

extension SetPasswordManagerViewController: SetupWrongMgrPasswordDelegate {
    func setupWrongPassword() {
        self.setupWrongUI()
    }

}
