//
//  FormViewController.swift
//  clock2go2020
//
//  Created by Mac on 26/09/24.
//

import UIKit

class FormViewController: UIViewController {
    @IBOutlet weak var accountInfoView: HeaderView!
    
    @IBOutlet weak var formView: FormView!
    // @IBOutlet weak var reminderDaysView: FormView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formView.refresh()
        try? addReachabilityObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeReachabilityObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReturnFromSecondVC), name: NSNotification.Name("DidReturnFromFormWebViewController"), object: nil)
        accountInfoView.changeHeaderTitle(text: "Forms".localized)
        setupUI()
        setupActions()
        
    }
    
    @objc func handleReturnFromSecondVC() {
        
        // Perform any action needed here
        formView.refresh()
    }
    
    func setupUI() {
        // self.accountInfoView.config(viewModel: AccountInfoViewModel(type: .withoutCompany))
        accountInfoView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
        accountInfoView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.6181033129, green: 0.630385781, blue: 0.6499643084, alpha: 1))
        
        
//        let gradient = CAGradientLayer().get(topColor: #colorLiteral(red: 0.0860728398, green: 0.4160004258, blue: 0.7110635638, alpha: 1), bottomColor: #colorLiteral(red: 0.113828741, green: 0.5079905987, blue: 0.8489963412, alpha: 1), isVertical: true, frame: view.frame)
//        self.view.layer.insertSublayer(gradient, at: 0)
    }
    func setupActions(){
        accountInfoView.backButtonTapped = {
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
}
extension FormViewController: ReachabilityObserverDelegate {
    
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
