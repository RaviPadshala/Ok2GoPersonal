//
//  HealthDasboardViewController.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/28/20.
//

import UIKit

class DashboardWithoutAppAccessViewController: UIViewController {

    // MARK: Outlet
    @IBOutlet weak var accountInfoView: AccountInfoView!
    @IBOutlet weak var taskBarView: TaskBarView!
    @IBOutlet weak var trackingView: TrackingView!

    var viewModel: DashboardWithoutAppAccessViewModel!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        try? addReachabilityObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeReachabilityObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = DashboardWithoutAppAccessViewModel(delegate: self)
        setupUI()
    }

    func setupUI() {
        accountInfoView.config(viewModel: AccountInfoViewModel(type: .withoutCompanyAndButtons))
        self.taskBarView.reloadView()
        taskBarView.isHidden = viewModel.shouldHideTaskBarView()
        trackingView.configure(model: TrackingViewModel(isTrackingStarted: false))
    }

    func showHealthDisclaimer(type: HealthDisclaimerType, message: String? = nil) {
        let healthVC = ViewSource.healthDisclaimerView()
        healthVC.modalPresentationStyle = .overCurrentContext
        healthVC.modalTransitionStyle = .crossDissolve

        healthVC.viewModel = HealthDisclaimerViewModel(type: type, message: message)

        healthVC.aproveTapped = {
            self.viewModel.delegate = self
            self.viewModel.sendHealthDisclaimer()
        }

        healthVC.rejectTapped = {
            if CompaniesDataManager.shared.mustAcceptHealthDisclaimer() {
                self.showHealthDisclaimer(type: .rejected)
            }
        }

        self.present(healthVC, animated: true, completion: nil)
    }
}

extension DashboardWithoutAppAccessViewController: DashboardWithoutAppAccessViewModelDelegate {
    func showHealthDisclaimer(_ type: HealthDisclaimerType, _ message: String?) {
        self.showHealthDisclaimer(type: type, message: message)
    }

    func reloadView() {
        self.setupUI()
        // self.taskBarView.reloadView()
    }

    func showHealthDisErrorView() {
        let errorView = ViewSource.errorView()
        errorView.modalPresentationStyle = .overCurrentContext
        errorView.modalTransitionStyle = .crossDissolve

        errorView.viewModel = ErrorViewModel(title: nil, message: "CANT_USE_APP_ERROR_MESSAGE".localized, showAproveView: false)

        self.present(errorView, animated: true, completion: nil)
    }
}

extension DashboardWithoutAppAccessViewController: ReachabilityObserverDelegate {

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
