//
//  AddEmployeeView.swift
//  clock2go2020
//
//  Created by Admin on 4/12/20.
//

import UIKit

class AddEmployeeView: UIViewController {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var addEmployeeTitle: UILabel!

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var departmentView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var reportWayView: UIView!
    @IBOutlet weak var reportWayTitle: UILabel!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmViewTitle: UILabel!

    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewTitle: UILabel!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_department: UILabel!
    
    var viewModel = AddEmployeeViewModel()
    var confirmAction: ((_ employee: EmployeeObj) -> Void)?
    var addConfirmAction: ((_ employee: [EmployeesObj?]) -> Void)?
    
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupLocalized()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTaps()
        setupValues()
        setupLocalized()
        definesPresentationContext = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Property
    func configure(model: AddEmployeeViewModel) {
        viewModel = model
    }

    func setupValues() {
        codeTextField.text = viewModel.getCode()
        codeTextField.isEnabled = !viewModel.isEnableTextField()

        nameTextField.text = viewModel.getName()
        nameTextField.isEnabled = !viewModel.isEnableTextField()

        phoneTextField.text = viewModel.getPhone()
        phoneTextField.isEnabled = !viewModel.isEnableTextField()

        emailTextField.text = viewModel.getEmail()
        emailTextField.isEnabled = !viewModel.isEnableTextField()

        reportWayTitle.text = viewModel.getReportWay()
        confirmViewTitle.text = viewModel.getEditConfirmTitle()
        addEmployeeTitle.text = viewModel.getEditTitle()

        iconView.backgroundColor = viewModel.getIconViewColor()
        icon.image = viewModel.getIconImage()

        if viewModel.isEnableTextField() {
            confirmView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }

    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        confirmView.roundCorners([.allCorners], radius: 30.0)
        confirmView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        cancelView.roundCorners([.allCorners], radius: 30.0)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        setupUIForTextTiew(codeTextField, image: #imageLiteral(resourceName: "writing"))
        setupUIForTextTiew(nameTextField, image: #imageLiteral(resourceName: "user_blue"))
        setupUIForView(departmentView)
        setupUIForTextTiew(phoneTextField, image: #imageLiteral(resourceName: "phone"))
        setupUIForTextTiew(emailTextField, image: #imageLiteral(resourceName: "mail_blue"))
        setupUIForView(reportWayView)
    }

    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 28.5)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        view.border(width: 1.3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setupUIForTextTiew(_ view: UITextField, image: UIImage?) {
        view.roundCorners([.allCorners], radius: 28.5)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        view.border(width: 1.3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        view.setPadding(rightImage: image, rightPadding: 60, leftPadding: 60)

        view.addCloseToolbar()

        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func setupLocalized() {
        codeTextField.placeholder = "CODE_WORKS".localized
        nameTextField.placeholder = "NAME".localized
        phoneTextField.placeholder = "PHONE_REPORTS".localized
        emailTextField.placeholder = "EMAIL_ADDRESS".localized
        cancelViewTitle.text = "CANCEL".localized
        self.lbl_department.text = "department".localized
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        backgroundView.addGestureRecognizer(tap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)

        if !viewModel.isEnableTextField() {
            let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
            confirmView.addGestureRecognizer(confirmTap)

            let reportWayTap = UITapGestureRecognizer(target: self, action: #selector(showChooseReportWay))
            reportWayView.addGestureRecognizer(reportWayTap)

            let departmentTap = UITapGestureRecognizer(target: self, action: #selector(showChooseDepartment))
            departmentView.addGestureRecognizer(departmentTap)
        }
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmTapped() {
        
        if let str = self.codeTextField.text, str.count == 0{
            let message = String(format: "Please_enter_employee_code".localized, "")
            self.showErrorView(message: message, errorCode: nil)
            return
        }else if let str = self.nameTextField.text, str.count == 0{
            let message = String(format: "Please_enter_employee_name".localized, "")
            self.showErrorView(message: message, errorCode: nil)
            return
        }else if let str = self.phoneTextField.text, str.count == 0{
            let message = String(format: "Please_enter_phone_address".localized, "")
            self.showErrorView(message: message, errorCode: nil)
            return
        }else if viewModel.getDeptIds().count == 0{
            let message = String(format: "Please_select_department".localized, "")
            self.showErrorView(message: message, errorCode: nil)
            return
        }else if viewModel.checkReportwayAddOrNot() == false{
            let message = String(format: "Please_select_reportWay".localized, "")
            self.showErrorView(message: message, errorCode: nil)
            return
        }
        
        
        self.addEmployee(employee: viewModel.getEmployee())
        
    }
    
    func showErrorView(message: String?, errorCode: Int?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: String(errorCode ?? 0), message: message)
        self.present(vc, animated: true, completion: nil)
    }

    @objc func cancelTapped() {
        dismissView()
    }

    @objc func showChooseDepartment() {
        let vc = ViewSource.chooseMultipleListView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        let title = "CHOOSE_DEPARTMENT".localized
        let data = viewModel.getDepartmentTitles()
        let selectedData = viewModel.getSelectedDepartmentsTitles()

        vc.viewModel = MultipleChooseViewModel(title: title, data: data, selectedData: selectedData)

        vc.choosedTypes = { titles in
            self.viewModel.setSelectedDepartments(selectedDepartments: titles)
            self.setupValues()
        }

        self.show(vc, sender: nil)
    }

    @objc func showChooseReportWay() {
        let vc = ViewSource.chooseListView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        let title = "REPORT_WAY_TITLE".localized
        let data = ReportWayType.allReportTypes()

        vc.viewModel = ChooseListViewModel(title: title, data: data)

        vc.choosedType = { _, title in
            self.viewModel.setReportWay(title: title)
            self.setupValues()
        }

        self.show(vc, sender: nil)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == codeTextField {
            viewModel.setCode(textField.text)
        }

        if textField == nameTextField {
            viewModel.setName(textField.text)
        }

        if textField == phoneTextField {
            viewModel.setPhone(textField.text)
        }

        if textField == emailTextField {
            viewModel.setEmail(textField.text)
        }
    }

}

extension AddEmployeeView {
    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight = CGFloat(0.0)

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        UIView.animate(withDuration: 3) {
            self.bottomConstraint.constant = keyboardHeight - 40 - 57 - 18 - 18
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
    
    func addEmployee(employee: EmployeeObj) {
        vc?.view.addSubview(loadingView)

        let addEmpEndpoint = AddEmployeeEndpoint(employee: employee)
        addEmpEndpoint.apiCall { result, error in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                NavigationController.shared?.showSuccessView(message: "EMPLOYEE_ADDED".localized)
                self.addConfirmAction?(result ?? [])
                self.dismissView()
            } else {
                self.viewModel.clearAllField()
                self.setupValues()
                self.showErrorView(message: error?.error_message, errorCode: error?.error_code)
            }
        }
    }
}
