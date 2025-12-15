//
//  PersonalInfoViewController.swift
//  clock2go2020
//
//  Created by Admin on 2/6/20.
//

import UIKit

class PersonalInfoViewController: UIViewController {

    @IBOutlet weak var accountInfoView: AccountInfoView!
    @IBOutlet weak var personalInfoView: PersonalInfoView!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!

    let loadingView = LoadingView()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        try? addReachabilityObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)

        removeReachabilityObserver()
    }

    func setupUI() {
        loadingView.frame = self.view.frame

        self.accountInfoView.config(viewModel: AccountInfoViewModel(type: .withoutInfo))

        accountInfoView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.6181033129, green: 0.630385781, blue: 0.6499643084, alpha: 1))
        accountInfoView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)

        let gradient = CAGradientLayer().get(topColor: #colorLiteral(red: 0.0860728398, green: 0.4160004258, blue: 0.7110635638, alpha: 1), bottomColor: #colorLiteral(red: 0.113828741, green: 0.5079905987, blue: 0.8489963412, alpha: 1), isVertical: true, frame: view.frame)

        self.view.layer.insertSublayer(gradient, at: 0)

        personalInfoView.delegate = self
    }

    func saveChanges(name: String, email: String) {
        self.view.addSubview(self.loadingView)

        let updateUserInfo = UpdateInfoEndpoint(name: name, email: email)
        updateUserInfo.apiCall { (error) in

            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                print("update info: success")
                CompaniesDataManager.shared.setEmploeeEmail(email)
                NavigationController.shared?.popViewControllers(viewsToPop: 1)
            } else {
                print("update info: failed")
                // self.showErrorView(message: error?.error_message)
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

    func showErrorView(title: String?, message: String?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: title, message: message)
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    // keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight = CGFloat(0.0)

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 3) {
            self.stackViewBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.stackViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

}

extension PersonalInfoViewController: PersonalInfoViewDelegate {
    func userDidTapSave(_ name: String, _ email: String) {
        saveChanges(name: name, email: email)
    }
}

extension PersonalInfoViewController: ReachabilityObserverDelegate {

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
