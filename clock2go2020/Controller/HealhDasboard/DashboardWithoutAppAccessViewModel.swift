//
//  DashboardWithoutAppAccessViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/29/20.
//

import UIKit

class DashboardWithoutAppAccessViewModel {

    var name: String?
    weak var delegate: DashboardWithoutAppAccessViewModelDelegate?
    let appShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    init(delegate: DashboardWithoutAppAccessViewModelDelegate) {
        self.delegate = delegate

        if shouldShowHealthDisclaimer() {
            loadDisclaimerData()
        } else {
            checkValidData()
        }
    }

    func checkValidData() {
        if UserDefaultsManager.appVersion != appShortVersion {
            loadGetCompaniesData()
        } else {
            self.delegate?.showHealthDisErrorView()
        }
    }

    func loadGetCompaniesData() {
        let company = GetCompaniesEndpoint()
        company.apiCall { (result, error) in
            if error?.success ?? false {
                CompaniesDataManager.shared.setCompanies(result?.data)
                UserDefaultsManager.appVersion = self.appShortVersion ?? "1.0.0"
                if CompaniesDataManager.shared.hasAppPermission() {
                    let mainDashboard = ViewSource.dashboardScreen()
                    NavigationController.shared?.setRoot(mainDashboard, animated: true)
                }
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }
    var hasLastReports: Bool {
        return CompaniesDataManager.shared.getLastReports().count != 0
    }

    func shouldHideTaskBarView() -> Bool {
        return !hasLastReports
    }

    func shouldShowHealthDisclaimer() -> Bool {
        return CompaniesDataManager.shared.shouldShowHealthDisclaimer()
    }

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    // api
    func loadDisclaimerData() {
        vc?.view.addSubview(loadingView)

        let health = ShowHealthDisclaimerEndpoint()
        health.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                if result?.show ?? false {
                    self.delegate?.showHealthDisclaimer(.disclaimer, result?.disclaimer)
                }
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

    func sendHealthDisclaimer() {
        vc?.view.addSubview(loadingView)

        let acceptHealthDisclaimer = AcceptHealthDisclaimerEndpoint()
        acceptHealthDisclaimer.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                CompaniesDataManager.shared.setReportList(reports: result ?? [])
                self.delegate?.showHealthDisclaimer(.accepted, nil)
                self.delegate?.reloadView()
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }
}

protocol DashboardWithoutAppAccessViewModelDelegate: NSObjectProtocol {
    func showHealthDisclaimer(_ type: HealthDisclaimerType, _ message: String?)
    func showHealthDisErrorView()
    func reloadView()
}
