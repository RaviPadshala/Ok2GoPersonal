//
//  ReportManagementHeaderTableView.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/15/20.
//

import UIKit

class ReportManagementHeaderTableView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var cumulativeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var locationOutLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var locationInLabel: UILabel!
    @IBOutlet weak var logInLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var trnsTypeStackVIew: UIStackView!
    @IBOutlet weak var trnsTypeLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    var isRevacha: Bool {
        return CompaniesDataManager.shared.isRevacha()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ReportManagementHeaderTableView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setLocalized()
        trnsTypeStackVIew.isHidden = !isRevacha
    }

    func setLocalized() {
        cumulativeLabel.text  = "REPORT_CUMULATIVE_TITLE".localized
        totalLabel.text       = "REPORT_TOTAL_TITLE".localized
        locationOutLabel.text = "REPORT_EXIT_LOCATION_TITLE".localized
        logOutLabel.text      = "REPORT_EXIT_TIME_TITLE".localized
        locationInLabel.text  = "REPORT_ENTER_LOCATION_TITLE".localized
        logInLabel.text       = "REPORT_ENTER_TIME_TITLE".localized
        taskLabel.text        = DashboardViewModel().isRevacha ? "CLIENT".localized : "REPORT_TASK_TITLE".localized
        dateLabel.text        = "REPORT_DATE_TITLE".localized
        trnsTypeLabel.text    = "TRNS_TYPE".localized
        dayLabel.text = "D".localized
    }

}
