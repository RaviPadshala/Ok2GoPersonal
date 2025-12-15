//
//  CloseMonthViewController.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/24/20.
//

import UIKit

class CloseMonthView: UIViewController {
    
    // MARK: Outlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!
    
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var monthTitle: UILabel!
    @IBOutlet weak var absentView: UIView!
    @IBOutlet weak var absentTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var hoursTitle: UILabel!
    @IBOutlet weak var missingView: UIView!
    @IBOutlet weak var missingTitle: UILabel!
    @IBOutlet weak var rulesView: UIView!
    @IBOutlet weak var rulesTitle: UILabel!
    @IBOutlet weak var rulesCheckButton: UIButton!
    
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!
    
    @IBOutlet weak var cellTextField: UITextField!
    
    @IBOutlet weak var invalidEmailsLabel: UILabel!
    
    var viewModel: CloseMonthViewModel!
    var monthClosed: (() -> Void)?
    var managerMonthClosed:(() -> Void)?
    var managerUpdate:(() -> Void)?
    
    var emails: [String] = []
    var invalidEmails:[String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        if UserDefaultsManager.isManagerApp == false {
            viewModel.getMonthInfo()
        }
        
        setupUI()
        setupLocalizations()
        setupValues()
        setupTaps()
        setManagerValue()
        validateEmail(emailTextField.text ?? "")
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
        
        setupUIForView(emailTextField)
        setupUIForView(cellTextField)
        emailTextField.addCloseToolbar()
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        emailTextField.setPaddingPoints(right: 10, left: 14)
        
        cellTextField.addCloseToolbar()
        cellTextField.keyboardType = .numberPad
        cellTextField.addTarget(self, action: #selector(cellTextFieldDidChange), for: .editingChanged)
        cellTextField.setPaddingPoints(right: 10, left: 14)
        
        confirmView.roundCorners([.allCorners], radius: 20)
        confirmView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        cancelView.roundCorners([.allCorners], radius: 20)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        setupUIForView(hoursView)
        setupUIForView(missingView)
        setupUIForView(absentView)
        setupUIForView(monthView)
    }
    
    func setManagerValue() {
        managerMonthClosed?()
        rulesCheckButton.setImage(viewModel.getAgreementImage(), for: .normal)
        
        confirmView.alpha = viewModel.shouldEnableConfirmView() ? 1 : 0.5
        confirmView.isUserInteractionEnabled = viewModel.shouldEnableConfirmView()
        invalidEmailsLabel.text = viewModel.invalidEmailsText
    }
    
    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 20)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        view.border(width: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }
    
    func setupLocalizations() {
        emailTextField.placeholder = "EMAIL_PLACEHOLDER".localized
        emailTextField.text = showEmail()
        cellTextField.placeholder = "CELL".localized
        monthTitle.text   = ""
        absentTitle.text  = "0" + "ABSENCES".localized
        hoursTitle.text   = "0" + "HOURS".localized
        missingTitle.text = "0" + "MISSING".localized
        rulesTitle.text   = "SIGN_AND_CONFIRM_MONTH_REPORT".localized
        confirmTitle.text = "SEND".localized
        cancelTitle.text  = "CANCEL".localized
        invalidEmailsLabel.text = ""
    }
    
    func setupValues() {
        hoursTitle.text     = viewModel.getHoursTitle()
        monthTitle.text     = viewModel.getMonthString()
        missingTitle.text   = viewModel.getMissingTitle()
        absentTitle.text    = viewModel.getAbcenseTitle()
        
        rulesCheckButton.setImage(viewModel.getAgreementImage(), for: .normal)
        
        confirmView.alpha = viewModel.shouldEnableConfirmView() ? 1 : 0.5
        confirmView.isUserInteractionEnabled = viewModel.shouldEnableConfirmView()
        
        cellTextField.isHidden = !viewModel.isRevacha
        invalidEmailsLabel.text = viewModel.invalidEmailsText
    }
    
    func showEmail() -> String {
        if  CompaniesDataManager.shared.getEmployer() != nil {
            return  CompaniesDataManager.shared.getEmployer()?.employerEmail ?? ""
        } else if UserDefaultsManager.lastEmailCloseMonth != "" {
            return UserDefaultsManager.lastEmailCloseMonth
        } else {
            return viewModel.getEmail()
        }
    }
    
    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(cancelTap)
        
        let confirmTapped = UITapGestureRecognizer(target: self, action: #selector(confirmTapAction))
        confirmView.addGestureRecognizer(confirmTapped)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmTapAction() {
        dismissView()
        if UserDefaultsManager.isManagerApp == false {
            viewModel.closeMonth()
        } else {
            viewModel.closeMonthForEmpployee()
        }
    }
    
    @IBAction func agreementButtonAction(_ sender: Any) {
        viewModel.changeAgreement()
        
        if UserDefaultsManager.isManagerApp == false {
            setupValues()
        } else {
            setManagerValue()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        invalidEmails = []
        viewModel.setEmail(email: textField.text)
        validateEmail(textField.text ?? "")
    }
    
    private func validateEmail(_ emails: String) {
        viewModel.validateEmails {
            if UserDefaultsManager.isManagerApp {
                setManagerValue()
            } else {
                setupValues()
            }
        }
    }

    @objc func cellTextFieldDidChange(_ textField: UITextField) {
        viewModel.setCell(cell: textField.text)
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

extension CloseMonthView: CloseMonthViewModelDelegate {
    func didLoadData() {
        setupValues()
    }
    
    func didCloseMonth() {
        monthClosed?()
        managerUpdate?()
    }
    
    func didReceiveError(_ error: ErrorObject?) {
        NavigationController.shared?.showErrorView(error: error)
    }
}
