//
//  ErrorView.swift
//  clock2go2020
//
//  Created by Admin on 1/30/20.
//

import UIKit

class ErrorView: UIViewController {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var errorTitle: UILabel!
    @IBOutlet weak var errorMessageTitle: UILabel!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!

    var viewModel: ErrorViewModel?
    var confirmTapped: (() -> Void)?

    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setLocalizedStrings()
        setupTaps()
    }

    override func viewWillLayoutSubviews() {
        config()
    }

    // MARK: Property
    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)
        confirmView.roundCorners([.allCorners], radius: 30.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    func setViewModel(_ viewModel: ErrorViewModel) {
        self.viewModel = viewModel
    }

    func config() {
        guard let viewModel = self.viewModel else { return }

        errorMessageTitle.text = viewModel.message

        errorTitle.isHidden = !viewModel.showAproveView
        confirmView.isHidden = !viewModel.showAproveView
    }

    func setLocalizedStrings() {
        if viewModel?.titleError != nil && viewModel?.titleError != "" && viewModel?.titleError != "0" {
            errorTitle.text = "\("ERROR_WITH_CODE".localized) \(viewModel?.titleError ?? "")"
        } else {
            errorTitle.text = "ERROR".localized
        }

        confirmTitle.text = "CONFIRM".localized
    }

    func setupTaps() {
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmAction))
        confirmView.addGestureRecognizer(confirmTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmAction() {
        self.dismissView()
        confirmTapped?()
    }

}
