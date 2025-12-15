//
//  ReminderTimeViewCell.swift
//  clock2go2020
//
//  Created by Admin on 2/11/20.
//

import UIKit

class ReminderTimeViewCell: UITableViewCell {

    static var identifier: String = "ReminderTimeViewCell"

    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerSwitch: UISwitch!
    
    @IBOutlet weak var messageLogoutTitle: UILabel!
    @IBOutlet weak var timerLogoutView: UIView!
    @IBOutlet weak var timerLogoutLabel: UILabel!
    @IBOutlet weak var timerLogoutSwitch: UISwitch!

    var viewModel: ReminderTimeCellViewModel?
    var switchValueChanged: ((_ reminder: ReminderObj) -> Void)?
    var switchValueChangedLogout: ((_ reminder: ReminderObj) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
        setupTap()
    }

    func setupUI() {
        timerView.roundCorners([.allCorners], radius: 30)
        timerView.border(width: 2, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        timerLogoutView.roundCorners([.allCorners], radius: 30)
        timerLogoutView.border(width: 2, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    func config(viewModel: ReminderTimeCellViewModel) {
        self.viewModel = viewModel

        timerLabel.text = self.viewModel?.getTimeString()
        messageTitle.text = self.viewModel?.getMessageTitle()
        timerSwitch.isOn = self.viewModel?.getSwitchedMode() ?? false
        
        
        timerLogoutLabel.text = self.viewModel?.getLogoutTimeString()
        messageLogoutTitle.text = self.viewModel?.getMessageLogoutTitle()
        timerLogoutSwitch.isOn = self.viewModel?.getLogoutSwitchedMode() ?? false
        
        

        if self.viewModel?.getSwitchedMode() ?? false {
            timerView.alpha = 1
            timerView.border(width: 3.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            timerLabel.font = UIFont(name: "OpenSansHebrew-Bold", size: 24)
        } else {
            timerView.alpha = 0.5
            timerView.border(width: 1, color: #colorLiteral(red: 0.9829811454, green: 0.9831220508, blue: 0.9829503894, alpha: 1))
            timerLabel.font = UIFont(name: "OpenSansHebrew-Regular", size: 24)
        }
        
        if self.viewModel?.getLogoutSwitchedMode() ?? false {
            timerLogoutView.alpha = 1
            timerLogoutView.border(width: 3.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            timerLogoutLabel.font = UIFont(name: "OpenSansHebrew-Bold", size: 24)
        } else {
            timerLogoutView.alpha = 0.5
            timerLogoutView.border(width: 1, color: #colorLiteral(red: 0.9829811454, green: 0.9831220508, blue: 0.9829503894, alpha: 1))
            timerLogoutLabel.font = UIFont(name: "OpenSansHebrew-Regular", size: 24)
        }
    }

    func setupTap() {
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(showTimePicker))
        timerView.addGestureRecognizer(timeTap)

        timerSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        
        let timeLogoutTap = UITapGestureRecognizer(target: self, action: #selector(showTimePickerLogout))
        timerLogoutView.addGestureRecognizer(timeLogoutTap)

        timerLogoutSwitch.addTarget(self, action: #selector(switchChangedLogout), for: UIControl.Event.valueChanged)
    }

    @objc func showTimePicker() {
        let vc = ViewSource.datePickerView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.config(isDate: false, maxDate: nil)
        vc.selectedValue = { value in
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            if value != nil {
                let timeString = formatter.string(from: value!)
                self.timerLabel.text = timeString
                print("----", ReminderObj(time: timeString, isOn: true,timeLogout: self.timerLogoutLabel.text ?? "", isOnLogout: self.timerLogoutSwitch.isOn))
                self.switchValueChanged?(ReminderObj(time: timeString, isOn: true,timeLogout: self.timerLogoutLabel.text ?? "", isOnLogout: self.timerLogoutSwitch.isOn))
            } else {
                self.timerSwitch.isOn = self.viewModel?.getSwitchedMode() ?? false
            }
        }
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @objc func switchChanged(timerSwitch: UISwitch) {
        print("switch - " + "\(timerSwitch.isOn)")
        if timerSwitch.isOn {
            showTimePicker()
        } else {
            switchValueChanged?(ReminderObj(time: self.timerLabel.text ?? "", isOn: self.timerSwitch.isOn,timeLogout: self.timerLogoutLabel.text ?? "", isOnLogout: self.timerLogoutSwitch.isOn))
        }
    }
    
    @objc func showTimePickerLogout() {
        let vc = ViewSource.datePickerView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.config(isDate: false, maxDate: nil)
        vc.selectedValue = { value in
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            if value != nil {
                let timeString = formatter.string(from: value!)
                self.timerLogoutLabel.text = timeString

                self.switchValueChangedLogout?(ReminderObj(time: self.timerLabel.text ?? "", isOn: self.timerSwitch.isOn,timeLogout: timeString, isOnLogout: true ))
            } else {
                self.timerLogoutSwitch.isOn = self.viewModel?.getLogoutSwitchedMode() ?? false
            }
        }
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @objc func switchChangedLogout(timerSwitch: UISwitch) {
        print("switch - " + "\(timerSwitch.isOn)")
        if timerSwitch.isOn {
            showTimePickerLogout()
        } else {
            switchValueChangedLogout?(ReminderObj(time: self.timerLabel.text ?? "", isOn: self.timerSwitch.isOn,timeLogout: self.timerLogoutLabel.text ?? "", isOnLogout: self.timerLogoutSwitch.isOn))
        }
    }

}
