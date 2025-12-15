//
//  EmployeesReportTableViewCell.swift
//  clock2go2020
//
//  Created by Gleb on 16.09.2020.
//

import UIKit
import AnyCodable

class EmployeesReportTableViewCell: UITableViewCell {

    static let identifier = "EmployeesReportTableViewCell"

    // MARK: Outlets
    @IBOutlet weak var childBackground: UIView!
    @IBOutlet weak var cumulativeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var employeeLabel: UILabel!
    @IBOutlet weak var locationOutLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var locationInLabel: UILabel!
    @IBOutlet weak var logInLabel: UILabel!
    @IBOutlet weak var logInStatus: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var logOutStatus: UIImageView!
    @IBOutlet weak var absenceStatus: UIImageView!

    // MARK: Property
    var viewModel: EmployeesReportTableViewCellViewModel!
    weak var delegate: EmployeesReportTableViewCellDelegate?
    var selectTapped: (() -> Void)?
    var employeeTapped: (() -> Void)?

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Public func
    func configure(viewModel: EmployeesReportTableViewCellViewModel) {
        self.viewModel = viewModel

        cumulativeLabel.text  = viewModel.getCummulativeTimeString()
        totalLabel.text       = viewModel.getTotalHours()
        let name  = viewModel.getEmpName()
        employeeLabel.attributedText = name.getUnderlined(color: #colorLiteral(red: 0.06274509804, green: 0.2823529412, blue: 0.462745098, alpha: 1), stringForUnderline: name)
        locationOutLabel.text = viewModel.getLocationEndString()
        logOutLabel.text      = viewModel.getEndTime()
        locationInLabel.text  = viewModel.getLocationStartString()
        logInLabel.text       = viewModel.getStartTime()
        taskLabel.text        = viewModel.getTaskName()
        dateLabel.text        = viewModel.getDate()

        expandButton.setImage(viewModel.getExpandedImage(), for: .normal)
        checkboxButton.setImage(viewModel.getSelectedImage(), for: .normal)

        logInStatus.image     = viewModel.getStartStatusIcon()
        logOutStatus.image    = viewModel.getEndStatusIcon()
        absenceStatus.image   = viewModel.getAbsenceStatusIcon()

        self.backgroundColor  = viewModel.getBackgroundColor()
        childBackground.backgroundColor = viewModel.getChildBackgroundColor()
        taskLabel.textColor = viewModel.getTaskTextColor()
        taskLabel.backgroundColor = viewModel.getTaskBackgroundColor()
        logOutLabel.backgroundColor = viewModel.getEndColor()
        logInLabel.backgroundColor = viewModel.getStartColor()

        setupTaps()
    }

    // MARK: Private func
    private func setupTaps() {
        // Add Tap for log and empName
        if viewModel.shouldEnableTapActions() {
        let employeeTapped = UITapGestureRecognizer(target: self, action: #selector(showEmployeeReports))
        employeeLabel.addGestureRecognizer(employeeTapped)

        let loginTapped = UITapGestureRecognizer(target: self, action: #selector(showLoginEditReportView))
        logInLabel.addGestureRecognizer(loginTapped)

        let logoutTapped = UITapGestureRecognizer(target: self, action: #selector(showLogoutEditorView))
        logOutLabel.addGestureRecognizer(logoutTapped)
            /// Set user iteraction
            logInLabel.isUserInteractionEnabled    = true
            logOutLabel.isUserInteractionEnabled   = true
            employeeLabel.isUserInteractionEnabled = true
        } else {
            logInLabel.isUserInteractionEnabled    = false
            logOutLabel.isUserInteractionEnabled   = false
            employeeLabel.isUserInteractionEnabled = false
        }

        // Add Tap for location
        if viewModel.shouldEnableTapActions(), viewModel.shouldEnableLocationTapAction() {
        let locationInTapped = UITapGestureRecognizer(target: self, action: #selector(showLocationIn))
        locationInLabel.addGestureRecognizer(locationInTapped)

        let locationOutTapped = UITapGestureRecognizer(target: self, action: #selector(showLocationOut))
        locationOutLabel.addGestureRecognizer(locationOutTapped)
              /// Set user iteraction
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

    private func showEditView(model: EditReportViewModel) {
        let vc = ViewSource.editReportView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = model

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    private func showMapView(model: MapControllerViewModel) {
        let vc = ViewSource.mapViewScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.configure(model: model)

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
    // MARK: Actions
    @objc func showLoginEditReportView() {
      if  viewModel.getReportIdIn() != 0 {
            let model = viewModel.getModelForLoginTap(reportIsEmptry: false )
          showEditView(model: model)
      } else {
        let model = viewModel.getModelForLoginTap(reportIsEmptry: true  )
        showEditView(model: model)
      }

    }

    @objc func showLogoutEditorView() {
        if  viewModel.getReportIdOut() != 0 {
        let model = viewModel.getModelForLogOutTap(reportIsEmptry: false )
        showEditView(model: model)
        } else {
            let model = viewModel.getModelForLogOutTap(reportIsEmptry: true  )
            showEditView(model: model)
          }
    }

    @objc func showLocationIn() {
        guard viewModel.shouldEnableTapActions(), let location = viewModel.getLocationStart() else { return }
        let locationTitle = viewModel.getLocationStartString()

        showMapView(model: MapControllerViewModel(locationTitle: locationTitle, location: location))
    }

    @objc func showLocationOut() {
        guard viewModel.shouldEnableTapActions(), let location = viewModel.getLocationEnd() else { return }

        let locationTitle = viewModel.getLocationEndString()

        showMapView(model: MapControllerViewModel(locationTitle: locationTitle, location: location))
    }

    @objc func showEmployeeReports() {
        self.employeeTapped?()
    }

    @objc func showAbcenseEditView() {
        let vc = ViewSource.absenceReportView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = viewModel.getModelForAbsenceTap()

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @IBAction func selectReportActions(_ sender: UIButton) {
        self.selectTapped?()
    }
}

// MARK: Protocol
protocol EmployeesReportTableViewCellDelegate: NSObjectProtocol {
    func didUpdateReports(_ reports: [String: AnyCodable])
}
