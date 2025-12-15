//
//  DayWorkScheduleCell.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 04.08.2022.
//

import UIKit

class DayWorkScheduleCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noteLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func fill(with viewModel: DayWorkScheduleCellViewModel) {
        addressLabel.text = viewModel.addressString
        taskNameLabel.text = viewModel.taskNameString
        noteLable.text = viewModel.noteString
//        timeLabel.text = viewModel.timeString
        
        let arr = viewModel.timeString.split(separator: "-")
        timeLabel.text = "\(arr[1])-\(arr[0])"
    }
}
