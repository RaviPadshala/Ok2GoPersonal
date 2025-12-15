//
//  EmailReportView.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/24/20.
//

import UIKit

class EmailReportView: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!

    @IBOutlet weak var formatView: UIView!
    @IBOutlet weak var formatTitle: UILabel!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!

    @IBOutlet weak var emailTextField: UITextField!

    var viewModel: EmailReportViewModel!
    var emailSend: ((_ email: String) -> Void)?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocalizations()
        setupValues()
        setupTaps()
        validateEmail()

        viewModel.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    func setupUI() {
        iconView.roundCorners([.allCorners], radius: 30)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 3.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        contentView.roundCorners([.topLeft, .topRight], radius: 30)

        confirmView.roundCorners([.allCorners], radius: 20)
        confirmView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        cancelView.roundCorners([.allCorners], radius: 20)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        setupUIForView(formatView)
        setupUIForView(emailTextField)
        emailTextField.addCloseToolbar()
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 20)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        view.border(width: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setupValues() {
        self.formatTitle.text = viewModel.getFormat()
        self.emailTextField.text = viewModel.getEmail()
    }

    func setupLocalizations() {
        emailTextField.placeholder = "EMAIL_PLACEHOLDER".localized
        formatTitle.text = "FORMAT".localized
        confirmTitle.text = "SEND".localized
        cancelTitle.text = "CANCEL".localized
    }

    func validateEmail() {
        if viewModel.validateEmail() {
            emailTextField.border(width: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

            confirmView.alpha = 1
            confirmView.isUserInteractionEnabled = true
        } else {
            emailTextField.border(width: 1, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))

            confirmView.alpha = 0.5
            confirmView.isUserInteractionEnabled = false
        }
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)

        let formatTap = UITapGestureRecognizer(target: self, action: #selector(showChooseFormatView))
        formatView.addGestureRecognizer(formatTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(cancelTap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmAction))
        confirmView.addGestureRecognizer(confirmTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmAction() {
        viewModel.sendEmail()
        dismissView()
    }

    @objc func showChooseFormatView() {
        let vc = ViewSource.chooseListView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = viewModel.getModelForChooseList()

        vc.choosedType = { _, title in
            self.viewModel.setFormat(format: title)
            self.setupValues()
        }

        self.present(vc, animated: true, completion: nil)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.setEmail(email: textField.text)
        validateEmail()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight = CGFloat(0.0)

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        UIView.animate(withDuration: 3) {
            self.stackViewBottomContraint.constant = keyboardHeight + 15 - 40 - 16
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.stackViewBottomContraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }
}

extension EmailReportView: EmailReportViewModelDelegate {

    func emailSended(_ email: String) {
        emailSend?(email)
    }

}
