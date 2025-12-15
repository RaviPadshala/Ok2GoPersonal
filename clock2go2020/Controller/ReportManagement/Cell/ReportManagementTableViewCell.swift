//
//  ReportManagementTableViewCell.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/15/20.
//

import UIKit

class ReportManagementTableViewCell: UITableViewCell {
  
    

    // MARK: Outlet
    @IBOutlet weak var childBackground: UIView!

    @IBOutlet weak var cumulativeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var locationOutLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var logOutStatus: UIImageView!
    @IBOutlet weak var locationInLabel: UILabel!
    @IBOutlet weak var logInLabel: UILabel!
    @IBOutlet weak var logInStatus: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var absenceStatus: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var healthImage: UIImageView!
    @IBOutlet weak var trnsTypeLabel: UILabel!
    @IBOutlet weak var taskLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!

    // MARK: Property
    var viewModel: ReportManagementCellViewModel!
    weak var delegate: ReportManagementTableViewCellDelegate?

    // MARK: Overried
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(viewModel: ReportManagementCellViewModel) {
        self.viewModel = viewModel

        dateLabel.text = viewModel.getDate()
        dayLabel.text = viewModel.getDayWithFirstCharacter()
        healthImage.image = viewModel.getHealthImage()

        taskLabel.text = viewModel.getTaskName()
        taskLabel.textColor = viewModel.getTaskTextColor()
        taskLabel.backgroundColor = viewModel.getTaskBackgroundColor()

        logInLabel.text = viewModel.getStartTime()
        locationInLabel.text = viewModel.getLocationStartString()

        logOutLabel.text = viewModel.getEndTime()
        locationOutLabel.text = viewModel.getLocationEndString()

        totalLabel.text = viewModel.getTotalHours()
        cumulativeLabel.text = viewModel.getCummulativeTimeString()

        expandButton.setImage(viewModel.getExpandedImage(), for: .normal)
        self.backgroundColor = viewModel.getBackgroundColor()
        childBackground.backgroundColor = viewModel.getChildBackgroundColor()

        logOutLabel.backgroundColor = viewModel.getEndColor()
        logInLabel.backgroundColor = viewModel.getStartColor()

        logInStatus.image = viewModel.getStartStatusIcon()
        logOutStatus.image = viewModel.getEndStatusIcon()
        absenceStatus.image = viewModel.getAbsenceStatusIcon()
    
        trnsTypeLabel.isHidden = !viewModel.isRevacha
        trnsTypeLabel.text = viewModel.getTrnsType()
       
        
        setupTap()
        
    }

    func setupTap() {
       
        if viewModel.shouldEnableTapActions() {
            if viewModel.getStartTime() != "--:--" {
                let loginTap = UITapGestureRecognizer(target: self, action: #selector(showLoginEditReportView))
                logInLabel.addGestureRecognizer(loginTap)
                logInLabel.isUserInteractionEnabled = true
            }else{
                if viewModel.shouldEnableLoginTapActions()  {
                    let loginTap = UITapGestureRecognizer(target: self, action: #selector(showLoginEditReportView))
                    logInLabel.addGestureRecognizer(loginTap)
                    logInLabel.isUserInteractionEnabled = true
                }else{
                    logInLabel.isUserInteractionEnabled = false
                }
            }
            
            if viewModel.getEndTime() != "--:--" {
                let logoutTap = UITapGestureRecognizer(target: self, action: #selector(showLogOutEditReportView))
                logOutLabel.addGestureRecognizer(logoutTap)

               
                logOutLabel.isUserInteractionEnabled = true
            }else{
                if viewModel.shouldEnableLogoutTapActions()  {
                    let logoutTap = UITapGestureRecognizer(target: self, action: #selector(showLogOutEditReportView))
                    logOutLabel.addGestureRecognizer(logoutTap)
                    logOutLabel.isUserInteractionEnabled = true
                }else{
                    logOutLabel.isUserInteractionEnabled = false
                    
                }
            }
        } else {
            if viewModel.shouldEnableLoginTapActions()  {
                let loginTap = UITapGestureRecognizer(target: self, action: #selector(showLoginEditReportView))
                logInLabel.addGestureRecognizer(loginTap)
                logInLabel.isUserInteractionEnabled = true
            }else{
                logInLabel.isUserInteractionEnabled = false
                
            }
            if viewModel.shouldEnableLogoutTapActions()  {
                let logoutTap = UITapGestureRecognizer(target: self, action: #selector(showLogOutEditReportView))
                logOutLabel.addGestureRecognizer(logoutTap)
                logOutLabel.isUserInteractionEnabled = true
            }else{
                logOutLabel.isUserInteractionEnabled = false
                
                
            }
            
        }

        if viewModel.shouldEnableTapActions(), viewModel.shouldEnableLocationTapAction() {
            let loginLocationTap = UITapGestureRecognizer(target: self, action: #selector(showLoginLocation))
            locationInLabel.addGestureRecognizer(loginLocationTap)

            let logoutLocationTap = UITapGestureRecognizer(target: self, action: #selector(showLogoutLocation))
            locationOutLabel.addGestureRecognizer(logoutLocationTap)

            locationInLabel.isUserInteractionEnabled = true
            locationOutLabel.isUserInteractionEnabled = true
        } else {
            locationInLabel.isUserInteractionEnabled = false
            locationOutLabel.isUserInteractionEnabled = false
        }

        if viewModel.shouldEnableAbsenceTapAction() {
            let absenceTap = UITapGestureRecognizer(target: self, action: #selector(showAbcenseEditView))
            taskLabel.addGestureRecognizer(absenceTap)

            taskLabel.isUserInteractionEnabled = true
        } else {
            taskLabel.isUserInteractionEnabled = false
        }

    }

    @objc func showLoginEditReportView() {
        let model = viewModel.getModelForLoginTap()
        showEditView(model: model)
    }

    @objc func showLogOutEditReportView() {
        let model = viewModel.getModelForLogoutTap()
        showEditView(model: model)
    }

    func showEditView(model: EditReportViewModel) {
        let vc = ViewSource.editReportView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.viewModel = model
        vc.updateReports = { reports in
            self.delegate?.didUpdateReports(reports)
        }
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @objc func showAbcenseEditView() {
        let vc = ViewSource.absenceReportView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = viewModel.getModelForAbsenceTap()
        vc.updateReports = { reports in
            self.delegate?.didUpdateReports(reports)
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @objc func showLoginLocation() {
        guard viewModel.shouldEnableTapActions(), let location = viewModel.getLocationStart() else { return }

        let locationTitle = viewModel.getLocationStartString()

        showMapView(model: MapControllerViewModel(locationTitle: locationTitle, location: location))

    }

    @objc func showLogoutLocation() {
        guard viewModel.shouldEnableTapActions(), let location = viewModel.getLocationEnd() else { return }

        let locationTitle = viewModel.getLocationEndString()

        showMapView(model: MapControllerViewModel(locationTitle: locationTitle, location: location))
    }

    func showMapView(model: MapControllerViewModel) {
        let vc = ViewSource.mapViewScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.configure(model: model)

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

}

protocol ReportManagementTableViewCellDelegate: NSObjectProtocol {
    func didUpdateReports(_ reports: [String: EmpDayReportsObj]?)
}

extension ReportManagementTableViewCell: EditReportViewDelegate {
    func updateReportsDidChanged(_ empReports: [String : EmpDayReportsObj]?) {
        self.delegate?.didUpdateReports(empReports)
    }
}
