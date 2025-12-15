//
//  FormWebViewController.swift
//  clock2go2020
//
//  Created by Mac on 26/09/24.
//

import UIKit
import WebKit

class FormWebViewController: UIViewController,WKNavigationDelegate, WKScriptMessageHandler {
    
    
    @IBOutlet weak var btn_skip: UIButton!
    @IBOutlet weak var accountInfoView: HeaderView!
    @IBOutlet weak var btn_skipHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var webView: WKWebView!
    
    var url:String?
    var formName : String?
    var mandotoryBeforeReport = false
    var isFormListView = false
    var actionTag: Int = 0
    var formdataArr = [FormData]()
    
    var activityIndicator: UIActivityIndicatorView!
    var isFillForm = Bool()
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "closeWebView", let messageBody = message.body as? String {
            if messageBody == "formSubmitted" {
                
                // Form submission detected, close the web view and navigate back to the list of forms
                print("Form submission detected, closing WebView.")
                self.loadData{success in
                    
                    if self.isFormListView{
                        self.showSuccessDialog(message: "Form_sign_successfully".localized)
                    }else{
                        self.isFillForm = true
                        self.formdataArr.removeFirst()
                        if self.formdataArr.count == 0{
                            self.showSuccessDialog(message: "Form_sign_successfully".localized)
                        }else{
                            if let dict = self.formdataArr.first, let urlstr = dict.url{
                                self.url = urlstr
                                self.formName = dict.formName ?? ""
                                if let conditions = dict.conditions, let manadatoryReport = conditions.mandatoryBeforeReport, manadatoryReport == 1{
                                    self.mandotoryBeforeReport = true
                                    self.btn_skipHeightConstraint.constant = 0.0
                                }else{
                                    self.mandotoryBeforeReport = false
                                    self.btn_skipHeightConstraint.constant = 50.0
                                }
                                self.accountInfoView.changeHeaderTitle(text: self.formName)
                                if let url = URL(string: self.url ?? "") {
                                    let request = URLRequest(url: url)
                                    self.webView.load(request)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // Clean up: Remove the script message handler when the view controller is deallocated
    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "closeWebView")
    }
    
    
    
    // @IBOutlet weak var reminderDaysView: FormView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
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
        // Initialize the activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center // Position it at the center of the view
        activityIndicator.hidesWhenStopped = true // Hide when not animating
        self.view.addSubview(activityIndicator)
        accountInfoView.changeHeaderTitle(text: formName)
        setupUI()
        startLoading()
        setupActions()
        
        // Access the existing configuration of the storyboard WKWebView
        let contentController = webView.configuration.userContentController
        
        // Add the script message handler to listen for JavaScript events
        contentController.add(self, name: "closeWebView")
        webView.navigationDelegate = self
        if self.isFormListView{
            self.btn_skipHeightConstraint.constant = 0.0
            if let url = URL(string: url ?? "") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }else{
            if self.formdataArr.count > 0, let dict = self.formdataArr.first, let urlstr = dict.url{
                self.url = urlstr
                self.formName = dict.formName ?? ""
                if let conditions = dict.conditions, let manadatoryReport = conditions.mandatoryBeforeReport, manadatoryReport == 1{
                    self.mandotoryBeforeReport = true
                    self.btn_skipHeightConstraint.constant = 0.0
                }else{
                    self.mandotoryBeforeReport = false
                    self.btn_skipHeightConstraint.constant = 50.0
                }
                accountInfoView.changeHeaderTitle(text: self.formName)
                if let url = URL(string: url ?? "") {
                    let request = URLRequest(url: url)
                    webView.load(request)
                }
            }else{
                if let url = URL(string: url ?? "") {
                    let request = URLRequest(url: url)
                    webView.load(request)
                }
            }
        }
    }
    func setupActions(){
        accountInfoView.backButtonTapped = {
            if self.mandotoryBeforeReport{
                self.showErrorView(title: nil, message: "Fill_out_form_data".localized)
            }else{
                self.navigationController?.popViewController(animated: true)
                if !self.isFormListView{
                    let logoutDataDict:[String: Int] = ["actionTag": self.actionTag]
                    NotificationCenter.default.post(name: NSNotification.Name("DidReturnFromFormWebViewControllerForDashBoard"), object: nil, userInfo: logoutDataDict)
                }
            }
        }
    }
    func showErrorView(title: String?, message: String?) {
        if (title ?? "").contains("-999") { return }
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: title, message: message)
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
    
    func showSuccessDialog(message: String){
        let vc = ViewSource.successView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.isStartTimer = true
        vc.viewModel = SuccessViewModel(message: message)
        
        vc.confirmTapped = {
            
            if self.isFormListView{
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name("DidReturnFromFormWebViewController"), object: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
                let logoutDataDict:[String: Int] = ["actionTag": self.actionTag]
                NotificationCenter.default.post(name: NSNotification.Name("DidReturnFromFormWebViewControllerForDashBoard"), object: nil, userInfo: logoutDataDict)
            }
            
        }

        self.present(vc, animated: true, completion: nil)
    }
    
    func startLoading() {
        // Start animating the activity indicator
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        // Stop animating the activity indicator
        activityIndicator.stopAnimating()
    }
    
    func setupUI() {
        // self.accountInfoView.config(viewModel: AccountInfoViewModel(type: .withoutCompany))
        
        accountInfoView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.6181033129, green: 0.630385781, blue: 0.6499643084, alpha: 1))
        accountInfoView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
        
        let gradient = CAGradientLayer().get(topColor: #colorLiteral(red: 0.0860728398, green: 0.4160004258, blue: 0.7110635638, alpha: 1), bottomColor: #colorLiteral(red: 0.113828741, green: 0.5079905987, blue: 0.8489963412, alpha: 1), isVertical: true, frame: view.frame)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.btn_skip.setTitle("SKIP".localized, for: .normal)
    }
    
    func loadData(completion: @escaping (Bool) -> Void) {
        vc?.view.addSubview(loadingView)
        let company = GetCompaniesEndpoint()
        
        company.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()  // Get rid of the spinner ASAP!
            
            if error?.success ?? false {
                CompaniesDataManager.shared.setCompanies(result?.data)
                completion(true)  // Yay, everything worked!
            } else {
                NavigationController.shared?.showErrorView(error: error)
                completion(false)  // Something went wrong 😔
            }
        }
    }
    
    @IBAction func btn_skip(_ sender: UIButton) {
        self.formdataArr.removeFirst()
        if self.formdataArr.count == 0{
            if self.isFillForm{
                self.showSuccessDialog(message: "Form_sign_successfully".localized)
            }else{
                self.navigationController?.popViewController(animated: true)
                let logoutDataDict:[String: Int] = ["actionTag": self.actionTag]
                NotificationCenter.default.post(name: NSNotification.Name("DidReturnFromFormWebViewControllerForDashBoard"), object: nil, userInfo: logoutDataDict)
            }
        }else{
            if let dict = self.formdataArr.first, let urlstr = dict.url{
                self.url = urlstr
                self.formName = dict.formName ?? ""
                if let conditions = dict.conditions, let manadatoryReport = conditions.mandatoryBeforeReport, manadatoryReport == 1{
                    self.mandotoryBeforeReport = true
                    self.btn_skipHeightConstraint.constant = 0.0
                }else{
                    self.mandotoryBeforeReport = false
                    self.btn_skipHeightConstraint.constant = 50.0
                }
                self.accountInfoView.changeHeaderTitle(text: self.formName)
                if let url = URL(string: self.url ?? "") {
                    let request = URLRequest(url: url)
                    self.webView.load(request)
                }
            }
        }
    }
}

extension FormWebViewController {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started loading...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading!")
        stopLoading()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load with error: \(error.localizedDescription)")
        stopLoading()
        shouldShowError("Failed to load Form")
    }
    
    func shouldShowError(_ message: String?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel( title: nil, message: message)
        
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
}

extension FormWebViewController: ReachabilityObserverDelegate {
    
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
