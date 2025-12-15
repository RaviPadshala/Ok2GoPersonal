//
//  TermsViewController.swift
//  clock2go2020
//
//  Created by Admin on 4/9/20.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!

    var viewModel: TermsViewModel!

    var confirmTapped: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setValues()
        setupUI()
        setTaps()
    }

    func setValues() {
        screenTitle.text = viewModel.getTitle()
        textTitle.text = viewModel.getMessage()
        backButton.isHidden = viewModel.shouldHideBackButton()
        confirmTitle.text = "CONFIRM".localized
    }

    func setupUI() {
        confirmView.roundCorners(.allCorners, radius: 30.0)
    }

    func setTaps() {
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmAction))
        confirmView.addGestureRecognizer(confirmTap)
    }

    func dismissView() {
        _ = NavigationController.shared?.popViewController(animated: true)
    }

    @objc func confirmAction() {
        dismissView()
        confirmTapped?()
    }

    @IBAction func backAction(_ sender: Any) {
        dismissView()
    }

}
