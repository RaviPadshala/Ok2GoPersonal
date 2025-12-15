//
//  AboutUsViewController.swift
//  clock2go2020
//
//  Created by Admin on 4/8/20.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var textTitle: UILabel!

    // MARK: Override
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private let viewModel = AboutUsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setLocalized()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getDiscalimer()
    }

    func setLocalized() {
        screenTitle.text = "ABOUT_TITLE".localized
//        textTitle.text = "ABOUT_TEXT".localized
    }

    @IBAction func backAction(_ sender: Any) {
        dismissView()
    }

    func dismissView() {
        _ = NavigationController.shared?.popViewController(animated: true)
    }

}

// MARK: - AboutUsViewModelDelegate
extension AboutUsViewController: AboutUsViewModelDelegate {
    func viewModel(_ viewModel: AboutUsViewModel, didReceiveDisclaimer text: String?) {
        textTitle.text = text ?? "ABOUT_TEXT".localized
    }
}
