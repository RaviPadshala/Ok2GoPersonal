//
//  ReminderTimeViewController.swift
//  clock2go2020
//
//  Created by Admin on 2/11/20.
//

import UIKit

class ReminderTimeViewController: UIViewController {
   
    @IBOutlet weak var accountInfoView: AccountInfoView!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        try? addReachabilityObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        CompanywiseReminderHelper.shared.deleteReminderforAll(clinetId: CompaniesDataManager.shared.getClienId() ?? 0)
      
        removeReachabilityObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.accountInfoView.config(viewModel: AccountInfoViewModel(type: .withoutCompany))

        accountInfoView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.6181033129, green: 0.630385781, blue: 0.6499643084, alpha: 1))
        accountInfoView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)

        let gradient = CAGradientLayer().get(topColor: #colorLiteral(red: 0.0860728398, green: 0.4160004258, blue: 0.7110635638, alpha: 1), bottomColor: #colorLiteral(red: 0.113828741, green: 0.5079905987, blue: 0.8489963412, alpha: 1), isVertical: true, frame: view.frame)
        self.view.layer.insertSublayer(gradient, at: 0)
    }

}

extension ReminderTimeViewController: ReachabilityObserverDelegate {

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
