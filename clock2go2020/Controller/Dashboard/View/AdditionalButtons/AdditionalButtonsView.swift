//
//  AdditionalButtonsView.swift
//  clock2go2020
//
//  Created by Admin on 4/10/20.
//

import UIKit

enum AdditionalButtonsAction {
    case returnFromService(ReportActionType?)
    case exitFromService(ReportActionType?)
}

protocol AdditionalButtonsViewDelegate: AnyObject {
    func didMakeActionAdditional(_ actionType: AdditionalButtonsAction)
    func shouldUpdateTimer()
}

class AdditionalButtonsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var roundedTopView: UIView!
    @IBOutlet weak var roundedBottomView: UIView!

    @IBOutlet weak var button1: UILabel!
    @IBOutlet weak var button2: UILabel!
    @IBOutlet weak var button3: UILabel!
    @IBOutlet weak var button4: UILabel!

    var reportsChanged: (() -> Void)?

    var viewModel = AdditionalButtonsViewModel()
    
    weak var delegate: AdditionalButtonsViewDelegate?
    
    var tappedReturnFormService: (() -> Void)?
    var tappedExitFormService: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("AdditionalButtonsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupValues()
        setupUI()
        setupTaps()
    }

    func setupValues() {
        viewModel.loadButtons()
        viewModel.delegate = self

//        button1.text = viewModel.getButton1Title()?.localized
//        button2.text = viewModel.getButton2Title()?.localized
//        button3.text = viewModel.getButton3Title()?.localized
//        button4.text = viewModel.getButton4Title()?.localized

        button3.textColor = viewModel.getColorthirdButton()
        button4.textColor = viewModel.getColortFourthButton()

        roundedBottomView.isHidden = !viewModel.shouldShowSecondLayer()
        updateUI()
    }

    func setupUI() {
        roundedTopView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        roundedTopView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        roundedBottomView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        roundedBottomView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

    }
    func updateUI(){
        viewModel.shouldRefresh()
        button1.text = viewModel.button1String
        button2.text = viewModel.button2String
        button3.text = viewModel.button3String
        button4.text = viewModel.button4String
    }
    
    func changeSelectedTask(_ task: TaskObj?) {
        viewModel.selectedTask = task
    }

    func setupTaps() {
        let firstButtonTap = UITapGestureRecognizer(target: self, action: #selector(firstButtonTapped))
        button1.addGestureRecognizer(firstButtonTap)

        let secondButtonTap = UITapGestureRecognizer(target: self, action: #selector(secondButtonTapped))
        button2.addGestureRecognizer(secondButtonTap)

        let thirdButtonTap = UITapGestureRecognizer(target: self, action: #selector(thirdButtonTapped))
        button3.addGestureRecognizer(thirdButtonTap)

        let fourthButtonTap = UITapGestureRecognizer(target: self, action: #selector(fourthButtonTapped))
        button4.addGestureRecognizer(fourthButtonTap)
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

    @objc func firstButtonTapped() {
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            self.showNoInternetPopup()
            return
        }
        if CompaniesDataManager.shared.hasFormsServiceEntryFeature(), let arr = CompaniesDataManager.shared.getEnterServiceFormCount(), arr.count > 0{
            self.delegate?.didMakeActionAdditional(.returnFromService(.returnFromService))
        }else{
//            self.tappedReturnFormService?()
//            
            if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
                if DashboardViewController.isRecentNFCScan {
                    DashboardViewController.isRecentNFCScan = false
                    self.delegate?.shouldUpdateTimer()
                    self.viewModel.sendReport(type: 4)
                }else{
                    self.showErrorView( title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
                }
                return
            }else{
                viewModel.firstButtonTapped()
            }
            
        }
    }

    @objc func secondButtonTapped() {
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            self.showNoInternetPopup()
            return
        }
        if CompaniesDataManager.shared.hasFormsServiceExitFeature(), let arr = CompaniesDataManager.shared.getExitServiceFormCount(), arr.count > 0{
            self.delegate?.didMakeActionAdditional(.exitFromService(.exitFromService))
        }else{
//            self.tappedExitFormService?()
//            viewModel.secondButtonTapped()
            if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
                if DashboardViewController.isRecentNFCScan {
                    DashboardViewController.isRecentNFCScan = false
                    self.delegate?.shouldUpdateTimer()
                    self.viewModel.sendReport(type: 3)
                }else{
                    self.showErrorView( title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
                }
                return
            }else{
                viewModel.secondButtonTapped()
            }
        }
    }

    @objc func thirdButtonTapped() {
        viewModel.thirdButtonTapped()
    }

    @objc func fourthButtonTapped() {
        viewModel.fourthButtonTapped()
    }

    func showErrorView(title: String?, message: String?) {
        if (title ?? "").contains("-999") { return }
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: title, message: message)
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
}

extension AdditionalButtonsView: AdditionalButtonsViewModelDelegate {
    func shouldRefreshView() {
        reportsChanged?()
    }
}
