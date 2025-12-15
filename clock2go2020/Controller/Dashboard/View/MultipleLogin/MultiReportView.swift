//
//  MultipleLoginView.swift
//  clock2go2020
//
//  Created by Admin on 5/11/20.
//

import UIKit

class MultiReportView: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var closeImage: UIImageView!

    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var chooseTaskStack: UIStackView!
    @IBOutlet weak var chooseTaskView: UIView!
    @IBOutlet weak var chooseTaskTitle: UILabel!

    @IBOutlet weak var chooseTaskLabel: UILabel!

    @IBOutlet weak var chooseEmployeesView: UIView!
    @IBOutlet weak var chooseEmployeesTitle: UILabel!

    @IBOutlet weak var chooseEmployeesLabel: UILabel!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmViewTitle: UILabel!

    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewTitle: UILabel!

    @IBOutlet weak var commentTextField: UITextField!

    var viewModel: MultiReportViewModel!
    weak var delegate: MultiReportViewDelegate?

    // MARK: Override
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
        configure()
        setupTaps()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Property
    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

        iconView.backgroundColor = viewModel.getImageViewColor()

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        chooseTaskView.roundCorners([.allCorners], radius: 25.0)
        chooseTaskView.layer.borderColor = #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1)
        chooseTaskView.layer.borderWidth = 0.7

        setupUIForView(chooseEmployeesView)
        setupUIForView(confirmView)
        setupUIForView(cancelView)
    }

    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 30.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setTextField() {
        commentTextField.delegate = self
        commentTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        commentTextField.roundCorners([.allCorners], radius: 30)
        commentTextField.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        commentTextField.border(width: 1.3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        commentTextField.borderStyle = .none

        commentTextField.placeholder = "ADD_COMMENT".localized
        commentTextField.placeholderColor(color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        commentTextField.setPadding(rightImage: UIImage(named: "writing"), rightPadding: 50, leftPadding: 50)

        commentTextField.addCloseToolbar()
    }

    func setLocalizedStrings() {
        chooseEmployeesTitle.text = "CHOOSE_EMPLOYEES".localized

        chooseTaskTitle.text = "SELECT_TASK".localized

        confirmViewTitle.text = "CONFIRM".localized
        cancelViewTitle.text = "CANCEL".localized
    }

    func configure() {
        chooseEmployeesLabel.text = viewModel.getChooseEmpsLabel()
        chooseTaskLabel.text = viewModel.getSelectedTaskLabel()

        chooseTaskStack.isHidden = !viewModel.shouldShowChooseTaskView()

        updateAproveView()
    }

    func updateAproveView() {
        confirmView.isUserInteractionEnabled = viewModel.shouldEnableAproveView()
        confirmView.alpha = viewModel.shouldEnableAproveView() ? 1 : 0.5
    }

    func setupTaps() {
        let selectTap = UITapGestureRecognizer(target: self, action: #selector(showMultipleSelectView))
        chooseEmployeesView.addGestureRecognizer(selectTap)

        let chooseTaskTap = UITapGestureRecognizer(target: self, action: #selector(showChooseTaskView))
        chooseTaskView.addGestureRecognizer(chooseTaskTap)

        let closeTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        closeImage.addGestureRecognizer(closeTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(cancelTap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmViewTapped))
        confirmView.addGestureRecognizer(confirmTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmViewTapped() {
        self.dismissView()
        self.delegate?.userDidTapConfirm(viewModel.getReportObj())
    }

    @objc func showMultipleSelectView() {
        let vc = ViewSource.multipleSelectEmpsView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = viewModel.getSelectEmployeeModel()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    @objc func showChooseTaskView() {
        let vc = ViewSource.taskListScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

}

protocol MultiReportViewDelegate: NSObjectProtocol {
    func userDidTapConfirm(_ multiReportObject: MultipleReportObj)
}

extension MultiReportView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 30
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.setRemark(remark: textField.text)
    }

}

extension MultiReportView {

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

extension MultiReportView: ChooseTaskDelegate {
    func userDidSelectTask(_ task: TaskObj?) {
        self.viewModel.setTask(task: task)
        self.configure()
    }
}

extension MultiReportView: SelectEmpsViewDelegate {
    func userDidSelectEmployees(_ emps: [Int]) {
        self.viewModel.setChoosedEmployees(emps: emps)
        self.configure()
    }
}
