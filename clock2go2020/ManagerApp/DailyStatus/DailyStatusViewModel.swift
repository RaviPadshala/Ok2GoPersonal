//
//  DailyStatusViewModel.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/10/20.
//

import UIKit

class DailyStatsDetailsViewModel {

    private var dailyStatsDetails: [DailyStatsDetailsObj?] = []
    private var dailyStats: DailyStatsObj?

    private var selectedFilter: typeCircle? = .entry
    private var filteredEmployees: [DailyStatsDetailsObj?] = []

    private var selectedDepartment: DepartmentsObj?

    weak var delegate: DailyStatsDetailsViewModelDelegate?

    init() {
        loadDailyStatsData()
    }

    func setFilterType(filter: typeCircle?) {
        selectedFilter = filter
        filterDailyStats()
        delegate?.shouldReloadView()
    }

    func setDepartment(departmentTitle: String) {
        let departments = ManagerAppDataManager.shared.getDepartments()
        selectedDepartment = departments.first(where: {$0?.empGrpName == departmentTitle}) as? DepartmentsObj

        filterDailyStats()
        delegate?.shouldReloadView()
    }

    func filterDailyStats() {
        guard let type = selectedFilter?.rawValue else {
            filteredEmployees = dailyStatsDetails
            return
        }

        filteredEmployees = dailyStatsDetails.filter({ $0?.status == type })

        guard let department = selectedDepartment else { return }
        filteredEmployees = filteredEmployees.filter({ $0?.deptIds?.contains(String(department.empGrpId ?? -1)) ?? false })
    }

    func getSortingTitle() -> String {
        return selectedDepartment?.empGrpName ?? "CHOOSE_DEPARTMENT".localized
    }

    func getNumberOfEmployees() -> Int {
        return filteredEmployees.count
    }

    func getNumberOfEmployeesColor() -> UIColor {
        return selectedFilter?.color ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    func getFilterTitle() -> String {
        return selectedFilter?.title ?? ""
    }

    func getNumbersOfRows() -> Int {
        return filteredEmployees.count
    }

    func getModelForCellAt(indexPath: IndexPath) -> DailyStatsDetailsCellViewModel? {
        guard let dailyStats = filteredEmployees[indexPath.row] else { return nil }

        return DailyStatsDetailsCellViewModel(dailyStatsDetailsObj: dailyStats)
    }

    func setDailyStats(dailyStats: DailyStatsObj?) {
        self.dailyStats = dailyStats
    }

    func setDailyStatsDetails(dailyStatsDetails: [DailyStatsDetailsObj?]) {
        self.dailyStatsDetails = dailyStatsDetails

        setFilterType(filter: .entry)
    }

    func getModelForChooseDepartmentView() -> ChooseListViewModel {
        let title = "CHOOSE_DEPARTMENT".localized
        let data = ManagerAppDataManager.shared.getDepartmentTitles()
       // data.append("הצג על פי מחלקה")
        return ChooseListViewModel(title: title, data: data)
    }

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    // api
    func loadDailyStatsData() {
        vc?.view.addSubview(loadingView)

        let dailyStatsEndpoint = DailyStatsEndpoint()
        dailyStatsEndpoint.apiCall { result, error in
            if error?.success ?? false {
                self.setDailyStats(dailyStats: result)
                self.loadDailyStatsDetailsData()
            } else {
                self.loadingView.removeFromSuperview()
            }
        }
    }

    func loadDailyStatsDetailsData() {
        let dailyStatsDetailsEndpoint = DailyStatsDetailsEndpoint()
        dailyStatsDetailsEndpoint.apiCall { result, error in
            if error?.success ?? false {
                self.setDailyStatsDetails(dailyStatsDetails: result ?? [])
                self.loadDepartments()
            } else {
                self.loadingView.removeFromSuperview()
            }
        }
    }

    // api
    func loadDepartments() {
        let department = DepartmentsEndpoint()
        department.apiCall { result, error in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                ManagerAppDataManager.shared.setDepartments(departments: result ?? [])
                self.delegate?.shouldReloadView()
            } else {

            }
        }
    }
}

protocol DailyStatsDetailsViewModelDelegate: NSObjectProtocol {
    func shouldReloadView()
}
