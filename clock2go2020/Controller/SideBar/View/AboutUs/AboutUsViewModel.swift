//
//  AboutUsViewModel.swift
//  clock2go2020
//
//  Created by Kamal Punia on 30/08/23.
//

import Foundation
import UIKit

protocol AboutUsViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: AboutUsViewModel, didReceiveDisclaimer text: String?)
}

class AboutUsViewModel: NSObject {
    
    // MARK: - Variables
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    weak var delegate: AboutUsViewModelDelegate?
    
    // MARK: - Private functions
    ///Get disclaimer text from backend
    func getDiscalimer() {
        self.vc?.view.addSubview(loadingView)
        //let languageCode = AppUtility.getCurrentLanguageCode()
        let languageCode =  UserDefaultsManager.appleLanguagesNew.first ?? "en"
        let getDisclaimerEndpoint = GetDisclaimerEndpoint(disclaimerType: .reportDisclaimer, language: languageCode)
        
        getDisclaimerEndpoint.apiCall { [weak self] response, error in
            guard let `self` = self else {
                return
            }
            self.loadingView.removeFromSuperview()
            self.delegate?.viewModel(self, didReceiveDisclaimer: response?.data)
        }
    }
}
