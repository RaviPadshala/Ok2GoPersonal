//
//  UserProfileViewController.swift
//  clock2go2020
//
//  Created by Admin on 2/10/20.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    var currentCLientId : Int?
    @IBOutlet weak var accountInfoView: AccountInfoView!
    @IBOutlet weak var userProfileView: UserProfileView!
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        didCompanyChnage()
        
        setupUI()
        setupAccountInfoView()
        setupUserProfileView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupAccountInfoView()

        try? addReachabilityObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        removeReachabilityObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if currentCLientId != UserDefaultsManager.clientId{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CompanyChnage"), object: nil)
        }
    }
    func didCompanyChnage(){
        if let clientId = UserDefaultsManager.clientId{
            currentCLientId = clientId
        }
    }
    func setupUI() {
        let gradient = CAGradientLayer().get(topColor: #colorLiteral(red: 0.0860728398, green: 0.4160004258, blue: 0.7110635638, alpha: 1), bottomColor: #colorLiteral(red: 0.113828741, green: 0.5079905987, blue: 0.8489963412, alpha: 1), isVertical: true, frame: view.frame)
        self.view.layer.insertSublayer(gradient, at: 0)
    }

    func setupAccountInfoView() {
        accountInfoView.config(viewModel: AccountInfoViewModel(type: .withoutCompany))

        accountInfoView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.6181033129, green: 0.630385781, blue: 0.6499643084, alpha: 1))
        accountInfoView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
    }

    func setupUserProfileView() {
        userProfileView.delegate = self
       
    }

    func loadData() {
        vc?.view.addSubview(loadingView)
        let company = GetCompaniesEndpoint()
        company.apiCall { (result, error) in
            if error?.success ?? false {
                CompaniesDataManager.shared.setCompanies(result?.data)
                self.loadingView.removeFromSuperview()
                
            } else {
                self.loadingView.removeFromSuperview()
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }
}

extension UserProfileViewController: UserProfileViewDelegate {

    func userDidChangeCompany() {
        setupAccountInfoView()
        loadData()
 
    }

}



extension UserProfileViewController: ReachabilityObserverDelegate {

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
