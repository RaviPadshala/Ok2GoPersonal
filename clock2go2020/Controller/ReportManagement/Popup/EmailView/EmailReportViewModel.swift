//
//  EmailReportViewModel.swift
//  clock2go2020
//
//  Created by Admin on 3/24/20.
//

import UIKit

class EmailReportViewModel {
    private var month: String?
    private var type: Int?
    private var format: String?
    private var email: String?
    private var isManager: Bool = false

    weak var delegate: EmailReportViewModelDelegate?

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    init(month: String?, type: Int?, email: String) {
        self.month = month
        self.type = type
        self.format = "pdf"
        self.email = email
    }
    init(month: String?, type: Int?, email: String, isManager: Bool) {
        self.month = month
        self.type = type
        self.format = "pdf"
        self.email = email
        self.isManager = isManager
    }
    func getEmail() -> String {
        return email ?? ""
    }

    func setEmail(email: String?) {
        if (email ?? "").contains(" ") {
            self.email = (email ?? "").trimmingCharacters(in: .whitespaces)
        } else {
            self.email = email ?? ""
        }
    }

    func validateEmail() -> Bool {
        return email?.isValidEmail() ?? false
    }

    func getFormat() -> String {
        return format ?? "פורמט"
    }

    func setFormat(format: String) {
        self.format = format
    }

    func getModelForChooseList() -> ChooseListViewModel {
        let title = "Choose format".localized
        let data = ["pdf", "excel"]

        return ChooseListViewModel(title: title, data: data)
    }

    // api call
    func sendEmail() {
        vc?.view.addSubview(loadingView)
        if !isManager {
            let emailEndpont = EmailReportEndpoint(month: month, email: email, type: type, format: format)
            emailEndpont.apiCall { (result) in
                self.loadingView.removeFromSuperview()

                if result?.success ?? false {
                    self.delegate?.emailSended(self.email ?? "")
                    NavigationController.shared?.showSuccessView(message: "REPORT_WAS_SENT".localized)
                } else {
                    NavigationController.shared?.showErrorView(error: result)
                }
            }
        } else {
            let emailEndpont = MgrEmailReportEndpoint(month: month, email: email, type: type, format: format)
            emailEndpont.apiCall { (result) in
                self.loadingView.removeFromSuperview()

                if result?.success ?? false {
                    self.delegate?.emailSended(self.email ?? "")
                    NavigationController.shared?.showSuccessView(message: "REPORT_WAS_SENT".localized)
                } else {
                    NavigationController.shared?.showErrorView(error: result)
                }
            }
        }
    }
}

protocol EmailReportViewModelDelegate: NSObjectProtocol {
    func emailSended(_ email: String)
}
