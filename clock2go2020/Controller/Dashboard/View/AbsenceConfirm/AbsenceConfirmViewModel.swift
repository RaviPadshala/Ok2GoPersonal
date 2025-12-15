//
//  AbsenceConfirmViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/2/20.
//

import UIKit

class AbsenceConfirmViewModel: NSObject {

    var isClosed: Bool = false
    var isAttachMandatory: Bool {
        if let idetifier = absence.type?.idetifier {
            return absenceTypesMastPic.contains(idetifier)
        } else {
            return false
        }
    }
    var absence = AbsenceObj()
    var absenceTypesMastPic: [Int] = []

    var employee: EmployeeByDepartmentObj?
    var employeesArray: [EmployeeByDepartmentObj] = []
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    // var type: AbsenceTypeEntity?

    override init() {
        super.init()

        self.absenceTypesMastPic = CompaniesDataManager.shared.getAbsenceTypesWithMandatoryPicture()

        self.setEmployeesArray()
    }

    func setEmployeesArray() {
        let departaments = CompaniesDataManager.shared.getDepartments()
        for departament in departaments {
            for employee in departament.employees ?? [] {
                if !employeesArray.contains(obj: employee) {
                    employeesArray.append(employee)
                }
            }
        }
        employeesArray.sort(by: {($0.empId ?? 0) < ($1.empId ?? 0)})
    }

    func shouldAttachFileRequired() -> Bool {
        return isAttachMandatory
    }

    func getAttachedFiles() -> [MediaObj] {
        return absence.attachedFiles
    }

    func addAttachedMedia(media: MediaObj) {
        absence.attachedFiles.append(media)
    }

    func addAttachedFile(image: UIImage, fileName: String) {
        if let file = MediaObj(withImage: image, fileName: fileName) {
            absence.attachedFiles.append(file)
        }
    }

    func addAttachedFile(fileUrl: URL) {
        if let file = MediaObj(withFileUrl: fileUrl) {
            absence.attachedFiles.append(file)
        }
    }

    func removeAttachedFile(index: Int) {
        absence.attachedFiles.remove(at: index)
    }

    func getAttachedTableViewHeight() -> CGFloat {
        let filesCount = absence.attachedFiles.count
        let height = filesCount > 2 ? 50 * 2 : 50 * filesCount
        return CGFloat(height)
    }

//    func setAbsenceType(type: AbsenceTypeEntity) {
//        self.type = type
//    }

    func setAbsenceType(title: String) {
        self.absence.type = AbsenceTypeEntity.withTitle(title)
    }

    func getAbsenceTypeString() -> String {
        let typeString = absence.type?.absenceTitle ?? "ABSENCE_TYPE_TITLE".localized
        return typeString
    }

    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"

        let dateString = formatter.string(from: Date())

        return dateString
    }

    func getFromDateString() -> String {
        return absence.fromDate.toString(format: "dd.MM.yy")
    }

    func getToDateString() -> String {
        return absence.toDate.toString(format: "dd.MM.yy")
    }

    func setFromDate(date: Date) {
        absence.fromDate = date
        if date.days(from: absence.toDate) > 0 {
            absence.toDate = date
        }
    }

    func setToDate(date: Date) {
        absence.toDate = date
    }

    func shouldDisableAttachView() -> Bool {
        return absence.attachedFiles.count == 5
    }

    func shouldDisableConfirmView() -> Bool {
        return (isAttachMandatory && absence.attachedFiles.count == 0)
            || (absence.type == nil)
    }

    func getAttachViewColor() -> UIColor {
        return shouldDisableAttachView() ? #colorLiteral(red: 0.7386835814, green: 0.7387273908, blue: 0.7423955798, alpha: 1) : #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1)
    }

    func getAttachViewImage() -> UIImage? {
        return shouldDisableAttachView() ? UIImage(named: "writing_gray") : UIImage(named: "writing")
    }

    func getModelForItemAt(index: Int) -> AttachedFileCellViewModel {
        return AttachedFileCellViewModel(media: absence.attachedFiles[index])
    }

    func getModelForChooseList() -> ChooseListViewModel {
        let title = "SELECT_ABSENCE_TYPE_TITLE".localized
        let data = CompaniesDataManager.shared.getAvailableAbsenceTypeStrings()

        return ChooseListViewModel(title: title, data: data)
    }

    func getModelForChooseEmployeeList() -> ChooseListViewModel {
        let title = "CHOOSE_EMPLOYEE_TITLE".localized
        var data: [String] = []

        for employee in employeesArray {
            data.append(employee.empName ?? "")
        }

        return ChooseListViewModel(title: title, data: data)
    }

    func setEmployee(index: Int) {
        employee = employeesArray[index]
    }

    func shouldShowChooseEmployeeView() -> Bool {
        return CompaniesDataManager.shared.hasMultiReportFeature()
    }

    func getChooseEmployeeTitle() -> String {
        return employee?.empName ?? "CHOOSE_EMPLOYEE_TITLE".localized
    }
    
    func loadData() {
        vc?.view.addSubview(loadingView)

        let getEmpReports = GetEmployeeReportsEndpoint(month: self.absence.fromDate.toString(format: "yyyy-MM"))
        getEmpReports.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                print("Get Employee Reports: success")

                self.isClosed = result?.isClosed ?? false
            } else {
                NavigationController.shared?.showErrorView(error: error)
                print("Get Employee Reports: failed")
            }
        }
    }
}
