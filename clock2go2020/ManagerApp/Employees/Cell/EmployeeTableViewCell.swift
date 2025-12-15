//
//  EmployeesTableViewCell.swift
//  clock2go2020
//
//  Created by Admin on 4/11/20.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    static let identifier = "EmployeeTableViewCell"

    @IBOutlet weak var absencesTitle: UILabel!
    @IBOutlet weak var workingHoursTitle: UILabel!

    @IBOutlet weak var absencesLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeStatusView: UIView!

    var viewModel: EmployeeCellViewModel!
    var editTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
        setupTap()
    }

    func setupUI() {
        employeeStatusView.roundCorners([.bottomLeft, .topLeft], radius: 13.0)

        workingHoursTitle.text =  "TOTAL_HOURS".localized
        absencesTitle.text =  "ABSENCES".localized
    }

    func setupTap() {
            let editTap = UITapGestureRecognizer(target: self, action: #selector(showEditView))
            employeeNameLabel.addGestureRecognizer(editTap)
    }

    @objc func showEditView() {
        editTapped?()
    }

    func configure(model: EmployeeCellViewModel) {
        viewModel = model

        absencesLabel.text = viewModel.getEmployeeAbsences()
        workingHoursLabel.text = viewModel.getEmployeeWorkingHours()
        employeeNameLabel.text = viewModel.getEmployeeName()

        employeeStatusView.backgroundColor = viewModel.getEmployeeStatusColor()
    }

}
