//
//  PhoneInputViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/9/20.
//

import UIKit
import OneSignal

class PhoneInputViewModel {

    var isTermsSelected = false
    var phoneNumber: String = ""

    weak var delegate: PhoneInputViewModelDelegate?

    func setPhoneNumber(number: String) {
        phoneNumber = number
    }

    func getTermsModel() -> TermsViewModel {
        return TermsViewModel(type: .common)
    }

    func getTermsButtonImage() -> UIImage {
        return isTermsSelected ? #imageLiteral(resourceName: "checked_terms") : #imageLiteral(resourceName: "unchecked_terms")
    }

    func changeTermsSelection() {
        isTermsSelected = !isTermsSelected
    }

    func selectTerms() {
        isTermsSelected = true
    }

    func shouldEnableContinueView() -> Bool {
        return isTermsSelected
    }

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    // api call
    func sendPhoneNumber() {
        guard shouldEnableContinueView() else { return }
        vc?.view.addSubview(loadingView)

        /// get oneSignal user id
        var notificationID: String = ""
        if    UserDefaultsManager.oneSignalUserId != nil &&  UserDefaultsManager.oneSignalUserId != "" {
            notificationID =   UserDefaultsManager.oneSignalUserId ?? ""
        } else {
            guard let userID = OneSignal.getPermissionSubscriptionState()?.subscriptionStatus.userId else {
              NavigationController.shared?.showErrorView(error: ErrorObject(success: false, error_message: "400".localized, error_code: nil))
                return
            }
            notificationID = userID
        }

        /// api call
        let register = RegisterEndpoint.init(phone: phoneNumber, notificationID: notificationID)

        register.apiCall { (error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                UserDefaultsManager.phoneNumber = self.phoneNumber

                let vc = ViewSource.passwordInputScreen()
                NavigationController.shared?.pushViewController(vc, animated: true)
            } else {
                self.delegate?.shouldShowWrongUI(error: error)
            }
        }
    }

}

protocol PhoneInputViewModelDelegate: NSObjectProtocol {
    func shouldShowWrongUI(error: ErrorObject?)
}
