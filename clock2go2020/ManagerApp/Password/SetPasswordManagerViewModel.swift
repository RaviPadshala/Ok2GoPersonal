//
//  SetPasswordManagerViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/13/20.
//

import UIKit

class SetPasswordManagerViewModel {

    var password: String = ""
    weak var delegate: SetupWrongMgrPasswordDelegate?

    func setPassword(password: String?) {
        self.password = password ?? ""
    }

    func shouldEnableConfirmView() -> Bool {
        return password != ""
    }

    func pushToManagetApp() {
        let vc = ViewSource.managerScreen()
        NavigationController.shared?.setRoot(vc, animated: true)
    }

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    // api call
    func sendManagerLogin() {
        vc?.view.addSubview(loadingView)

        let login = ManagerAppLoginEndpoint(passwd: password)
        login.apiCall { [self] result, error in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                ManagerAppDataManager.shared.setManagerToken(token: result)
                pushToManagetApp()
            } else {
                delegate?.setupWrongPassword()
            }
        }
    }
}

protocol SetupWrongMgrPasswordDelegate: NSObjectProtocol {
    func setupWrongPassword()
}
