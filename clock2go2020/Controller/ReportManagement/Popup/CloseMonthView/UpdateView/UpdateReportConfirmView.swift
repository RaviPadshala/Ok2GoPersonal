//
//  UpdateReportConfirmView.swift
//  clock2go2020
//
//  Created by Admin on 3/23/20.
//

import UIKit

class UpdateReportConfirmView: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!

    @IBOutlet weak var remarkView: UIView!
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

    @IBOutlet weak var writeImg: UIImageView!
    
    @IBOutlet weak var conteinerStackView: UIStackView!
        
    @IBOutlet weak var revachaView: RevachaReportView!
    @IBOutlet weak var revachaRemarkTextField: UITextField!
    @IBOutlet weak var shouldAddRemarkLabel: UILabel!
    
    var viewModel = UpdateReportConfirmViewModel()
    weak var delegate: UpdateReportConfirmViewDelegate?
    var day: DateComponents?

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
        setupValues()
        
        revachaTaps()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    func setupUI() {
        iconView.roundCorners([.allCorners], radius: 40)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        contentView.roundCorners([.topLeft, .topRight], radius: 30)

        setupUIForView(remarkView)
        remarkTextField.addCloseToolbar()

        setupUIForView(logoutTimeView)

        confirmView.roundCorners([.allCorners], radius: 20.0)
        confirmView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        cancelView.roundCorners([.allCorners], radius: 20.0)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        setupUIForView(taskView)
        setupUIForView(loginTimeView)
        setupUIForView(dateView)
        setupUIForView(revachaRemarkTextField)

        if viewModel.shouldDIsableConfirmView() {
            confirmView.alpha = 0.5
            confirmView.isUserInteractionEnabled = false
        } else {
            confirmView.alpha = 1
            confirmView.isUserInteractionEnabled = true
        }
        
        revachaRemarkTextField.delegate = self
        remarkTextField.delegate = self
    }
    
    func revachaTaps() {
        revachaView.trnsTypeTapped = { [weak self]  in
           
            self?.chooseTrnsType()
        }
        revachaView.clientTapped = { [weak self]  in
            self?.chooseCLient()
        }
        revachaView.eventTapped = { [weak self] in
            self?.chooseEvent()
        }
        
        revachaView.reportDidChanged = { [weak self] (complete) in
            if complete {
                self?.confirmView.alpha = 1
                self?.confirmView.isUserInteractionEnabled = true
            } else {
                self?.confirmView.alpha = 0.5
                self?.confirmView.isUserInteractionEnabled = false
            }
        }
        revachaView.reportRemark = { [weak self] (remark) in
            self?.viewModel.setRemark(remark:  remark)
            self?.setupValues()
        }
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
        revachaRemarkTextField.placeholder = "ADD_REMARK".localized
        shouldAddRemarkLabel.text = "MUST_NOTE".localized
    }

    func setupValues() {
        remarkTextField.text = viewModel.getRemark()
        logoutTimeTitle.text = viewModel.getLogoutTime()
        taskTitle.text = viewModel.getTaskName()
        loginTimeTitle.text = viewModel.getLoginTime()
        dateTitle.text = viewModel.getDate()

        taskView.isHidden = !viewModel.shouldShowTaskFeature()
        remarkTextField.isHidden = !viewModel.shouldShowTaskFeature()
        writeImg.isHidden = !viewModel.shouldShowTaskFeature()
        remarkView.isHidden = !viewModel.shouldShowTaskFeature()
        
        revachaView.isHidden = !viewModel.isRevacha
        revachaRemarkTextField.isHidden = !viewModel.isRevacha
        revachaRemarkTextField.addCloseToolbar(onClose: nil)
        
        revachaRemarkTextField.text = viewModel.getRemark()
        shouldAddRemarkLabel.isHidden = viewModel.shouldAddRemarkLabelHidden()
        
        if viewModel.shouldDIsableConfirmView() {
            confirmView.alpha = 0.5
            confirmView.isUserInteractionEnabled = false
        } else {
            confirmView.alpha = 1
            confirmView.isUserInteractionEnabled = true
        }

        if viewModel.shouldDisableEventClientViews() {
            revachaView.clientView.alpha = 0.5
            revachaView.clientView.isUserInteractionEnabled = false
            revachaView.clientTitle.text = "SELECT_CLIENT".localized
            revachaView.eventView.alpha = 0.5
            revachaView.eventView.isUserInteractionEnabled = false
            revachaView.eventTitle.text = "SELECT_AN_EVENT".localized
        } else {
            revachaView.clientView.alpha = 1.0
            revachaView.clientView.isUserInteractionEnabled = true
            revachaView.eventView.alpha = 1.0
            revachaView.eventView.isUserInteractionEnabled = true
        }
    }

    func setupTaps() {
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

        if day == Calendar.current.dateComponents([.day], from: Date()) {
            vc.config(isDate: false, maxDate: Date())
        } else {
            vc.config(isDate: false, maxDate: nil)
        }

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
        vc.maximumDate = Date()

        vc.selectedValue = { [weak self] (value) in
            if let date = value {
                self?.day = Calendar.current.dateComponents([.day], from: date)
                self?.viewModel.setDate(date: date.toString(format: "dd/MM/yyyy"))
                self?.setupValues()
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
            if self.viewModel.isRevacha {
                self.stackViewBottomContraint.constant = keyboardHeight + 15 - 40 - 40
                self.view.layoutIfNeeded()
                return
            }
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
        if !viewModel.isRevacha {
            viewModel.setRemark(remark: remarkTextField.text)
        }
        if viewModel.shouldShowTaskError() && !(viewModel.shouldDisableEventClientViews() == true){
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

extension UpdateReportConfirmView: ChooseTaskDelegate {
    func userDidSelectTask(_ task: TaskObj?) {
        viewModel.setTask(task: task)
        setupValues()
    }
}

protocol UpdateReportConfirmViewDelegate: NSObjectProtocol {
    func updateDayReport(_ report: EmpDayReportsObj)
}

extension UpdateReportConfirmView {
    
    func chooseTrnsType() {
        //show drop down view
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve
        
        let top   = conteinerStackView.convert(revachaView.frame.origin, to: view)
        let left =  contentView.center.x + (revachaView.transactionTypeView.frame.size.width + 16.5)
        let width = revachaView.transactionTypeView.frame.size.width

        let viewModel = SortingListViewModel(type: .revacha)

        chooseVC.configure(viewModel: viewModel, top: top.y , left: left, width: width)
        
        chooseVC.choosedType = { index, title, _ in
            self.revachaView.transactionTypeTitle.text = title
            self.viewModel.setTrnsType(index + 1)
            self.setupValues()
        }
        present(chooseVC, animated: true, completion: nil)
    }
    
    func chooseCLient() {
        //show drop down view
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve
        
        let top   = conteinerStackView.convert(revachaView.frame.origin, to: view)
        let left = contentView.center.x + 6.5
        let width = revachaView.clientView.frame.size.width

        let viewModel = SortingListViewModel(type: .revachaClient)

        chooseVC.configure(viewModel: viewModel, top: top.y , left: left, width: width)
        
        chooseVC.choosedType = { index, title, _ in
            self.revachaView.clientTitle.text = title
            let task = TaskListViewModel().taskListItems[index].task
            self.viewModel.setTask(task: task)
            self.setupValues()
        }
        present(chooseVC, animated: true, completion: nil)
    }
    
    func chooseEvent() {
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve

        let top = conteinerStackView.convert(revachaView.frame.origin, to: view)
        let left = contentView.center.x - revachaView.eventView.frame.width - 3.0
        let width = revachaView.eventView.frame.width
        
        let viewModel = SortingListViewModel(type: .revachaEvent)
        
        chooseVC.configure(viewModel: viewModel, top: top.y, left: left, width: width)
        
        chooseVC.choosedType = { index, title, _ in
            self.revachaView.eventTitle.text = title
            let event = CompaniesDataManager.shared.getEvents()?[index]
            self.viewModel.setEvent(event)
            self.setupValues()
        }
        present(chooseVC, animated: true, completion: nil)
    }
}

extension UpdateReportConfirmView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == revachaRemarkTextField {
            guard let text = textField.text, let textRange = Range(range, in: text) else { return true }
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.count <= 500 {
                viewModel.setRemark(remark: updatedText)
                setupValues()
            }
            return false
        } else if textField == remarkTextField {
            guard let text = textField.text, let textRange = Range(range, in: text) else { return true }
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.count <= 30 {
                viewModel.setRemark(remark: updatedText)
                setupValues()
            }
            return false
        }
        return true
    }
}
