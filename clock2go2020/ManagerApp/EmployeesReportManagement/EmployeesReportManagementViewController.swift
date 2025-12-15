//
//  EmployeesReportManagementViewController.swift
//  clock2go2020
//
//  Created by Gleb on 16.09.2020.
//

import UIKit
import AnyCodable

class EmployeesReportManagementViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var reportActionView: EmployeesReportActionView!
    @IBOutlet weak var empolyeesReportHeaderView: EmpolyeesReportHeaderView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var bgApproveView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var approveMsgLabel: UILabel!
    @IBOutlet weak var approveView: UIView!
    @IBOutlet weak var approveTitle: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!
    @IBOutlet weak var iconView: UIView!

    // MARK: - Priperties
    var viewModel = EmployeesReportManagementViewModel()

    // MAR: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)

        let screenFrame = UIScreen.main.bounds
        self.view.frame = CGRect(x: 0, y: 0, width: screenFrame.height, height: screenFrame.width)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFilter()
        selectAll()
        setupUI()
        setupLocalized()
        setupTaps()
        showApproveView()
        updateUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.delegate = self
        viewModel.loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload),
                                               name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
    }

    // MAR: - Private func
    private func setupUI() {
        bgApproveView.isHidden = true

        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)
        approveView.roundCorners([.allCorners], radius: 25.0)
        cancelView.roundCorners([.allCorners], radius: 25.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    private func updateUI() {
        self.reportActionView.approveButton.isHidden = self.viewModel.shouldSHowApproveButton()
    }

    private func setupLocalized() {
        approveTitle.text = "APPROVE".localized
        cancelTitle.text  = "CANCEL".localized
        approveMsgLabel.text = "APPROVE_SELECTED_REPORTS".localized
    }

    func setupTaps() {
        let approveTap = UITapGestureRecognizer(target: self, action: #selector(approveTapped))
        approveView.addGestureRecognizer(approveTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)

        let dismissTap = UITapGestureRecognizer(target: self, action: #selector((dismissTapped)))
        bgApproveView.addGestureRecognizer(dismissTap)
    }

   private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let nibCell = UINib(nibName: EmployeesReportTableViewCell.identifier, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: EmployeesReportTableViewCell.identifier)
    }

    private func setupFilter() {
        reportActionView.viewModel = viewModel.getModelForActionView()

        reportActionView.calendarViewTapped = { value in
            print(value)
            self.viewModel = EmployeesReportManagementViewModel(date: value)

            UserDefaultsManager.dateMgrReport =  value

            self.viewModel.filterList(reportFilterType: .allReports)
            self.viewModel.delegate = self
            self.viewModel.loadData()
            self.tableView.reloadData()
        }

        reportActionView.sortingListViewTapped = { type in
            self.viewModel.filterList(reportFilterType: type)
            self.tableView.reloadData()
        }
        reportActionView.updateUI()
    }

    // open emp reports
    private  func showEmployeesReports(empId: Int, empName: String) {
        let vc = ViewSource.mothEmpReportsScreen()
        vc.viewModel.delegate = self
        vc.viewModel.loadData(empId: empId)
        vc.empName = empName
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    private func selectAll() {
        reportActionView.selectAll = {
            self.viewModel.selectAll()
            self.reportActionView.selectAllCheckboxIcon.image = self.viewModel.getSelectAllButtonImage()
            self.tableView.reloadData()
            self.updateUI()
        }
    }

    private func showApproveView() {
        reportActionView.approveReports = { [self] in
            bgApproveView.isHidden =  false
        }
    }

    @objc func shouldReload() {
        self.viewModel.loadData()
    }

    @objc func dismissTapped() {
        self.bgApproveView.isHidden = true
        print("dismiss")
    }

    @objc func approveTapped() {
        self.viewModel.delegate = self
        self.viewModel.getItemReports()
        self.viewModel.loadData()

        self.bgApproveView.isHidden = true
    }

    @objc func cancelTapped() {
        self.bgApproveView.isHidden = true
        print("cancel")
    }

}

// MARK: Extension
extension EmployeesReportManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesReportTableViewCell.identifier, for: indexPath) as? EmployeesReportTableViewCell
        // cell?.checkboxButton.tag = indexPath.row
        if let model = viewModel.getModelForRowAt(section: indexPath.section, row: indexPath.row) {
            cell?.configure(viewModel: model)
            cell?.delegate = self
            /// selected employee for aprove
            cell?.selectTapped = {
                print("Employee Tapped")
                self.viewModel.selectEmployee(by: indexPath)
                self.tableView.reloadData()
                self.reportActionView.approveButton.isHidden = self.viewModel.shouldSHowApproveButton()
            }
            /// selected employee for show month reports
            cell?.employeeTapped = {
                if let empId = cell?.viewModel.getEmpId(),
                   let epmName = cell?.viewModel.getEmpName() {
                    print(empId)
                    UserDefaultsManager.empIdMgrReport = empId
                    self.showEmployeesReports(empId: empId, empName: epmName)
                }
            }
            cell?.selectionStyle = .none

            return cell ?? UITableViewCell()
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandAction(indexPath: indexPath)
    }

    func expandAction(indexPath: IndexPath) {
        if viewModel.isItemExpandable(section: indexPath.section, row: indexPath.row) {
            // Expandable menu items should expand or collapse only.
            viewModel.toggleItem(section: indexPath.section, row: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension EmployeesReportManagementViewController: EmployeesReportTableViewCellDelegate {
    func didUpdateReports(_ reports: [String: AnyCodable]) {
        viewModel.setReports(allReports: reports )
    }
}

extension EmployeesReportManagementViewController: EmployeesReportManagemenViewModelDelegate {
    func didLoadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension EmployeesReportManagementViewController: MonthEmpReportsViewModelDelegate {
}
