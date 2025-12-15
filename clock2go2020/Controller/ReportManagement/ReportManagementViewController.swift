//
//  ReportManagementViewController.swift
//  clock2go2020
//
//  Created by Admin on 3/10/20.
//

import UIKit

class ReportManagementViewController: UIViewController {
    
    @IBOutlet weak var reportActionView: ReportActionView!
    @IBOutlet weak var tableHeaderView: ReportManagementHeaderTableView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Property
    let idCell = "ReportManagementCellId"
    var viewModel: ReportManagementViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? addReachabilityObserver()
        
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        
        let screenFrame = UIScreen.main.bounds
        self.view.frame = CGRect(x: 0, y: 0, width: screenFrame.height, height: screenFrame.width)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupFilter()
        
        updateUIAfterEditing()
    }
    func updateUIAfterEditing() {
        let vc = ViewSource.editReportView()
        vc.updateReports = { reports in
            self.viewModel?.setReports(reports: reports)
            self.tableView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
        removeReachabilityObserver()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibCell = UINib(nibName: "ReportManagementTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: idCell)
    }
    
    func setupFilter() {
        reportActionView.viewModel = viewModel?.getModelForActionView()
        reportActionView.updateUI()
        
        reportActionView.calendarViewTapped = { index in
            self.viewModel = ReportManagementViewModel(monthIndex: index)
            self.viewModel?.delegate = self
            self.viewModel?.loadData()
            self.tableView.reloadData()
        }
        
        reportActionView.sortingListViewTapped = { type in
            self.viewModel?.filterList(reportFilterType: type)
            self.tableView.reloadData()
        }
        
        reportActionView.delegate = self
    }
    
    func config(model: ReportManagementViewModel) {
        viewModel = model
        
        viewModel?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
}

extension ReportManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.getNumberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRows(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! ReportManagementTableViewCell
        
        if let model = viewModel?.getModelForItemAt(section: indexPath.section, row: indexPath.row) {
            cell.delegate = self
            cell.configure(viewModel: model)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandAction(indexPath: indexPath)
    }
    
    func expandAction(indexPath: IndexPath) {
        if viewModel?.isItemExpandable(section: indexPath.section, row: indexPath.row) ?? false {
            // Expandable menu items should expand or collapse only.
            viewModel?.toggleItem(section: indexPath.section, row: indexPath.row)
            
            tableView.reloadData()
        }
    }
}

extension ReportManagementViewController: ReportManagementViewModelDelegate {
    func didLoadData() {
        tableView.reloadData()
        reportActionView.viewModel = viewModel?.getModelForActionView()
        reportActionView.updateUI()
    }
}

extension ReportManagementViewController: ReportActionViewDelegate {
    func createDayReport(_ report: EmpDayReportsObj) {
        viewModel?.updateDayReport(report: report)
    }
    
    func closeMonth() {
        viewModel?.closeMonth()
    }
}

extension ReportManagementViewController: ReportManagementTableViewCellDelegate {
    func didUpdateReports(_ reports: [String: EmpDayReportsObj]?) {
        viewModel?.setReports(reports: reports)
        tableView.reloadData()
    }
}



extension ReportManagementViewController: ReachabilityObserverDelegate {
    
    // MARK: Reachability
    
    func reachabilityChanged(_ isReachable: Bool) {
        ReachabilityManager.shared.hasInternetConnection = isReachable
        
        if !isReachable {
            print("No internet connection")
        } else {
            print("Has Internet connection")
        }
    }
    
}
