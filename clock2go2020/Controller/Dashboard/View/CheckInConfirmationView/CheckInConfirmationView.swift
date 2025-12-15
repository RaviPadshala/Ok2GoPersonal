//
//  CheckInConfirmationView.swift
//  clock2go2020
//
//  Created by Kamal Punia on 25/10/23.
//

import UIKit

protocol CheckInConfirmationViewDelegate: AnyObject {
    func view(_ view: CheckInConfirmationView, didPressOk button: UIButton, isCheckIn: Bool)
    func view(_ view: CheckInConfirmationView, didPressCancel button: UIButton)
}

class CheckInConfirmationView: UIViewController {
    
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
    private weak var delegate: CheckInConfirmationViewDelegate?
    private var isCheckIn: Bool = false
    private var time: String = ""
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        if self.isCheckIn {
            headerView.backgroundColor = UIColor(named: "AppGreen")
        }else {
            headerView.backgroundColor = UIColor(named: "AppRed")
        }
    }
    
    // MARK: - IBActions
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.dismissView()
        self.delegate?.view(self, didPressOk: sender, isCheckIn: self.isCheckIn)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismissView()
        self.delegate?.view(self, didPressCancel: sender)
    }
    
    func setupView(delegate: CheckInConfirmationViewDelegate, isForCheckIn: Bool, time: String) {
        self.delegate = delegate
        self.isCheckIn = isForCheckIn
        self.time = time
    }
    
    // MARK: - Private functions
    private func setupUI() {
//        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

        headerView.roundCorners([.allCorners], radius: 50)
        headerView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        headerView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        setupUIForView(okButtonView)
        setupUIForView(cancelButtonView)
        setupUIForView(alertView)
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
        let message = String(format: "identicalReport".localized, time)
        self.titleLabel.text = message
    }
    
    private func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)
        let close = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        closeImageView.addGestureRecognizer(close)
    }

    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
