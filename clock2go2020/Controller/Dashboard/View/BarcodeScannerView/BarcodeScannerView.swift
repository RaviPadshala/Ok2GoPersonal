//
//  BarcodeScannerView.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 09.02.2022.
//

import UIKit

class BarcodeScannerView: UIView {
    
    // MARK: - UI Components
    
    private var contentView: UIView!
    private var scannerButton: UIButton?
    private var nfcButton: UIButton?
    private var beaconButton: UIButton?
    
    // MARK: - Actions
    
    var onScanAction: (() -> Void)?
    var onNFCScanAction: (() -> Void)?
    var onBeaconScanAction: (() -> Void)?
    
    // MARK: - Constants
    
    private let buttonSize: CGFloat = 40.0
    private let buttonSpacing: CGFloat = 20.0
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        
        contentView = UIView(frame: bounds)
        
        contentView.backgroundColor = .white
        
        contentView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        
        addSubview(contentView)
        
        setupFeatureButtons()
        setupUI()
    }
    
    // MARK: - Update Feature List
    
    @objc func updateList() {
        
        // Remove existing buttons
        scannerButton?.removeFromSuperview()
        nfcButton?.removeFromSuperview()
        beaconButton?.removeFromSuperview()
        
        scannerButton = nil
        nfcButton = nil
        beaconButton = nil
        
        // Create buttons again according to enabled features
        setupFeatureButtons()
    }
    
    // MARK: - Feature Buttons
    
    private func setupFeatureButtons() {
        
        let hasBarcode =
        CompaniesDataManager.shared.hasBarcodeReportsFeature()
        
        let hasNFC =
        CompaniesDataManager.shared.hasNFCReportsFeature()
        
        let hasBeacon =
        CompaniesDataManager.shared.hasBeaconRportsFeature()
        
        var buttons: [UIButton] = []
        
        // --------------------------------------------------
        // Barcode
        // --------------------------------------------------
        
        if hasBarcode {
            
            scannerButton = createButton(
                imageName: "barcode_icon",
                action: #selector(startScanningAction)
            )
            
            if let scannerButton = scannerButton {
                buttons.append(scannerButton)
            }
        }
        
        // --------------------------------------------------
        // NFC
        // --------------------------------------------------
        
        if hasNFC {
            
            nfcButton = createButton(
                imageName: "nfc",
                action: #selector(startNFCScanningAction)
            )
            nfcButton?.imageView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
            
            if let nfcButton = nfcButton {
                buttons.append(nfcButton)
            }
        }
        
        // --------------------------------------------------
        // Beacon / Bluetooth Scan
        // --------------------------------------------------
        
        if hasBeacon {
            
            beaconButton = createButton(
                imageName: "bluetooth_scan",
                action: #selector(startBeaconScanningAction)
            )
//            beaconButton?.imageView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
            
            if let beaconButton = beaconButton {
                buttons.append(beaconButton)
            }
        }
        
        // Position buttons
        positionButtons(buttons)
    }
    
    // MARK: - Create Button
    
    private func createButton(
        imageName: String,
        action: Selector
    ) -> UIButton {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(
            x: 0,
            y: 0,
            width: buttonSize,
            height: buttonSize
        )
        
        button.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin
        ]
        
        button.setImage(
            UIImage(named: imageName),
            for: .normal
        )
        
        button.imageView?.contentMode = .scaleAspectFit
        
        button.addTarget(
            self,
            action: action,
            for: .touchUpInside
        )
        
        addSubview(button)
        
        return button
    }
    
    // MARK: - Position Buttons
    
    private func positionButtons(_ buttons: [UIButton]) {
        
        guard !buttons.isEmpty else {
            return
        }
        
        let totalWidth =
        (CGFloat(buttons.count) * buttonSize) +
        (CGFloat(buttons.count - 1) * buttonSpacing)
        
        let startX =
        (bounds.width - totalWidth) / 2.0
        
        for (index, button) in buttons.enumerated() {
            
            let x =
            startX +
            CGFloat(index) * (buttonSize + buttonSpacing)
            
            button.frame = CGRect(
                x: x,
                y: 0.0,
                width: buttonSize,
                height: buttonSize
            )
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var buttons: [UIButton] = []
        
        if let scannerButton = scannerButton {
            buttons.append(scannerButton)
        }
        
        if let nfcButton = nfcButton {
            buttons.append(nfcButton)
        }
        
        if let beaconButton = beaconButton {
            buttons.append(beaconButton)
        }
        
        positionButtons(buttons)
    }
    
    // MARK: - UI
    
    func setupUI() {
        contentView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        contentView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }
    
    // MARK: - Barcode Scan
    
    @objc private func startScanningAction() {
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            self.showNoInternetPopup()
            return
        }
        onScanAction?()
    }
    
    @objc private func startNFCScanningAction() {
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            self.showNoInternetPopup()
            return
        }
        onNFCScanAction?()
    }
    
    @objc private func startBeaconScanningAction() {
        
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            showNoInternetPopup()
            return
        }
        
        // IMPORTANT:
        // This was incorrectly calling onNFCScanAction
        onBeaconScanAction?()
    }
    
    func showNoInternetPopup() {
        
//        if isAirplaneModeOn(){
//            self.showFlightModePopup()
//            return
//        }
        isAirplaneModeOnNew { isAirplane in
            if isAirplane {
                self.showFlightModePopup()
                return
            }else{
                let alertController = UIAlertController(title: "no_internet_message_alert".localized, message: "", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                alertController.addAction(settingsAction)
                alertController.modalPresentationStyle = .overCurrentContext
                alertController.modalTransitionStyle = .crossDissolve
                
                NavigationController.shared?.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func showFlightModePopup() {
        let alertController = UIAlertController(title: "airplane_mode_turned_off_message_alert".localized, message: "", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "SETTINGS".localized, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: "App-Prefs:root=AIRPLANE_MODE") else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve
        
        NavigationController.shared?.present(alertController, animated: true, completion: nil)
    }
}
