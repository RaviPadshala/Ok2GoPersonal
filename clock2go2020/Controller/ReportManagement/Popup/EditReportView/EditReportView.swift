//
//  EditReportView.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/25/20.
//

import UIKit
import AnyCodable

class EditReportView: UIViewController {
    
    // MARK: Outlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!
    
    @IBOutlet weak var remarkTextField: UITextField!
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var taskTitle: UILabel!
    
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!
    
    @IBOutlet weak var removeView: UIView!
    @IBOutlet weak var removeTitle: UILabel!
    
    @IBOutlet weak var rejectView: UIView!
    @IBOutlet weak var rejectTitle: UILabel!
    
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var taskIcon: UIImageView!
    
    @IBOutlet weak var revachaView: RevachaReportView!
    @IBOutlet weak var holocustReportView: HolocustReportView!
    @IBOutlet weak var writeImg: UIImageView!
    
    @IBOutlet weak var editStackView: UIStackView!
    
    @IBOutlet weak var conteinerStackView: UIStackView!
    
    // MARK: Property
    var viewModel: EditReportViewModel!
    var updateReports: ((_ empReports: [String: EmpDayReportsObj]?) -> Void)?
    var selectedDay: DateComponents?
    weak var delegate: EditReportViewDelegate?
    
    // MARK: Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        setupUI()
        setupTextField()
        setupLocalizations()
        setupTaps()
        setupValues()
        updateReportList()
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
        
        setupUIForView(confirmView)
        setupUIForView(cancelView)
        setupUIForView(rejectView)
        
