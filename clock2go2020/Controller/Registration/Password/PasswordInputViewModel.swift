//
//  PasswordInputViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/15/20.
//

import UIKit
import OneSignal

class PasswordInputViewModel {

    weak var delegate: PasswordInputViewModelDelegate?

    var password: String = ""

    func setPassword(password: String) {
        self.password = password
        if self.password.count >= 7 {
            sendPassword()
        }
    }

    func shouldEnableContinueView() -> Bool {
        return password != ""
    }

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    // api call
    func sendPassword() {        
        guard shouldEnableContinueView() else { return }
        vc?.view.addSubview(loadingView)

        let verify = VerifyCodeEndpoint(verificationCode: password)
        verify.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            if error?.success ?? false {
                UserDefaultsManager.udid = result?.data.udid
                print("\(String(describing: result))")

                let vc = ViewSource.verificationScreen()
                NavigationController.shared?.pushViewController(vc, animated: true)
            } else {
                if error?.error_code == 401 {
                    self.delegate?.shouldShowWrongUI("NOT_ALLOWED_TO_USE_THE_APP".localized)
                } else {
                    self.delegate?.shouldShowWrongUI("WRONG_CODE_MESSAGE".localized)
                }
            }
        }
    }

    func resendPassword() {
        if let phone =  UserDefaultsManager.phoneNumber {
            let notificationID = OneSignal.getPermissionSubscriptionState()?.subscriptionStatus.userId ?? ""
            let register = RegisterEndpoint.init(phone: phone, notificationID: notificationID)
            vc?.view.addSubview(loadingView)

            register.apiCall { (error) in
                self.loadingView.removeFromSuperview()

                if (error?.success ?? false) == false {
                    NavigationController.shared?.showErrorView(error: error)
                }
            }
        }
    }
}

protocol PasswordInputViewModelDelegate: NSObjectProtocol {
    func shouldShowWrongUI(_ message: String)
}
