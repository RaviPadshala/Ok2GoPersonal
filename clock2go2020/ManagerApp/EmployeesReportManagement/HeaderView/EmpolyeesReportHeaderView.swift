//
//  EmpolyeesReportHeaderView.swift
//  clock2go2020
//
//  Created by Gleb on 16.09.2020.
//

import Foundation
import UIKit

class EmpolyeesReportHeaderView: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var cumulativeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var employeeLabel: UILabel!
    @IBOutlet weak var locationOutLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var locationInLabel: UILabel!
    @IBOutlet weak var logInLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
     // MARK: Override
       override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }

       private func commonInit() {
           Bundle.main.loadNibNamed("EmpolyeesReportHeaderView", owner: self, options: nil)
           addSubview(contentView)
           contentView.frame = self.bounds

        setLocalized()
       }

    func setLocalized() {
        cumulativeLabel.text = "REPORT_CUMULATIVE_TITLE".localized
        totalLabel.text = "REPORT_TOTAL_TITLE".localized
        locationOutLabel.text = "REPORT_EXIT_LOCATION_TITLE".localized
        logOutLabel.text = "REPORT_EXIT_TIME_TITLE".localized
        locationInLabel.text = "REPORT_ENTER_LOCATION_TITLE".localized
        logInLabel.text = "REPORT_ENTER_TIME_TITLE".localized
        taskLabel.text = "REPORT_TASK_TITLE".localized
        dateLabel.text = "REPORT_DATE_TITLE".localized
        employeeLabel.text = "NAME".localized
        selectLabel.text = "SELECT".localized

    }
}
