//
//  ChooseLanguageViewController.swift
//  clock2go2020
//
//  Created by Admin on 12/20/19.
//

import UIKit

class ChooseLanguageViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cooseLanguageLabel: UILabel!
    @IBOutlet weak var chooseLanguageView: ChooseLanguageView!
    @IBOutlet weak var continueView: ContinueRegistrationView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    private let viewModel = ChooseLanguageViewModel()

    override var prefersStatusBarHidden: Bool {
        return true
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupPushToNextVC()
        setupChangeLanguage()
        setLocalizedStrings()
        setSelectedLanguageView()
        viewModel.resetUDID()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        roundedView.clipsToBounds = false
        NavigationController.shared?.setNavigationBarHidden(true, animated: animated)
    }

    func setupUI() {
        logoView.roundCorners([.topLeft, .topRight], radius: 30.0)
            //logoView.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
       // logoView.dropShadow()
        //logoView.clipsToBounds = true
       
       // logoImageView.applyshadowWithCorner(containerView: logoView, cornerRadious: 30)
      
        roundedView.roundCorners([.topLeft, .topRight], radius: 30.0)
    }

    func setLocalizedStrings() {
        titleLabel.text = "CHOOSE_LANGUAGE_TITLE".localized
        cooseLanguageLabel.text = "SELECT_LANGUAGE_MESSAGE".localized

        continueView.setLocalizedStrings()
    }

    func setupPushToNextVC() {
        continueView.continueTapped = {
            let vc = ViewSource.phoneInputScreen()
            NavigationController.shared?.pushViewController(vc, animated: true)
        }
    }

    func setupChangeLanguage() {
        chooseLanguageView.changeLanguageTapped = {
            self.showChangeLanguageListView()
        }
    }

    func showChangeLanguageListView() {
        let vc = ViewSource.languageListScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)

        vc.delegate = self
    }

    func setSelectedLanguageView() {
        if let langString = UserDefaultsManager.appleLanguagesNew.first,
            let lang = LanguageEntity.withIdentifier(langString) {
            chooseLanguageView.titleLabel.text = lang.languageTitle
            chooseLanguageView.languageImage.image = lang.languageImage
        }
    }
}

extension ChooseLanguageViewController: LanguageListDelegate {

    func userDidTapLanguage(_ row: Int) {
        self.setSelectedLanguageView()
        self.setLocalizedStrings()
    }

}
