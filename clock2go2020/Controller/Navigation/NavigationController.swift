//
//  NavigationController.swift
//  clock2go2020
//
//  Created by Admin on 12/27/19.
//

import UIKit

class NavigationController: UINavigationController {

    static private(set) var shared: NavigationController?
    weak var loader: UIView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        NavigationController.shared = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialController()
    }

    // MARK: - Public.

    @objc func setRoot(_ vc: UIViewController, animated: Bool) {
        if topViewController == vc {
            // Do not switch controller if it's already onscreen.
            return
        }

        self.setViewControllers([vc], animated: animated)
    }

    func getCurrentViewController() -> UIViewController? {
        return topViewController
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    
    func checkRootViewController() {
        setupInitialController()
    }

    // MARK: - Private Methods

    private func setupInitialController() {
        if UserDefaultsManager.udid != nil, UserDefaultsManager.phoneNumber != nil {
            setRoot(ViewSource.dashboardScreen(), animated: true)
        } else {
            setRoot(ViewSource.chooseLanguageScreen(), animated: true)
        }
    }

    func showErrorView(error: ErrorObject?) {
        if error?.error_code == -999 || (error?.error_message ?? "").contains("-999") {
            return
        }
        
        // Remove Pay attention(Hebrew) error
        if error?.error_code == nil && error?.error_message == nil {
            return
        }
        
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        //qwerty

        let savedCompanies = UserDefaultsManager.companiesObj
        let savedUdid = UserDefaultsManager.udid
        
        if error?.error_code == 401 && savedUdid == nil && savedCompanies == nil {
            vc.confirmTapped = {
                let vc = ViewSource.chooseLanguageScreen()
                NavigationController.shared?.setRoot(vc, animated: true)
            }
        }

        var message = error?.error_message
        let errorCode = String(error?.error_code ?? 0)

        if let errorCode = error?.error_code {
            if Int(String(errorCode).localized) == nil {
                message = String(errorCode).localized
            }
        }

        if message == nil, !ReachabilityManager.shared.hasInternetConnection {
            message = "NO_INTERNET_CONNECTION".localized
        }

        vc.viewModel = ErrorViewModel(title: errorCode, message: message)
        self.present(vc, animated: true, completion: nil)
    }

    func showSuccessView(message: String? = nil) {
        let vc = ViewSource.successView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.isStartTimer = true
        vc.viewModel = SuccessViewModel(message: message)

        self.present(vc, animated: true, completion: nil)
    }
    
    func showAuthenticationErrorView() {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = ErrorViewModel(title: nil, message: "authenticationErrorMessage".localized)
        vc.confirmTapped = {
            NavigationController.shared?.checkRootViewController()
        }

        if let vc = self.getCurrentViewController() {
            for subview in vc.view.subviews {
                if subview.isKind(of: LoadingView.self) {
                    subview.removeFromSuperview()
                    break
                }
            }
        }

        self.present(vc, animated: true, completion: nil)
    }
}
