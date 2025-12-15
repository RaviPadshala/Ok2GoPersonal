//
//  CloseMonthViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 30.09.2020.
//

import Foundation
import UIKit

class CloseMonthMgrViewModel {

    // MARK: - Private property
    private var employeesList: [GetMonthSummaryObj] = []
    // filter
    private var filterType: SortingStatusMonth = .showAll
    private var isFilterActivated: Bool = false
    private var filteredListItems: [GetMonthSummaryObj] = []
    private var medias: [MediaObj]?
    private var selectedEmployees: [GetMonthSummaryObj] = []

    // MARK: - Public property
    var month: String = ""
    let loadingView = LoadingView()
    var sortBy: SortingStatusMonth

    // MARK: - Delegate
    weak var delegate: CloseMonthManagemenViewModelDelegate?

    // MARK: - Init CloseMonthMgr
    init(date: Date = Date(), type: SortingStatusMonth = .showAll) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")

        if UserDefaultsManager.dateMgrReport != Date() {
            self.month = UserDefaultsManager.dateMgrReport.toString(format: "yyyy-MM")
        } else {
            self.month = date.toString(format: "yyyy-MM")
        }
        self.sortBy = type
        self.medias = nil
        self.loadData()
    }

    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    // MARK: - Public func
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"

        return formatter.date(from: month)
    }

    func getMonthString() -> String {
        guard let date = getDate() else { return "" }

        return Calendar.getMonthLocalizedStringBy(date: date)
    }

    func setMonthByIndex(_ index: Int) {
        let date = getDateForMonthIndex(index: index)
        month = date.toString(format: "yyyy-MM")
        UserDefaultsManager.dateMgrReport = date
    }

    func getSortTypeString() -> String {
        return sortBy.title
    }

    func setSortType(type: SortingStatusMonth) {
        sortBy = type
    }

    func getDateForMonthIndex(index: Int) -> Date {
        guard var selectedDate = Calendar.current.date(bySetting: .month, value: index + 1, of: Date()) else { return Date() }

        if Date().months(from: selectedDate) < 0 {
            selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? Date()
        }

        return selectedDate
    }

    func loadData() {
        vc?.view.addSubview(loadingView)

        let getEmpReports = GetMonthSummaryEndpoint(month: month, empId: nil)
        getEmpReports.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                print("Get Manager  Cloth month Reports: success")

                self.setEmployees(result)
                self.delegate?.didLoadData()
                print("RESULT: - \(String(describing: result))")
            } else {
                NavigationController.shared?.showErrorView(error: error)
                print("Get Manager Employee Reports: failed")
            }
        }
    }

    func setEmployees(_ employees: [GetMonthSummaryObj]) {
        employeesList = employees

        delegate?.didLoadData()
    }

    func getNemOfRows() -> Int {
        return  isFilterActivated ? filteredListItems.count : employeesList.count
    }

    func getModelForItemAt(index: Int) -> CloseMonthMgrCellViewModel? {
        let reportsArray = isFilterActivated ? filteredListItems : employeesList
        if reportsArray.indices.contains(index) {
            let item = reportsArray[index]
            return CloseMonthMgrCellViewModel(employee: item, isSelected: true, filterType: .showAll)
        }
        return nil
    }

    func filterList(reportFilterType: SortingStatusMonth) {
        filterType = reportFilterType
        isFilterActivated = true
        filteredListItems = []

        switch filterType {
        case .openMonth:
            filteredListItems =  getOpenMonthReport()
        case .closedMonth:
            filteredListItems =  getCloseMonthReport()
        case .approveMonth:
            filteredListItems =  getApproveMonthReport()
        case .showAll:
            filteredListItems = employeesList
        }
    }

    func unfilterList() {
        isFilterActivated = false
        filteredListItems = []
    }

    func getOpenMonthReport() -> [GetMonthSummaryObj] {
        var report: [GetMonthSummaryObj] = []

        for reportList in employeesList {
            if  reportList.monthClosed != 1 {
                report.append(reportList)
            }
        }

        return report
    }

    func getCloseMonthReport() -> [GetMonthSummaryObj] {
        var report: [GetMonthSummaryObj] = []

        for reportList in employeesList {
            if reportList.monthClosed == 1 && reportList.monthApproved == 0 {
                report.append(reportList)
            }
        }
        return report
    }

    func getApproveMonthReport() -> [GetMonthSummaryObj] {
        var report: [GetMonthSummaryObj] = []

        for reportList in employeesList {
            if reportList.monthApproved == 1 {
                report.append(reportList)
            }
        }
        return report
    }

    func setStatusForEmp(status: Int, tag: Int) {
        let empId = getModelForItemAt(index: tag)?.getEmpId() ?? 0

        let sendStatus = SetMonthStatusEndpoint(month: month, status: status, empId: empId, email: "")
        sendStatus.apiCall { (result) in

            if result?.success ?? false {
            } else {
                NavigationController.shared?.showErrorView(error: result)
            }
        }
        delegate?.didLoadData()
    }

    func getAmutaSignedPictures(empId: Int) {
        let getAbsencePics = GetAmutaSignedReportEndpoint(month: month, empId: empId)
        getAbsencePics.apiCall { pictures, error   in

            if error?.success ?? false {
                self.setFiles(pictures: pictures)
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

    func setFiles(pictures: [GetAmutaSignedReportObj]?) {
        guard let files = pictures else { return }

        var mediaFiles: [MediaObj] = []

        for picture in files {
            if let filename = picture.filename, let imageString = picture.content, let index = imageString.range(of: ",")?.lowerBound {
                var imageDataString = imageString.replacingOccurrences(of: String(imageString[..<index]), with: "")
                imageDataString = imageDataString.replacingOccurrences(of: ",", with: "")

                if let image = imageDataString.toImage(), let mediaObj = MediaObj(withImage: image, fileName: filename) {
                    mediaFiles.append(mediaObj)
                }
            }
        }

        medias = mediaFiles

        delegate?.didLoadData()
    }

    func getImage() -> ImageViewModel? {
        guard let media = medias?.first else { return nil }
        return ImageViewModel(image: media.image)
    }

    func getAlleports() {
        for item in employeesList {
            if item.monthApproved == 0 {
                if !selectedEmployees.contains(obj: item) {
                    selectedEmployees.append(item)
                }
            }
        }
    }

    func approveAllReports() {
        getAlleports()

        for item in selectedEmployees {

            if let empId = item.empId {
                let status = 2 // appove

                let sendStatus = SetMonthStatusEndpoint(month: month, status: status, empId: empId, email: "")
                sendStatus.apiCall { (result) in

                    if result?.success ?? false {
                    } else {
                        NavigationController.shared?.showErrorView(error: result)
                    }
                }
            }
        }
    }

    func shouldShowShlomitInfo() -> Bool {
        if CompaniesDataManager.shared.getSpecialClientType() == 3665 {
            return false
        }
        return true
    }
}

protocol CloseMonthManagemenViewModelDelegate: NSObjectProtocol {
    func didLoadData()
}
