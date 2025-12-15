//
//  ReminderDaysViewCell.swift
//  clock2go2020
//
//  Created by Admin on 2/11/20.
//

import UIKit

enum SelectedDay : Int{
    case Sunday = 1
    case Monday = 2
    case TuesDay = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    case Allday = 8
}

class ReminderDaysViewCell: UITableViewCell {

    static var identifier: String = "ReminderDaysViewCell"

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayLabel: UILabel!

    var viewModel: ReminderDaysCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    func setupUI() {
        dayView.roundCorners([.allCorners], radius: 30)
    }

    func config(viewModel: ReminderDaysCellViewModel) {
        self.viewModel = viewModel

        dayLabel.text = self.viewModel?.getTitle()
        dayView.backgroundColor = self.viewModel?.getBackgroundColor()

        
//            dayView.alpha = 1
//            dayView.border(width: 3.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
//            dayLabel.font = UIFont(name: "OpenSansHebrew-Bold", size: 24)
//       
        
        if self.viewModel?.isDaySelected ?? false {
            dayView.alpha = 1
            dayView.border(width: 3.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            dayLabel.font = UIFont(name: "OpenSansHebrew-Bold", size: 24)
        } else {
            dayView.alpha = 0.5
            dayView.border(width: 1, color: #colorLiteral(red: 0.9829811454, green: 0.9831220508, blue: 0.9829503894, alpha: 1))
            dayLabel.font = UIFont(name: "OpenSansHebrew-Regular", size: 24)
        }

    }
}
