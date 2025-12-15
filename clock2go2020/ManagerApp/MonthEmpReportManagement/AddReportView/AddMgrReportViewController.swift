//
//  AddMgrReportViewController.swift
//  clock2go2020
//
//  Created by Gleb on 17.12.2020.
//

import UIKit

class AddMgrReportViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!

    @IBOutlet weak var remarkTextField: UITextField!
    @IBOutlet weak var logoutTimeView: UIView!
    @IBOutlet weak var logoutTimeTitle: UILabel!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!

    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var loginTimeView: UIView!
    @IBOutlet weak var loginTimeTitle: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateTitle: UILabel!

    var viewModel = AddMgrReportViewModel()
    weak var delegate: AddMgrReportViewDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTaps()
        setupLocalizations()
        setupValues()    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    func setupUI() {
        iconView.roundCorners([.allCorners], radius: 40)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        contentView.roundCorners([.topLeft, .topRight], radius: 30)

        setupUIForView(remarkTextField)
        remarkTextField.addCloseToolbar()

        setupUIForView(logoutTimeView)

        confirmView.roundCorners([.allCorners], radius: 20.0)
        confirmView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        cancelView.roundCorners([.allCorners], radius: 20.0)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        setupUIForView(taskView)
        setupUIForView(loginTimeView)
        setupUIForView(dateView)
    }

    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 20.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        view.border(width: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setupLocalizations() {
        confirmTitle.text = "SAVE".localized
        cancelTitle.text = "CANCEL".localized
        remarkTextField.placeholder = "ADD_COMMENT".localized
    }

    func setupValues() {
        remarkTextField.text = viewModel.getRemark()
        logoutTimeTitle.text = viewModel.getLogoutTime()
        taskTitle.text = viewModel.getTaskName()
        loginTimeTitle.text = viewModel.getLoginTime()
        dateTitle.text = viewModel.getDate()

        taskView.isHidden = !viewModel.shouldShowTaskFeature()
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(cancelTap)

        let taskTap = UITapGestureRecognizer(target: self, action: #selector(selectTaskTapped))
        taskView.addGestureRecognizer(taskTap)

        let loginTap = UITapGestureRecognizer(target: self, action: #selector(loginTimePicker))
        loginTimeView.addGestureRecognizer(loginTap)

        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(logoutTimePicker))
        logoutTimeView.addGestureRecognizer(logoutTap)

        let dateTap = UITapGestureRecognizer(target: self, action: #selector(showToDatePicker))
        dateView.addGestureRecognizer(dateTap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        confirmView.addGestureRecognizer(confirmTap)
    }

    @objc func selectTaskTapped() {
        let vc = ViewSource.taskListScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = TaskListViewModel(showAddTask: false)
        vc.delegate = self

        self.present(vc, animated: true, completion: nil)
    }

    @objc func loginTimePicker() {
        showTimePicker(true)
    }

    @objc func logoutTimePicker() {
        showTimePicker(false)
    }

    func showTimePicker(_ isLogin: Bool) {
        let vc = ViewSource.datePickerView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.config(isDate: false, maxDate: nil)
        vc.selectedValue = { value in
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            if let date = value {
                if isLogin {
                    self.viewModel.setLoginTime(time: formatter.string(from: date))
                } else {
                    self.viewModel.setLogoutTime(time: formatter.string(from: date))
                }
                self.setupValues()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }

    @objc func showToDatePicker() {
        let vc = ViewSource.datePickerView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.minimumDate = viewModel.getMinimumDateForReportUpdate()
        vc.maximumDate = viewModel.getMaximumDateForReportUpdate()

        vc.selectedValue = { value in
            if let date = value {
                self.viewModel.setDate(date: date.toString(format: "dd/MM/yyyy"))
                self.setupValues()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight = CGFloat(0.0)

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        UIView.animate(withDuration: 3) {
            self.stackViewBottomContraint.constant = keyboardHeight + 15 - 40 - 40 - 40
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide() {
        viewModel.setRemark(remark: remarkTextField.text)

        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.stackViewBottomContraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }

    @objc func confirmTapped() {
        viewModel.setRemark(remark: remarkTextField.text)
        if viewModel.shouldShowTaskError() {
            self.showErrorView(message: "421".localized, errorCode: nil)
        } else {
            dismissView()
            delegate?.updateDayReport(viewModel.getReport())
        }
    }

    func showErrorView(message: String?, errorCode: Int?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: String(errorCode ?? 0), message: message)
        self.present(vc, animated: true, completion: nil)
    }
}

extension AddMgrReportViewController: ChooseTaskDelegate {
    func userDidSelectTask(_ task: TaskObj?) {
        viewModel.setTask(task: task)
        setupValues()
    }
}

protocol AddMgrReportViewDelegate: NSObjectProtocol {
    func updateDayReport(_ report: GetMgrEmpReportsObj)
}
