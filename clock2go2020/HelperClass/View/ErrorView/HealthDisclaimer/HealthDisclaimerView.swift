//
//  HealthDisclaimerView.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/27/20.
//

import UIKit

class HealthDisclaimerView: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var imageIconView: UIImageView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var titleConfirmView: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var disclaimerStackView: UIStackView!
    @IBOutlet weak var aproveDisclaimerView: UIView!
    @IBOutlet weak var titleAaproveDisclaimerView: UILabel!
    @IBOutlet weak var rejectDisclaimerView: UIView!
    @IBOutlet weak var titleRejectDisclaimerView: UILabel!

    var viewModel: HealthDisclaimerViewModel!

    var aproveTapped: (() -> Void)?
    var rejectTapped: (() -> Void)?
    var confirmTapped: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setLocalizedStrings()
        setupTaps()
    }

    override func viewWillLayoutSubviews() {
        config()
    }

    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)
        confirmView.roundCorners([.allCorners], radius: 28.5)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        aproveDisclaimerView.roundCorners([.allCorners], radius: 28.5)
        rejectDisclaimerView.roundCorners([.allCorners], radius: 28.5)
    }

    func setLocalizedStrings() {
        titleConfirmView.text = "CONFIRM".localized
        titleAaproveDisclaimerView.text = "HEALTH_APPROVE".localized
        titleRejectDisclaimerView.text = "HEALTH_REJECT".localized
    }

    func config() {
        disclaimerLabel.text = viewModel.getMessageTitle()
        iconView.backgroundColor = viewModel.getColor()
        imageIconView.image = viewModel.getImage()

        disclaimerStackView.isHidden = viewModel.shouldShowConfirmView()
        confirmView.isHidden = !viewModel.shouldShowConfirmView()
    }

    func setupTaps() {
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmAction))
        confirmView.addGestureRecognizer(confirmTap)

        let approveDisclaimerTap = UITapGestureRecognizer(target: self, action: #selector(approveDisclaimerAction))
        aproveDisclaimerView.addGestureRecognizer(approveDisclaimerTap)

        let rejectDisclaimerTap = UITapGestureRecognizer(target: self, action: #selector(rejectDisclaimerAction))
        rejectDisclaimerView.addGestureRecognizer(rejectDisclaimerTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmAction() {
        if viewModel.type == .accepted {
            DispatchQueue.main.async(execute: {
                self.dismiss(animated: true) {
                    self.confirmTapped?()
                }
            })
        } else {
            dismissView()
        }
    }

    @objc func approveDisclaimerAction() {
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true) {
                self.aproveTapped?()
            }
        })
    }

    @objc func rejectDisclaimerAction() {
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true) {
                self.rejectTapped?()
            }
        })
    }
}
