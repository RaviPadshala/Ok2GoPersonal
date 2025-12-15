//
//  BituachLeumiAdditionalView.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 19.08.2022.
//

import UIKit

enum BituachLeumiAdditionalAction {
    case absence
    case sampleReport(ReportActionType?)
    case serviceEntry(ReportActionType?)
    case serviceExit(ReportActionType?)
    case patientNotAtHome
}

protocol BituachLeumiAdditionalViewDelegate: AnyObject {
    func didMakeAction(_ actionType: BituachLeumiAdditionalAction)
}

class BituachLeumiAdditionalView: UIView {
    
    var viewModel = BituachLeumiAdditionalViewModel()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var absenceView: UIView!
    @IBOutlet weak var absenceLabel: UILabel!
    @IBOutlet weak var sampleReportView: UIView!
    @IBOutlet weak var sampleReportLabel: UILabel!
    @IBOutlet weak var serviceExitLabel: UILabel!
    @IBOutlet weak var serviceExitButton: UIButton!
    @IBOutlet weak var serviceEntryLabel: UILabel!
    @IBOutlet weak var serviceEntryButton: UIButton!
    @IBOutlet weak var patientNotAtHomeButton: UIButton!
    @IBOutlet weak var patientNotAtHomeLabel: UILabel!
    @IBOutlet weak var patientNotAtHomeButtonView: UIView!
    
    weak var delegate: BituachLeumiAdditionalViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("BituachLeumiAdditionalView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        setupUI()
    }
    
    func refreshView() {
        viewModel.shouldRefresh()
        updateUI()
    }
    
    private func setupUI() {
        topView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        topView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        bottomView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        bottomView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
                
        updateUI()
    }
    
    private func updateUI() {
        absenceLabel.text = viewModel.absenceString
        sampleReportLabel.text = viewModel.sampleReportString
        serviceExitLabel.text = viewModel.serviceExtitString
        serviceEntryLabel.text = viewModel.serviceEntryString

        serviceEntryLabel.textColor = viewModel.entryLabelColor
        serviceExitLabel.textColor = viewModel.exitLabelColor
        serviceEntryButton.isEnabled = viewModel.entryButtonEnabled
        serviceExitButton.isEnabled = viewModel.exitButtonEnabled
        
        if viewModel.showPatientNotAtHomeButton() {
            patientNotAtHomeButtonView.isHidden = false
            patientNotAtHomeLabel.text = viewModel.patientNotAtHomeString
            if viewModel.disablePatientNotAtHomeButton() {
                patientNotAtHomeButton.isEnabled = false
            }else {
                patientNotAtHomeButton.isEnabled = true
            }
        }else {
            patientNotAtHomeButtonView.isHidden = true
        }
    }
    
    @IBAction func patientNotAtHomeAction(_ sender: Any) {
        delegate?.didMakeAction(.patientNotAtHome)
    }
    
    @IBAction func absenceAction(_ sender: Any) {
        delegate?.didMakeAction(.absence)
    }
    
    @IBAction func sampleReportAction(_ sender: Any) {
        let actionType = ReportActionType(rawValue: "\(CompaniesDataManager.shared.getAddonButtons()?.button_3?.action_type ?? -1000)")
        delegate?.didMakeAction(.sampleReport(actionType))
    }
    
    @IBAction func serviceExitAction(_ sender: Any) {
//        let actionType = ReportActionType(rawValue: "\(CompaniesDataManager.shared.getAddonButtons()?.button_2?.action_type ?? -1000)")
        delegate?.didMakeAction(.serviceExit(.serviceExit))
    }
    
    @IBAction func serviceEntryAction(_ sender: Any) {
//        let actionType = ReportActionType(rawValue: "\(CompaniesDataManager.shared.getAddonButtons()?.button_1?.action_type ?? -1000)")
        delegate?.didMakeAction(.serviceEntry(.serviceEntry))
    }
}
