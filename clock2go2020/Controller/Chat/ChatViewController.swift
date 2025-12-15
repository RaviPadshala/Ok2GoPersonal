import UIKit
import WebKit

class ChatViewController: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var view_mainweb: UIView!
    
    var customWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        delay(durationInSeconds: 0.1) {
            self.setupWebView()
        }
        setValues()
//        loadChatURL()
    }

    func setupWebView() {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.websiteDataStore = WKWebsiteDataStore.default()


        // Create new webview
        self.customWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view_mainweb.frame.size.width, height: self.view_mainweb.frame.size.height), configuration: config)
        self.customWebView.navigationDelegate = self
        self.customWebView.uiDelegate = self
        self.customWebView.translatesAutoresizingMaskIntoConstraints = false

        self.view_mainweb.addSubview(self.customWebView)
        
        self.loadChatURL()
    }

    func setValues() {
        self.lblDate.text = self.getSelectedDateInString()
    }

    func getSelectedDateInString(formate: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return formatter.string(from: Date())
    }

    func loadChatURL() {
//        if let strURL = CompaniesDataManager.shared.getChatURL(), strURL.count > 0{
//            
//            var components = URLComponents(string: strURL)!
//            components.queryItems = [
//                URLQueryItem(name: "name", value: CompaniesDataManager.shared.getEmployeeName() ?? ""),
//                URLQueryItem(name: "email", value: CompaniesDataManager.shared.getEmployeeEmail() ?? ""),
//                URLQueryItem(name: "company", value: CompaniesDataManager.shared.getClientName() ?? ""),
//                URLQueryItem(name: "phone", value: UserDefaultsManager.phoneNumber ?? "")
//            ]
//            if let url = components.url {
//                print("strURL", url.absoluteString)
//                let request = URLRequest(url: url)
//                self.customWebView.load(request)
//            }
//            
//        }
        
//        var components = URLComponents(string: "https://widget.yourgpt.ai/d5b33a40-017c-429b-9672-c84f23229502")!
//        components.queryItems = [
//            URLQueryItem(name: "name", value: CompaniesDataManager.shared.getEmployeeName() ?? ""),
//            URLQueryItem(name: "email", value: CompaniesDataManager.shared.getEmployeeEmail() ?? ""),
//            URLQueryItem(name: "company", value: CompaniesDataManager.shared.getClientName() ?? ""),
//            URLQueryItem(name: "phone", value: UserDefaultsManager.phoneNumber ?? "")
//        ]
//        if let url = components.url {
//            let request = URLRequest(url: url)
//            self.customWebView.load(request)
//        }
        
//        let name = CompaniesDataManager.shared.getEmployeeName() ?? ""
//        let email = CompaniesDataManager.shared.getEmployeeEmail() ?? ""
//        let company = CompaniesDataManager.shared.getClientName() ?? ""
//        let phone = UserDefaultsManager.phoneNumber ?? ""
//        
        let url = URL(string: "https://widget.yourgpt.ai/d5b33a40-017c-429b-9672-c84f23229502")!
        let request = URLRequest(url: url)
        self.customWebView.load(request)
    }

    func dismissView() {
        _ = NavigationController.shared?.popViewController(animated: true)
    }

    @IBAction func backAction(_ sender: Any) {
        if self.customWebView.canGoBack {
            self.customWebView.goBack()
        } else {
            self.dismissView()
        }
    }
}

extension ChatViewController: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Handle window.open or target="_blank"
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }

}
