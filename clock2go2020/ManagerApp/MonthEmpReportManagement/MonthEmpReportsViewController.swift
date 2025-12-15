//
//  MothEmpReportsViewController.swift
//  clock2go2020
//
//  Created by Gleb on 02.12.2020.
//

import UIKit
import AnyCodable

class MonthEmpReportsViewController: UIViewController {

    @IBOutlet weak var monthReportActionView: MonthEmpActionView!
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

    var viewModel = MothEmpReportsViewModel()

    // property
    var empName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFilter()
        setupTaps()
        setupUI()
        showApproveView()
        selectAll()
        setupLocalized()
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //     try? addReachabilityObserver()

        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)

        let screenFrame = UIScreen.main.bounds
        self.view.frame = CGRect(x: 0, y: 0, width: screenFrame.height, height: screenFrame.width)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.delegate = self

        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload),
                                               name: NSNotification.Name(rawValue: "editMonthReporEmp"), object: nil)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // removeReachabilityObserver()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let nibCell = UINib(nibName: MonthEmpReportTableViewCell.identifier, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: MonthEmpReportTableViewCell.identifier)
    }

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
        self.monthReportActionView.approveButton.isHidden = self.viewModel.shouldSHowApproveButton()
    }

    private func setupLocalized() {
        approveTitle.text = "APPROVE".localized
        cancelTitle.text  = "CANCEL".localized
        approveMsgLabel.text = "APPROVE_SELECTED_REPORTS".localized
    }

    private func setupFilter() {
        monthReportActionView.viewModel = viewModel.getModelForActionView()
        monthReportActionView.updateUI()

        monthReportActionView.calendarViewTapped = { value in
            print(value)

            self.viewModel = MothEmpReportsViewModel(monthIndex: value)
            self.viewModel.delegate = self
            self.viewModel.loadData(empId: UserDefaultsManager.empIdMgrReport)
        }
        monthReportActionView.sortingListViewTapped = { type in
            self.viewModel.filterList(reportFilterType: type)
            self.tableView.reloadData()
        }
        monthReportActionView.delegate = self
    }

    private func setupTaps() {
        let approveTap = UITapGestureRecognizer(target: self, action: #selector(approveTapped))
        approveView.addGestureRecognizer(approveTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)

        let dismissTap = UITapGestureRecognizer(target: self, action: #selector((dismissTapped)))
        bgApproveView.addGestureRecognizer(dismissTap)
    }

    private func config(model: MothEmpReportsViewModel) {
        viewModel = model
        viewModel.delegate = self
    }

    private func selectAll() {
        monthReportActionView.selectAll = {
            self.viewModel.selectAll()
            self.monthReportActionView.selectAllCheckboxIcon.image = self.viewModel.getSelectAllButtonImage()
            self.tableView.reloadData()
            self.updateUI()
        }
    }

    private func showApproveView() {
        monthReportActionView.approveReports = { [self] in
            bgApproveView.isHidden =  false
        }
    }

    @objc func shouldReload() {
        self.viewModel.loadData(empId: UserDefaultsManager.empIdMgrReport)
    }

    @objc func dismissTapped() {
        self.bgApproveView.isHidden = true
        print("dismiss")
    }

    @objc func approveTapped() {
        self.viewModel.delegate = self
        self.viewModel.ApproveEmpReports()
        self.viewModel.loadData(empId: UserDefaultsManager.empIdMgrReport)
        self.bgApproveView.isHidden = true
    }

    @objc func cancelTapped() {
        self.bgApproveView.isHidden = true
        print("cancel")
    }
}

extension MonthEmpReportsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(section: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MonthEmpReportTableViewCell.identifier) as? MonthEmpReportTableViewCell

        if let model = viewModel.getModelForItemAt(section: indexPath.section, row: indexPath.row) {
            cell?.configure(viewModel: model)
            cell?.delegate = self
            cell?.employeeLabel.text = empName
            cell?.viewModel.empId =  UserDefaultsManager.empIdMgrReport

            cell?.selectTapped = {
                print("Employee Tapped")
                self.viewModel.selectEmployee(by: indexPath)
                self.tableView.reloadData()
                self.monthReportActionView.approveButton.isHidden =  self.viewModel.shouldSHowApproveButton()
            }
        }
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
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
extension MonthEmpReportsViewController: MonthEmpReportsViewModelDelegate {
    func didLoadData() {
        DispatchQueue.main.async { [self] in
            self.tableView.reloadData()
            monthReportActionView.viewModel = viewModel.getModelForActionView()
            monthReportActionView.updateUI()
        }
    }
}

extension MonthEmpReportsViewController: MonthEmpReportTableViewCellDelegate {
    func didUpdateReports(_ reports: [String: GetMgrEmpReportsObj]) {
        viewModel.setReports(reports: reports)
    }
}

extension MonthEmpReportsViewController: UpdateReportConfirmViewDelegate {
    func updateDayReport(_ report: EmpDayReportsObj) {}
}

extension MonthEmpReportsViewController: MonthEmpActionViewDelegate {
    func createDayReport(_ report: GetMgrEmpReportsObj) {
        viewModel.updateDayReport(report: report)
    }
}