        removeView.roundCorners([.allCorners], radius: 16.5)
        removeView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.9837575555, green: 0.8835536838, blue: 0.8821358085, alpha: 1))
        
        setupUIForView(remarkView)
        remarkTextField.addCloseToolbar()
        
        setupUIForView(taskView)
        setupUIForView(timeView)
        
        if viewModel.shouldDIsableConfirmView() {
            confirmView.alpha = 0.5
            confirmView.isUserInteractionEnabled = false
        } else {
            confirmView.alpha = 1
            confirmView.isUserInteractionEnabled = true
        }
        
    }
    
    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 16.5)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        view.border(width: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }
    
    func setupDisableUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 16.5)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        view.border(width: 1, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    }
    
    func setupTextField() {
        remarkTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        remarkTextField.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.setRemark(remark: textField.text ?? "")
    }
    
    func setupLocalizations() {
        remarkTextField.placeholder = "ADD_COMMENT".localized
        taskTitle.text              = "SELECT_TASK".localized
        timeTitle.text              = "--:--"
        removeTitle.text            = "DELETE".localized
        confirmTitle.text           = "SAVE".localized
        cancelTitle.text            = "CANCEL".localized
        rejectTitle.text            = "REJECT".localized
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
    
    func holocustTaps() {
        self.holocustReportView.trnsTypeTapped = { [weak self]  in
            self?.chooseHolocustTrnsType()
        }
        holocustReportView.therapyTapped = { [weak self]  in
            self?.chooseTherapy()
        }
        holocustReportView.eventTapped = { [weak self] in
            self?.chooseHolocustEvent()
        }
        
        holocustReportView.reportDidChanged = { [weak self] (complete) in
            if complete {
                self?.confirmView.alpha = 1
                self?.confirmView.isUserInteractionEnabled = true
            } else {
                self?.confirmView.alpha = 0.5
                self?.confirmView.isUserInteractionEnabled = false
            }
        }
        holocustReportView.reportRemark = { [weak self] (remark) in
            self?.viewModel.setRemark(remark:  remark)
            self?.setupValues()
        }
    }
    
    
    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(cancelTap)
        
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmAction))
        confirmView.addGestureRecognizer(confirmTap)
        
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(timePicker))
        timeView.addGestureRecognizer(timeTap)
        
        let taskTap = UITapGestureRecognizer(target: self, action: #selector(selectTaskTapped))
        taskView.addGestureRecognizer(taskTap)
        
        let removeTAp = UITapGestureRecognizer(target: self, action: #selector(removeAction))
        removeView.addGestureRecognizer(removeTAp)
        
        let rejectTap = UITapGestureRecognizer(target: self, action: #selector(rejectAction))
        rejectView.addGestureRecognizer(rejectTap)
        
        revachaTaps()
        self.holocustTaps()
    }
    
    func setupValues() {
        remarkTextField.text = viewModel.getRemark()
        taskTitle.text = viewModel.getTask()
        taskTitle.textColor = viewModel.getTaskColor()
        timeTitle.text = viewModel.getTime()
        iconView.backgroundColor = viewModel.getColor()
        taskView.isUserInteractionEnabled = viewModel.shouldEnableTask()
        taskView.isHidden = !viewModel.shouldShowChooseTaskView()
        removeView.isHidden = !viewModel.shouldShowRemoveView()
        rejectView.isHidden = viewModel.shouldShowRejectButton()
        selectedDay = Calendar.current.dateComponents([.day], from: viewModel.date ?? Date())
        confirmView.isHidden = !(CompaniesDataManager.shared.hasReportEditFeature() || CompaniesDataManager.shared.hasReportAddFeature())
        print("Current day : \(String(describing: selectedDay))")
        
        if viewModel.getReportIsEmpty() {
            removeView.isHidden = true
            rejectView.isHidden = true
        }
        
        if !viewModel.shouldEnableTask() {
            setupDisableUIForView(taskView)
            
            let image = taskIcon.image?.withRenderingMode(.alwaysTemplate)
            taskIcon.image = image?.maskWithColor(color: viewModel.getTaskColor())
        }
        
        revachaView.isHidden = !viewModel.shouldShowRevachaView()
        revachaView.clientTitle.text = viewModel.getTask()
        revachaView.transactionTypeTitle.text = viewModel.getTrnsType()
        revachaView.eventTitle.text = viewModel.getEventName()
        
        if CompaniesDataManager.shared.isHolocaustSurvivors(){
            revachaView.isHidden = true
            self.holocustReportView.isHidden = false
            
            self.holocustReportView.eventTitle.text = viewModel.getTask()
            self.holocustReportView.transactionTypeTitle.text = viewModel.getHoloCustTrnsType()
            self.holocustReportView.therapyTitle.text = viewModel.getHoloCustTherapyType()
            
            self.taskView.isHidden = true
        }else{
            revachaView.isHidden = false
            self.holocustReportView.isHidden = true
        }
        
        if viewModel.eventButtonHidden() {
            revachaView.hideEventButton()
        }
        
        if revachaView.transactionTypeTitle.text == "3" {
            revachaView.clientView.alpha = 0.5
            revachaView.clientView.isUserInteractionEnabled = false
            revachaView.clientTitle.text = ""
        }
        
        editStackView.isHidden = viewModel.shouldShowRevachaView()
        writeImg.isHidden = viewModel.shouldShowRevachaView()
        
        if viewModel.getReportType() == "2" && viewModel.buttonsShouldBeDisabled() && viewModel.isRevacha {
            revachaView.eventView.isUserInteractionEnabled = false
            revachaView.eventView.alpha = 0.5
            revachaView.clientView.isUserInteractionEnabled = false
            revachaView.clientView.alpha = 0.5
        }
        
        if ((!CompaniesDataManager.shared.hasReportEditFeature()) && CompaniesDataManager.shared.hasReportDeleteFeature() ) {
            if CompaniesDataManager.shared.hasReportAddFeature(){
                if viewModel.getTime() == "--:--"{
                    revachaView.isUserInteractionEnabled = true
                    editStackView.isUserInteractionEnabled = true
                    timeView.isUserInteractionEnabled = true
                    confirmView.isHidden = false
                }else{
                    revachaView.isUserInteractionEnabled = false
                    editStackView.isUserInteractionEnabled = false
                    timeView.isUserInteractionEnabled = false
                    confirmView.isHidden = true
                }
           
            }else{
                revachaView.isUserInteractionEnabled = false
                editStackView.isUserInteractionEnabled = false
                timeView.isUserInteractionEnabled = false
                confirmView.isHidden = true
            }
            
            //confirmView.isHidden = true
        }
    }
    
    @objc func timePicker() {
        showTimePicker(true)
    }
    
    @objc func selectTaskTapped() {
        let vc = ViewSource.taskListScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.viewModel = TaskListViewModel(showAddTask: false)
        vc.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func showTimePicker(_ isLogin: Bool) {
        let vc = ViewSource.datePickerView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        if Calendar.current.dateComponents([.day, .month], from: Date()) == Calendar.current.dateComponents([.day, .month], from: viewModel.date ?? Date()) {
            vc.config(isDate: false, maxDate: Date())
        } else {
            vc.config(isDate: false, maxDate: nil)
        }
        vc.selectedValue = { value in
            if let date = value {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                self.setupValues()
                self.viewModel.setTime(time: formatter.string(from: date))
                self.timeTitle.text = self.viewModel.getTime()
                //self.setupValues()
            }
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmAction() {
        if viewModel.shouldShowTaskError() {
            self.showErrorView(message: "421".localized, errorCode: nil)
        } else if viewModel.shouldShowRemarkError() {
            self.showErrorView(message: "must_report_with_comment_error".localized, errorCode: nil)
        } else if viewModel.shouldShowDateError() {
            self.showErrorView(message: "must_report_with_date_error".localized, errorCode: nil)
        } else if viewModel.shouldShowTimeError() {
            self.showErrorView(message: "must_report_with_time_error".localized, errorCode: nil)
        }else if  viewModel.getMgrEmployeeId() == 0 {
            viewModel.saveReport()
            dismissView()
        } else if viewModel.getReportIsEmpty() {
            viewModel.addMgrReport()
            dismissView()
        } else {
            viewModel.saveMgrReport(status: 4)
            dismissView()
        }
    }
    
    @objc func rejectAction() {
        if viewModel.shouldShowTaskError() {
            self.showErrorView(message: "421".localized, errorCode: nil)
        } else {
            viewModel.saveMgrReport(status: 3)
            dismissView()
        }
    }
    
    @objc func removeAction() {
        if  viewModel.getMgrEmployeeId() == 0 {
            viewModel.removeReport()
        } else {
            viewModel.removeMgrReport()
        }
      
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight = CGFloat(0.0)
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        
        UIView.animate(withDuration: 3) {
            self.stackViewBottomContraint.constant = keyboardHeight + 15 - 40 - 20
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
    
    func showErrorView(message: String?, errorCode: Int?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: String(errorCode ?? 0), message: message)
        self.present(vc, animated: true, completion: nil)
    }
    
    func updateReportList() {
        self.viewModel.updateReports = { [weak self] (reports) in
            self?.updateReports?(reports)
            self?.delegate?.updateReportsDidChanged(reports)
            print("didEditReport  EditReportViewModelDelegate")
        }
    }
}

protocol EditReportViewDelegate: NSObjectProtocol {
    func updateReportsDidChanged(_ empReports: [String: EmpDayReportsObj]?)
}

extension EditReportView: ChooseTaskDelegate {
    
    func userDidSelectTask(_ task: TaskObj?) {
        if let task = task {
            viewModel.setTask(task: task)
        }
        setupValues()
    }
}

extension EditReportView: EditReportViewModelDelegate {
    func didEditReport(_ empReports: [String: EmpDayReportsObj]?) {
        self.dismissView()
        updateReports?(empReports)
    }

    func didRemoveReport(_ empReports: [String: EmpDayReportsObj]?) {
        self.dismissView()
        updateReports?(empReports)
    }
    
    func didReceiveError(_ error: ErrorObject?) {
        self.dismissView()
        NavigationController.shared?.showErrorView(error: error)
    }
    
}

extension EditReportView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 30
    }
}

extension EditReportView {
    func chooseTrnsType() {
        //show drop down view
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve
        
        let top   = conteinerStackView.convert(revachaView.frame.origin, to: self.view)
        let left: CGFloat
        if viewModel.eventButtonHidden() {
            left = contentView.center.x + revachaView.transactionTypeView.frame.width * 0.4 - 7.0
        } else {
            left = contentView.center.x + (revachaView.transactionTypeView.frame.size.width + 8.5)
        }
        let width = revachaView.transactionTypeView.frame.size.width

        let model = SortingListViewModel(type: .revacha)

        chooseVC.configure(viewModel: model, top: top.y , left: left, width: width)
        
        chooseVC.choosedType = { index, title, _ in
            self.revachaView.transactionTypeTitle.text = title
            if index == 2{
                self.revachaView.clientView.isUserInteractionEnabled = false
                self.revachaView.clientView.alpha = 0.5
                self.revachaView.clientTitle.text = "SELECT_CLIENT".localized
            } else {
                self.revachaView.clientView.isUserInteractionEnabled = true
                self.revachaView.clientView.alpha = 1
            }
            print("\(title)")
            self.viewModel.setTrnsType(type: (index + 1))
            self.setupValues()
        }
        self.present(chooseVC, animated: true, completion: nil)
    }
    
    func chooseCLient() {
        //show drop down view
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve
        
        let top = conteinerStackView.convert(revachaView.frame.origin, to: self.view)
        var left: CGFloat
        if viewModel.eventButtonHidden() {
            left = contentView.center.x - revachaView.clientView.frame.width * 0.7 + 7.0
        } else {
            left = contentView.center.x - 4
        }
        let width = revachaView.clientView.frame.size.width
        
        let model = SortingListViewModel(type: .revachaClient)

        chooseVC.configure(viewModel: model, top: top.y , left: left, width: width)
        
        chooseVC.choosedType = { index, title, _ in
            self.revachaView.clientTitle.text = title
            let task = TaskListViewModel().taskListItems[index].task
            self.viewModel.setTask(task: task)
            self.setupValues()
        }
        self.present(chooseVC, animated: true, completion: nil)
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
    
    func chooseHolocustTrnsType() {
        //show drop down view
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve
        
        let top   = conteinerStackView.convert(self.holocustReportView.frame.origin, to: view)
        let left =  contentView.center.x + (self.holocustReportView.transactionTypeView.frame.size.width + 16.5)
        let width = self.holocustReportView.transactionTypeView.frame.size.width

        let viewModel = SortingListViewModel(type: .holocust)

        chooseVC.configure(viewModel: viewModel, top: top.y , left: left, width: width)
        
        chooseVC.choosedType = { index, title, _ in
            self.revachaView.transactionTypeTitle.text = title
            self.viewModel.setTrnsType(type: index)
            self.setupValues()
        }
        present(chooseVC, animated: true, completion: nil)
    }
    
    func chooseTherapy() {
        
        //show drop down view
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve
        
        let top   = conteinerStackView.convert(self.holocustReportView.frame.origin, to: view)
        let left = contentView.center.x + 6.5
        let width = self.holocustReportView.therapyView.frame.size.width

        let viewModel = SortingListViewModel(type: .holocustTherapy, trasType: self.viewModel.getIntTrnsType())
        chooseVC.configure(viewModel: viewModel, top: top.y , left: left, width: width)
//        chooseVC.viewModel?.selectedHolocustTransType = self.viewModel.getIntTrnsType()
        
        chooseVC.choosedType = { index, title, _ in
            self.holocustReportView.therapyTitle.text = title
            self.viewModel.setTheraphyType(type: index)
            self.setupValues()
        }
        present(chooseVC, animated: true, completion: nil)
    }
    
    func chooseHolocustEvent() {
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve

        let top = conteinerStackView.convert(self.holocustReportView.frame.origin, to: view)
        let left = contentView.center.x - self.holocustReportView.eventView.frame.width - 3.0
        let width = self.holocustReportView.eventView.frame.width
        
        let viewModel = SortingListViewModel(type: .holocustEvent, trasType: self.viewModel.getIntTrnsType(), therapyType: self.viewModel.getIntTherapyType())
        
        chooseVC.configure(viewModel: viewModel, top: top.y, left: left, width: width)
//        chooseVC.viewModel?.selectedHolocustTherapyType = self.viewModel.getIntTherapyType()
//        chooseVC.viewModel?.selectedHolocustTransType = self.viewModel.getIntTrnsType()
        
        chooseVC.choosedType = { index, title, taskItem in
            self.holocustReportView.eventTitle.text = title
            let task = taskItem!.task
            self.viewModel.setTask(task: task)
            self.setupValues()
        }
        present(chooseVC, animated: true, completion: nil)
    }
}
