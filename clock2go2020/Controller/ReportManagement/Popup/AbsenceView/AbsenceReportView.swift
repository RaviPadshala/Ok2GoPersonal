//
//  AbsenceView.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/30/20.
//

import UIKit

class AbsenceReportView: UIViewController {

    // MARK: Outlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var typeAbsenceView: UIView!
    @IBOutlet weak var typeAbsenceTitle: UILabel!

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateTitle: UILabel!

    @IBOutlet weak var approveView: UIView!
    @IBOutlet weak var approveTitle: UILabel!

    @IBOutlet weak var rejectView: UIView!
    @IBOutlet weak var rejectTitle: UILabel!

    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteTitle: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    // MARK: Property
    var viewModel: AbsenceReportViewModel!

    var updateReports: ((_ empReports: [String: EmpDayReportsObj]?) -> Void)?

    // MARJ: Action
    override func viewDidLoad() {
        super.viewDidLoad()

        setAbsenceViewModelString()
        setupUI()
        setupLocalizations()
        setupTaps()
        setupTableView()

        viewModel.delegate = self
    }

    func setupUI() {
        iconView.roundCorners([.allCorners], radius: 30)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 3.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        contentView.roundCorners([.topLeft, .topRight], radius: 30)
        tableView.roundCorners(.allCorners, radius: 10)

        setupUIForView(typeAbsenceView)
        setupUIForView(dateView)
        setupUIForView(cancelView)
        setupUIForView(approveView)
        setupUIForView(rejectView)

        cancelView.roundCorners([.allCorners], radius: 16.5)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        deleteView.roundCorners([.allCorners], radius: 16.5)
        deleteView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.9568627451, green: 0.3333333333, blue: 0.262745098, alpha: 1))
        deleteView.border(width: 1, color: #colorLiteral(red: 0.9568627451, green: 0.3333333333, blue: 0.262745098, alpha: 1))

       approveView.isHidden = viewModel.isMgrStatus()
        rejectView.isHidden = viewModel.isMgrStatus()

    }

    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 16.5)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        view.border(width: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setupLocalizations() {
        cancelTitle.text = "CANCEL".localized
        deleteTitle.text = "DELETE".localized
        approveTitle.text = "APPROVE".localized
        rejectTitle.text = "REJECT".localized
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(cancelTap)

        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(deleteAction))
        deleteView.addGestureRecognizer(deleteTap)

        let approveTap = UITapGestureRecognizer(target: self, action: #selector(approveAction))
        approveView.addGestureRecognizer(approveTap)

        let rejectTap = UITapGestureRecognizer(target: self, action: #selector(rejectAction))
        rejectView.addGestureRecognizer(rejectTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func rejectAction() {
        viewModel.SetMgrAbsense(status: 3)
        dismissView()
    }

    @objc func deleteAction() {
        viewModel.deleteAbsence()
        dismissView()
    }

    @objc func approveAction() {
        viewModel.SetMgrAbsense(status: 4)
        dismissView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        let cell = UINib(nibName: AttachedFileCell.identifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: AttachedFileCell.identifier)

        tableViewHeightConstraint.constant = viewModel.getTableViewHeight()
    }

    func setAbsenceViewModelString() {
        typeAbsenceTitle.text = viewModel.getType()
        dateTitle.text = viewModel.getDate()
    }

    func showImageViewFor(index: Int) {
        guard let model = viewModel.getImageModelForCellAt(index: index) else { return }

        let imageView = ImageView(frame: self.view.frame)
        imageView.viewModel = model

        self.view.addSubview(imageView)
    }
}

extension AbsenceReportView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.getNumberOfFiles()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AttachedFileCell.identifier, for: indexPath) as? AttachedFileCell,
            let model = viewModel.getModelForFileCellAt(index: indexPath.row) {
            cell.config(viewModel: model)
            cell.selectionStyle = .none
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showImageViewFor(index: indexPath.row)
    }

}

extension AbsenceReportView: AbsenceReportViewModelDelegate {
    func didLoadData() {
        tableView.reloadData()
        tableViewHeightConstraint.constant = viewModel.getTableViewHeight()
    }

    func didRemoveAbsence(_ empReports: [String: EmpDayReportsObj]?) {
        dismissView()
        updateReports?(empReports)
    }

    func didReceiveError(_ error: ErrorObject?) {
        dismissView()
        NavigationController.shared?.showErrorView(error: error)
    }
}
