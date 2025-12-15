//
//  ApproveDialogViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 22.10.2020.
//

import Foundation
import UIKit

class ApproveDialogViewModel {

    // MARK: Private var
    private var monthObj: MonthObj?
    // MARK: Public var
    var month: String = ""
    var status: Int
    var empId: Int
    let loadingView = LoadingView()

    // MARK: Init
    init(date: Date = Date(), status: Int, empId: Int) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")
        self.month = date.toString(format: "yyyy-MM")
        self.empId = empId
        self.status = status

        self.sendMonthStatus()
    }

    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    func sendMonthStatus() {

        let sendStatus = SetMonthStatusEndpoint(month: month, status: status, empId: empId, email: "")
           sendStatus.apiCall { (result) in

                 if result?.success ?? false {

                     NavigationController.shared?.showSuccessView()
                 } else {
                     NavigationController.shared?.showErrorView(error: result)
                 }
             }
    }
}
