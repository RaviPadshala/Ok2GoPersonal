//
//  SDR_HeaderCell.swift
//  clock2go2020
//
//  Created by Mac on 17/10/24.
//

import UIKit

class SDR_HeaderCell: UITableViewCell {
    
    @IBOutlet weak var lbl_no: UILabel!
    @IBOutlet weak var lbl_studentName: UILabel!
    @IBOutlet weak var lbl_attendanceConfirmation: UILabel!
    @IBOutlet weak var lbl_enteryTime: UILabel!
    @IBOutlet weak var lbl_trafficLight: UILabel!
    @IBOutlet weak var lbl_notes: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitle()
    }
    
    func setTitle(){
        self.lbl_studentName.text = "STUDENT_NAME_TITLE".localized
        self.lbl_attendanceConfirmation.text = "ATTENDANCE_CONFIRMATION_TITLE".localized
        self.lbl_enteryTime.text = "ENTRY_TIME_TITLE".localized
        self.lbl_trafficLight.text = "TRAFFIC_LIGHT_SCORE_TITLE".localized
        self.lbl_notes.text = "NOTES_TITLE".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
