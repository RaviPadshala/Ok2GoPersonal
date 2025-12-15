//
//  DayWorkScheduleHeaderView.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 05.08.2022.
//

import UIKit

class DayWorkScheduleHeaderView: UIView {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noteLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(with viewModel: DayWorkScheduleHeaderViewModel) {
        addressLabel.text = viewModel.addressString
        taskNameLabel.text = viewModel.taskNameString
        timeLabel.text = viewModel.timeString
        noteLable.text = viewModel.noteString
    }
}
