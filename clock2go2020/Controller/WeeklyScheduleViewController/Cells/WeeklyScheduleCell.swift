//
//  WeeklyScheduleCell.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 11.08.2022.
//

import UIKit

class WeeklyScheduleCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressLabelWidth.constant = UIScreen.main.bounds.width * 0.3
        dayLabelWidth.constant = 60.0
        selectionStyle = .none
    }
    
    func fill(with viewModel: WeeklyScheduleCellViewModel) {
        self.addressLabel.text = viewModel.addressString
        self.addressLabel.textColor = viewModel.textColor
//        self.timeLabel.text = viewModel.timeString
        self.timeLabel.textColor = viewModel.textColor
//        self.dayLabel.text = viewModel.dayString
        self.dayLabel.textColor = viewModel.textColor
        self.taskNameLabel.text = viewModel.taskNameString
        self.taskNameLabel.textColor = viewModel.textColor
        self.taskCodeLabel.text = viewModel.taskCodeString
        self.taskCodeLabel.textColor = viewModel.textColor
        
        let arr = viewModel.timeString.components(separatedBy: " ")
//        let dateStr = arr[0].changeDateFormat(from: "yyyy-MM-dd", to: "dd-MM-yyyy")
        let dateStr = arr[0]
        if dateStr.count == 0{
            self.timeLabel.text = "\(dateStr) \(arr[0])"
        }else{
            self.timeLabel.text = "\(dateStr) \(arr[1])"
        }
        
        
        let dayStr = arr[0].getWeekDayNumberFormat()
        self.dayLabel.text = "\(dayStr)"
    }
}
