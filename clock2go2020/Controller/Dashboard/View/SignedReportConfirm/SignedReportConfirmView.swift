//
//  SignedReportConfirmView.swift
//  clock2go2020
//
//  Created by Admin on 4/28/20.
//

import UIKit

class SignedReportConfirmView: UIViewController {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var absenceTitle: UILabel!

    @IBOutlet weak var absenceTypeView: UIView!
    @IBOutlet weak var absenceTypeTitle: UILabel!

    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var fromDateTitle: UILabel!

    @IBOutlet weak var toDateView: UIView!
    @IBOutlet weak var toDateTitle: UILabel!

    @IBOutlet weak var attachStackView: UIStackView!
    @IBOutlet weak var attachImage: UIImageView!
    @IBOutlet weak var attachView: UIView!
    @IBOutlet weak var attachLabel: UILabel!
    @IBOutlet weak var attachedTableView: UITableView!
    @IBOutlet weak var attachedTableViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var attachRequiredTitle: UILabel!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmViewTitle: UILabel!

    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewTitle: UILabel!

    var viewModel = SignedReportConfirmViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        setLocalizedStrings()
        setDateString()
        setupTaps()
        reloadConfirmView()
    }

    // MARK: Property
    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        confirmView.roundCorners([.allCorners], radius: 30.0)
        confirmView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        cancelView.roundCorners([.allCorners], radius: 30.0)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        setupUIForView(absenceTypeView)
        setupUIForView(fromDateView)
        setupUIForView(toDateView)
        setupUIForView(attachView)

        attachStackView.addBackground(color: #colorLiteral(red: 0.9212146401, green: 0.9490351081, blue: 0.9671724439, alpha: 1), corners: 30.0)

        refreshTableViewHeight(animate: false)

        if CompaniesDataManager.shared.getSpecialClientType() == 3665 {
            absenceTitle.isHidden = true

        }
    }

    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 30)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        view.border(width: 1.3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setupTableView() {
        let cell = UINib(nibName: AttachedFileCell.identifier, bundle: nil)
        attachedTableView.register(cell, forCellReuseIdentifier: AttachedFileCell.identifier)

        attachedTableView.delegate = self
        attachedTableView.dataSource = self

        attachedTableView.tableFooterView = UIView()

        attachedTableView.flashScrollIndicators()
    }

    func setLocalizedStrings() {
        if CompaniesDataManager.shared.getSpecialClientType() == 3665 {
            absenceTypeTitle.text = "MONTH_REPORT".localized
            absenceTypeTitle.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            absenceTypeTitle.text = "ABSENCE_TYPE_TITLE".localized
        }
        absenceTitle.text = "ABSENCE_REPORT_TITLE".localized
        attachLabel.text = "ATTACH_FILE_TITLE".localized
        attachRequiredTitle.text = "ATTACH_REQUIRED_TITLE".localized
        confirmViewTitle.text = "CONFIRM".localized
        cancelViewTitle.text = "CANCEL".localized
    }

    func setDateString() {
        fromDateTitle.text = viewModel.getFromDateString()
        toDateTitle.text = viewModel.getToDateString()
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        backgroundView.addGestureRecognizer(tap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        confirmView.addGestureRecognizer(confirmTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)

        let attachTap = UITapGestureRecognizer(target: self, action: #selector(attachTapped))
        attachView.addGestureRecognizer(attachTap)

        let fromDateTap = UITapGestureRecognizer(target: self, action: #selector(showFromDatePicker))
        fromDateView.addGestureRecognizer(fromDateTap)

        let toDateTap = UITapGestureRecognizer(target: self, action: #selector(showToDatePicker))
        toDateView.addGestureRecognizer(toDateTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmTapped() {
        dismissView()
        viewModel.sendSignedReport()
        // delegate?.userDidTapAbsenceConfirm(.absenceStart, viewModel.absence)
    }

    @objc func cancelTapped() {
        dismissView()
    }

    @objc func attachTapped() {
        let vc = ViewSource.attachConfirmView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.bigSizeAttached = {
            self.showErrorView(title: nil, message: "ATTACH_BIG_SIZE_MESSAGE".localized)
        }

        vc.attachedFile = { media in
            self.viewModel.addAttachedMedia(media: media)
            self.reloadTableView()
            self.reloadConfirmView()
        }
        self.present(vc, animated: true, completion: nil)
    }

    @objc func showFromDatePicker() {
        let vc = ViewSource.datePickerView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.selectedValue = { value in
            if value != nil {
                self.viewModel.setFromDate(date: value!)

                self.setDateString()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }

    @objc func showToDatePicker() {
        let vc = ViewSource.datePickerView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.minimumDate = viewModel.fromDate

        vc.selectedValue = { value in
            if value != nil {
                self.viewModel.setToDate(date: value!)

                self.setDateString()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }

    func showErrorView(title: String?, message: String?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: title, message: message)
        self.present(vc, animated: true, completion: nil)
    }

    func reloadConfirmView() {
        confirmView.isUserInteractionEnabled = !viewModel.shouldDisableConfirmView()
        confirmView.alpha = viewModel.shouldDisableConfirmView() ? 0.5 : 1
    }

}

extension SignedReportConfirmView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.attachedFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AttachedFileCell.identifier, for: indexPath) as? AttachedFileCell {

            let cellViewModel = viewModel.getModelForItemAt(index: indexPath.row)

            cell.config(viewModel: cellViewModel)
            cell.selectionStyle = .none
            cell.removeAction = {
                self.viewModel.removeAttachedFile(index: indexPath.row)
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
            self.attachedTableViewHeightConstraint.constant = self.viewModel.getAttachedTableViewHeight()
            self.view.layoutIfNeeded()
        }
    }

    func reloadAttachView() {
        attachView.isUserInteractionEnabled = !viewModel.shouldDisableAttachView()

        let color = viewModel.getAttachViewColor()
        let image = viewModel.getAttachViewImage()

        attachView.border(width: 1.3, color: color.cgColor)
        attachLabel.textColor = color
        attachImage.image = image
    }

}
