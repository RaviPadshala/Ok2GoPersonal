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
    }

    func dismissView() {
        _ = NavigationController.shared?.popViewController(animated: true)
    }

    @IBAction func backAction(_ sender: Any) {
        dismissView()
    }

}
