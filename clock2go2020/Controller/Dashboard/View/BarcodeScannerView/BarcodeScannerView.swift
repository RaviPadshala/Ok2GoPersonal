//
//  BarcodeScannerView.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 09.02.2022.
//

import UIKit

class BarcodeScannerView: UIView {
    
    private var contentView: UIView!
    private var scannerButton: UIButton!
    private var nfcButton: UIButton!
    
    var onScanAction: (() -> ())?
    var onNFCScanAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

        commonInit()
    }

    @objc func updateList(){
        if scannerButton != nil {
            scannerButton.removeFromSuperview()
        }
        if nfcButton != nil{
            nfcButton.removeFromSuperview()
        }
        
        
        if CompaniesDataManager.shared.hasBarcodeReportsFeature() && CompaniesDataManager.shared.hasNFCReportsFeature(){
            NFCAndBarcodeFeature()
        }else  if CompaniesDataManager.shared.hasBarcodeReportsFeature() {
            onlyBarcodeScannerFeautre()
        }else  if CompaniesDataManager.shared.hasNFCReportsFeature(){
            onlyNfcScannerFeautre()
        }

       }
    private func commonInit() {
        contentView = UIView(frame: bounds)
        contentView.backgroundColor = .white
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
       // NFCAndBarcodeFeature()
        if CompaniesDataManager.shared.hasBarcodeReportsFeature() && CompaniesDataManager.shared.hasNFCReportsFeature(){
            NFCAndBarcodeFeature()
        }else  if CompaniesDataManager.shared.hasBarcodeReportsFeature() {
            onlyBarcodeScannerFeautre()
        }else  if CompaniesDataManager.shared.hasNFCReportsFeature(){
            onlyNfcScannerFeautre()
        }
       
        
        setupUI()
    }
    
    
    func NFCAndBarcodeFeature(){
        scannerButton = UIButton(frame: CGRect(x: (bounds.width - 110) / 2.0, y: 0.0, width: 40.0, height: 40.0))
        scannerButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        scannerButton.setImage(UIImage(named: "barcode_icon"), for: .normal)
        scannerButton.addTarget(self, action: #selector(startScanningAction), for: .touchUpInside)
        addSubview(scannerButton)
        
        nfcButton = UIButton(frame: CGRect(x: (bounds.width + 30.0) / 2.0, y: 0.0, width: 40.0, height: 40.0))
        //nfcButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
      
        nfcButton.setImage(UIImage(named:  "nfc"),for: .normal)
        nfcButton.imageView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
      //  nfcButton.imageView?.contentMode = .scaleToFill
//        nfcButton.setImage(UIImage(named: "nfc", in: nil,  with: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
        nfcButton.addTarget(self, action: #selector(startNFCScanningAction), for: .touchUpInside)
        addSubview(nfcButton)
        
    }
    
    func onlyBarcodeScannerFeautre(){
        scannerButton = UIButton(frame: CGRect(x: (bounds.width - 40.0) / 2.0, y: 0.0, width: 40.0, height: 40.0))
              scannerButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
              scannerButton.setImage(UIImage(named: "barcode_icon"), for: .normal)
              scannerButton.addTarget(self, action: #selector(startScanningAction), for: .touchUpInside)
        addSubview(scannerButton)
    }
    
    func onlyNfcScannerFeautre(){
        nfcButton = UIButton(frame: CGRect(x: (bounds.width - 40.0) / 2.0, y: 0.0, width: 40.0, height: 40.0))
        nfcButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        nfcButton.setImage(UIImage(named: "nfc"), for: .normal)
        nfcButton.imageView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
        nfcButton.addTarget(self, action: #selector(startNFCScanningAction), for: .touchUpInside)
        addSubview(nfcButton)
    }
    
    
    
    func setupUI() {
        contentView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        contentView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

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
