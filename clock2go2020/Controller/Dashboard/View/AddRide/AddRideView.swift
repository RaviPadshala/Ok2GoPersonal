//
//  AddRideView.swift
//  clock2go2020
//
//  Created by Admin on 4/2/20.
//

import UIKit

class AddRideView: UIViewController {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var addRideTitle: UILabel!

    @IBOutlet weak var rideTypeView: UIView!
    @IBOutlet weak var rideTypeTitle: UILabel!

    @IBOutlet weak var valueTextField: UITextField!

    @IBOutlet weak var attachStackView: UIStackView!
    @IBOutlet weak var attachImage: UIImageView!
    @IBOutlet weak var attachView: UIView!
    @IBOutlet weak var attachLabel: UILabel!
    @IBOutlet weak var attachedTableView: UITableView!
    @IBOutlet weak var attachedTableViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!

    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!

    var viewModel: AddRideViewModel?

    var addRideTapped: ((_ type: RideType, _ param: String) -> Void)?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDafaultValue()

        setupUI()
        setupTableView()
        setupTaps()
        setupTextField()
        reloadView()
        setupLozalized()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Property
    func setupDafaultValue() {
        viewModel?.setRideType(type: .distance)
        rideTypeView.isUserInteractionEnabled = false
        rideTypeView.alpha = 0.5
    }

    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        setupUIForView(confirmView, withBorder: false)
        setupUIForView(cancelView, withBorder: false)
        setupUIForView(rideTypeView)

        setupUIForView(attachView)
        attachStackView.addBackground(color: #colorLiteral(red: 0.9212146401, green: 0.9490351081, blue: 0.9671724439, alpha: 1), corners: 30.0)

        refreshTableViewHeight(animate: false)
    }

    func setupUIForView(_ view: UIView, withBorder: Bool = true) {
        view.roundCorners([.allCorners], radius: 30.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        if withBorder {
            view.border(width: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        }
    }

    func setupTableView() {
        let cell = UINib(nibName: AttachedFileCell.identifier, bundle: nil)
        attachedTableView.register(cell, forCellReuseIdentifier: AttachedFileCell.identifier)

        attachedTableView.delegate = self
        attachedTableView.dataSource = self

        attachedTableView.tableFooterView = UIView()

        attachedTableView.flashScrollIndicators()
    }

    func setupTextField() {
        valueTextField.delegate = self
        valueTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        valueTextField.keyboardType = .decimalPad

        valueTextField.roundCorners([.allCorners], radius: 30)
        valueTextField.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        valueTextField.border(width: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        valueTextField.borderStyle = .none

        valueTextField.placeholder = "ADD_COMMENT".localized
        valueTextField.placeholderColor(color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        valueTextField.setPadding(rightImage: UIImage(named: "location"), rightPadding: 50, leftPadding: 50)

        valueTextField.addCloseToolbar()
    }

    func setupLozalized() {
        confirmTitle.text = "CONFIRM".localized
        cancelTitle.text = "CANCEL".localized
        addRideTitle.text = "ADD_A_TRIP".localized
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        confirmView.addGestureRecognizer(confirmTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(cancelTap)

        let chooseTap = UITapGestureRecognizer(target: self, action: #selector(chooseRideType))
        rideTypeView.addGestureRecognizer(chooseTap)

        let attachTap = UITapGestureRecognizer(target: self, action: #selector(attachTapped))
        attachView.addGestureRecognizer(attachTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmTapped() {
        dismissView()

        if let type = viewModel?.getRideType(), let value = viewModel?.getValueTitle() {
            addRideTapped?(type, value)
        }
    }

    @objc func chooseRideType() {
        let vc = ViewSource.chooseListView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = viewModel?.getModelForChooseList()

        vc.choosedType = { _, title in
            self.viewModel?.setRideType(title: title)
            self.reloadView()
        }

        self.present(vc, animated: true, completion: nil)
    }

    @objc func attachTapped() {
        let vc = ViewSource.attachConfirmView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.attachedFile = { media in
            self.viewModel?.addAttachedMedia(media: media)
            self.reloadTableView()
        }
        self.present(vc, animated: true, completion: nil)
    }

    func reloadView() {
        confirmView.isUserInteractionEnabled = !(viewModel?.shouldDisableConfirmView() ?? true)
        confirmView.alpha = (viewModel?.shouldDisableConfirmView() ?? true) ? 0.5 : 1

        rideTypeTitle.text = viewModel?.getRideTypeTitle()
        valueTextField.text = viewModel?.getValueTitle()
        valueTextField.placeholder = viewModel?.getValuePlaceholder()

        if let image = viewModel?.getValueImage() {
            valueTextField.setPadding(rightImage: image, rightPadding: 50, leftPadding: 50)
        }

        attachStackView.isHidden = !(viewModel?.shouldShowAttachView() ?? false)

    }
}

extension AddRideView: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel?.setValue(textField.text ?? "")
        reloadView()
    }

}

extension AddRideView {

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

extension AddRideView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getAttachedFiles().count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AttachedFileCell.identifier, for: indexPath) as? AttachedFileCell,
            let cellViewModel = viewModel?.getModelForItemAt(index: indexPath.row) {

            cell.config(viewModel: cellViewModel)
            cell.selectionStyle = .none
            cell.removeAction = {
                self.viewModel?.removeAttachedFile(index: indexPath.row)
                self.reloadTableView()
            }

            return cell
        }

        return UITableViewCell()
    }

    func reloadTableView() {
        refreshTableViewHeight()
        attachedTableView.reloadData()
        reloadAttachView()
    }

    func refreshTableViewHeight(animate: Bool = true) {
        let duration = animate ? 0.3 : 0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: duration) {
            self.attachedTableViewHeightConstraint.constant = self.viewModel?.getAttachedTableViewHeight() ?? 0
            self.view.layoutIfNeeded()
        }
    }

    func reloadAttachView() {
        attachView.isUserInteractionEnabled = !(viewModel?.shouldDisableAttachView() ?? true)

        if let color = viewModel?.getAttachViewColor(),
            let image = viewModel?.getAttachViewImage() {
            attachView.border(width: 1.3, color: color.cgColor)
            attachLabel.textColor = color
            attachImage.image = image
        }
    }

}
