//
//  CloseMonthViewModel.swift
//  clock2go2020
//
//  Created by Admin on 3/25/20.
//

import UIKit

class CloseMonthViewModel {
    
    var date: Date
    var monthObj: MonthObj?
    var monthStatsObj: MonthStatsObj?
    var monthString: String
    var email: String = ""
    var cell: String = ""
    var isRulesAgreement: Bool
    var isEmailValid: Bool
    private(set) var invalidEmailsText: String = ""
    
    weak var delegate: CloseMonthViewModelDelegate?
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    
    init(date: Date, monthObj: MonthObj, monthString: String) {
        self.date = date
        self.monthObj = nil
        self.monthString = monthString
        
        self.isRulesAgreement = false
        self.isEmailValid = false
        self.email = CompaniesDataManager.shared.getEmployeeEmail() ?? ""
    }
    
    func getMonthString() -> String {
        return monthString
    }
    
    func getMonthIndex() -> Int? {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")
        return calendar.monthSymbols.firstIndex(of: monthString)
    }
    
    func getAbcenseTitle() -> String {
        return String(monthObj?.vacations ?? 0) + " " + "ABSENCES".localized
    }
    
    func getMissingTitle() -> String {
        return String(monthObj?.misses ?? 0) + " " + "MISSING".localized
    }
    
    func getHoursTitle() -> String {
        var hoursString = monthObj?.workingHours ?? "0"
//        if hoursString == ".00" {
//            hoursString = "0"
//        } else if hoursString.hasPrefix(".") {
//            hoursString = "0" + hoursString
//        }
        return hoursString + " " + "HOURS".localized
    }
    
    func hasRulesAgreement() -> Bool {
        return isRulesAgreement
    }
    
    func getAgreementImage() -> UIImage? {
        return isRulesAgreement ? UIImage(named: "checked_terms") : UIImage(named: "unchecked_terms")
    }
    
    func changeAgreement() {
        isRulesAgreement = !isRulesAgreement
    }
    
    func getEmail() -> String {
        return email
    }
    
    func setEmail(email: String?) {
        self.email = email ?? ""
    }
    
    func setCell(cell: String?) {
        self.cell = cell ?? ""
    }
    
    func getCell() -> String {
        return cell
    }
    
    func shouldEnableConfirmView() -> Bool {
        return isRulesAgreement && isEmailValid
    }
    
    //email validation
    func validateEmails(completion: (() -> ())) {
        email = email.replacingOccurrences(of: " ", with: "")
        let emailsList = email.components(separatedBy: ",")
        
        var invalidEmails = [String]()
        for email in emailsList {
            if !email.isValidEmail() {
                invalidEmails.append(email)
            }
        }
        
        isEmailValid = invalidEmails.isEmpty
        invalidEmailsText = invalidEmails.joined(separator: ",")
        completion()
    }
    
    // api call
    func getMonthInfo() {
        guard let monthIndex = getMonthIndex() else { return }
        vc?.view.addSubview(loadingView)
        
        let getMonthStatEndpont = GetEmployeeMonthlyStatisticsEndpoint()
        getMonthStatEndpont.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                if let month = result?.first(where: { Int($0.key) == (monthIndex + 1) })?.value {
                    print(month.workingHours)
                    self.monthObj = month
                    print(self.monthObj?.workingHours)
                    self.delegate?.didLoadData()
                }
            } else {
                self.delegate?.didReceiveError(error)
            }
        }
    }
    
    func closeMonthForEmpployee() {
        vc?.view.addSubview(loadingView)
        let sendStatus = SetMonthStatusEndpoint(month: UserDefaultsManager.dateMgrReport.toString(format: "yyyy-MM"), status: 1, empId: UserDefaultsManager.empIdMgrReport, email: "")
        sendStatus.apiCall { (result) in
            self.loadingView.removeFromSuperview()
            
            if result?.success ?? false {
                NavigationController.shared?.showSuccessView(message: "SUCCESS_TITLE".localized)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "managerUpdateMonthStatus"), object: nil)
            } else {
//                self.delegate?.didReceiveError(result)
                NavigationController.shared?.showErrorView(error: result)
            }
        }
    }
    
    func closeMonth() {
        vc?.view.addSubview(loadingView)
        
        let closeMonthEndpont = CloseMonthReportEndpoint(month: date.toString(format: "yyyy-MM"), email: email, cell: cell)
        closeMonthEndpont.apiCall { (result) in
            self.loadingView.removeFromSuperview()
            
            if result?.success ?? false {
                self.delegate?.didCloseMonth()
                UserDefaultsManager.lastEmailCloseMonth = self.email
                NavigationController.shared?.showSuccessView(message: "SUCCESS_TITLE".localized)
            } else {
                if let res = result, let error = res.error_code, error == 456 {
                    print("show Error Code 456")
                    var error = ErrorObject()
                    let message = String(format: NSLocalizedString("closing_message", comment: ""), self.date.toString(format: "yyyy-MM"))
                    error.error_message = message
                    print(message)
                    NavigationController.shared?.showErrorView(error: error)
                    return
                }else{
                    NavigationController.shared?.showErrorView(error: result)
                }
            }
        }
    }
    
    var isRevacha: Bool {
        return CompaniesDataManager.shared.isRevacha()
    }
}

protocol CloseMonthViewModelDelegate: NSObjectProtocol {
    func didLoadData()
    func didCloseMonth()
    func didReceiveError(_ error: ErrorObject?)
}
