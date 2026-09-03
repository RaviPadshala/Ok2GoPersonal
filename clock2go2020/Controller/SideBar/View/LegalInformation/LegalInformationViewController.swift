//
//  LegalInformationViewController.swift
//  clock2go2020
//
//  Created by Admin on 4/6/20.
//

import UIKit

class LegalInformationViewController: UIViewController {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var textTitle: UILabel!

    // MARK: Override
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setLocalized()
    }

    func setLocalized() {
        screenTitle.text = "LEGAL_INFORMATION_TITLE".localized
        textTitle.text = "TERMS_TEXT".localized
        
        if self.getCurrentLanguage() == "he" || self.getCurrentLanguage() == "ar"{
            textTitle.textAlignment = .right
        }else{
            textTitle.textAlignment = .left
        }
    }
    
    func getCurrentLanguage() -> String{
        if let selectedLanguage = UserDefaultsManager.appleLanguagesNew.first, selectedLanguage.count > 0{
            return selectedLanguage
        }else{
            return "en"
        }
    }

    func dismissView() {
        _ = NavigationController.shared?.popViewController(animated: true)
    }

    @IBAction func backAction(_ sender: Any) {
        dismissView()
    }

}
