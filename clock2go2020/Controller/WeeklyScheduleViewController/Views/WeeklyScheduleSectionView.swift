//
//  WeeklyScheduleSectionView.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 09.08.2022.
//

import UIKit

class WeeklyScheduleSectionView: UIView {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressLabelWidth.constant = UIScreen.main.bounds.width * 0.3
        dayLabelWidth.constant = 60.0
    }
    
    func fill(with viewModel: WeeklyScheduleSectionViewModel) {
        addressLabel.text = viewModel.addressString
        hoursLabel.text = viewModel.hoursString
        dayLabel.text = viewModel.dayString
        taskNameLabel.text = viewModel.taskNameString
        taskCodeLabel.text = viewModel.taskCodeString
    }
}
