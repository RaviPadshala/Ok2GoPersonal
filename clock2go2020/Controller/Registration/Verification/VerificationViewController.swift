//
//  VerificationViewController.swift
//  clock2go2020
//
//  Created by Admin on 12/22/19.
//

import UIKit

class VerificationViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var guideView: GuideView!
    @IBOutlet weak var skipView: SkipView!
    
    @IBOutlet weak var logoView: UIView!

    var viewModel = VerificationViewModel()

    // MARK: Override
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setLocalizedStrings()
        setupTaps()

        viewModel.delegate = self
    }

    // MARK: Property
    func setupUI() {
        logoView.roundCorners([.topLeft, .topRight], radius: 30.0)
        roundedView.roundCorners([.topLeft, .topRight], radius: 30.0)
        skipView.isUserInteractionEnabled = viewModel.enableSkipView
    }

    func setLocalizedStrings() {
        titleLabel.text = "WELCOME_TITLE".localized
        verifyLabel.text = "SHOW_USAGE_GUIDE_MESSAGE".localized
        nameTitleLabel.text = ""
    }

    func setupName() {
        nameTitleLabel.text = viewModel.getName()
    }

    func setupTaps() {
        skipView.skipTapped = {
            let vc = ViewSource.dashboardScreen()
            NavigationController.shared?.setRoot(vc, animated: true)
        }
    }
}

extension VerificationViewController: VerificationViewModelDelegate {
    func shouldRefreshView() {
        self.setupName()
        self.skipView.isUserInteractionEnabled = viewModel.enableSkipView
    }

    func shouldShowError(_ message: String?, _ errorCode: Int?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: String(errorCode ?? 0), message: message)
        if errorCode == 401 {
            vc.confirmTapped = {
                let vc = ViewSource.chooseLanguageScreen()
                NavigationController.shared?.setRoot(vc, animated: true)
            }
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
}
