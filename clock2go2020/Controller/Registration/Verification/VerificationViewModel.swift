//
//  VerificationViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/15/20.
//

import UIKit

class VerificationViewModel {

    weak var delegate: VerificationViewModelDelegate?
    var enableSkipView: Bool = false

    init() {
        self.loadData()
    }

    func getName() -> String? {
        return CompaniesDataManager.shared.getEmployeeName()
    }

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    func loadData() {
        vc?.view.addSubview(loadingView)

        let company = GetCompaniesEndpoint()
        company.apiCall { (result, error) in
            //self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                CompaniesDataManager.shared.setCompanies(result?.data)
                self.enableSkipView = true
                self.delegate?.shouldRefreshView()
                self.loadingView.removeFromSuperview()
            } else {
                self.loadingView.removeFromSuperview()
                NavigationController.shared?.showErrorView(error: error)
            }
           
        }
    }

}

protocol VerificationViewModelDelegate: NSObjectProtocol {
    func shouldRefreshView()
    func shouldShowError(_ message: String?, _ errorCode: Int?)
}
