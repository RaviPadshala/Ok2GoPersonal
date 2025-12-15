//
//  ConfirmationAlertView.swift
//  clock2go2020
//
//  Created by Kamal Punia on 31/10/23.
//

import UIKit

protocol ConfirmationAlertViewDelegate: AnyObject {
    func view(_ view: ConfirmationAlertView, didPressOk button: UIButton)
    func view(_ view: ConfirmationAlertView, didPressCancel button: UIButton)
}

class ConfirmationAlertView: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var okButtonView: UIView!
    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var okLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    
    // MARK: - Variables
    private weak var delegate: ConfirmationAlertViewDelegate?
    private var message: String = ""
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - IBActions
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.dismissView()
        self.delegate?.view(self, didPressOk: sender)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismissView()
        self.delegate?.view(self, didPressCancel: sender)
    }
    
    func setupView(delegate: ConfirmationAlertViewDelegate, message: String) {
        self.delegate = delegate
        self.message = message
    }
    
    // MARK: - Private functions
    private func setupUI() {
        alertView.roundCorners([.topRight, .topLeft], radius: 30.0)
        alertView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        headerView.roundCorners([.allCorners], radius: 50)
        headerView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        headerView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        headerView.backgroundColor = UIColor(named: "AppGreen")

        setupUIForView(okButtonView)
        setupUIForView(cancelButtonView)
        setLocalizedStrings()
        setupTaps()
    }

    private func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 30.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }
    
    private func setLocalizedStrings() {
        okLabel.text = "ok".localized
        cancelLabel.text = "CANCEL".localized
        self.titleLabel.text = self.message
    }
    
    private func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)
        let close = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        closeImageView.addGestureRecognizer(close)
    }

    @objc private func dismissView() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperViewWithAnimation()
        self.removeFromParent()
    }
}
