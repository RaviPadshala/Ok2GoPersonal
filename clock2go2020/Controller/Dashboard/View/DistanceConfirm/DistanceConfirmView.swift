//
//  DistanceConfirmView.swift
//  clock2go2020
//
//  Created by Admin on 4/7/20.
//

import UIKit

class DistanceConfirmView: UIViewController {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var successLoginLabel: UILabel!
    @IBOutlet weak var trackingTitle: UILabel!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmViewTitle: UILabel!

    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewTitle: UILabel!

    var viewModel: DistanceConfirmViewModel!

    var confirmAction: (() -> Void)?
    var closeAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setLocalizedStrings()
        setupUI()
        setupTaps()
        setupValues()
    }

    // MARK: Property
    func setLocalizedStrings() {
        cancelViewTitle.text = "CANCEL".localized
    }

    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        setupUIForView(confirmView)
        setupUIForView(cancelView)
    }

    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 30.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        backgroundView.addGestureRecognizer(tap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        confirmView.addGestureRecognizer(confirmTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmTapped() {
        dismissView()
        confirmAction?()

        if viewModel.shouldSendCloseAction() {
            closeAction?()
        }
    }

    @objc func cancelTapped() {
        dismissView()
        closeAction?()
    }

    func setupValues() {
        successLoginLabel.isHidden = !viewModel.shouldShowLoginTitle()

        trackingTitle.text = viewModel.getTrackingTitle()
        confirmViewTitle.text = viewModel.getConfirmTitle()

        cancelView.isHidden = viewModel.shouldHideCancelButton()
    }
}
