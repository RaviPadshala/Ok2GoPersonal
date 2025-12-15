//
//  NotificationViewController.swift
//  clock2go2020
//
//  Created by Admin on 2/10/20.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var accountInfoView: AccountInfoView!
    @IBOutlet weak var notificationView: NotificationView!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(setupUI), name: Notification.Name(rawValue: "PushNotificationRecieved"), object: nil)

        try? addReachabilityObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeReachabilityObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @objc func setupUI() {
        self.accountInfoView.config(viewModel: AccountInfoViewModel(type: .withoutInfo))
        self.notificationView.reloadView()
    }

}

extension NotificationViewController: ReachabilityObserverDelegate {

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
