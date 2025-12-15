//
//  SDR_DataCell.swift
//  clock2go2020
//
//  Created by Mac on 17/10/24.
//

import UIKit

class SDR_DataCellRTL: UITableViewCell {

    @IBOutlet weak var lbl_number: UILabel!
    @IBOutlet weak var lbl_studentName: UILabel!
    
    @IBOutlet weak var btn_yes: UIButton!
    @IBOutlet weak var lbl_yes: UILabel!
    @IBOutlet weak var img_yes: UIImageView!
    @IBOutlet weak var btn_no: UIButton!
    @IBOutlet weak var lbl_no: UILabel!
    @IBOutlet weak var img_no: UIImageView!
    
    @IBOutlet weak var btn_entryTime: UIButton!
    
    @IBOutlet weak var btn_green: UIButton!
    @IBOutlet weak var img_green: UIImageView!
    @IBOutlet weak var btn_yellow: UIButton!
    @IBOutlet weak var img_yellow: UIImageView!
    @IBOutlet weak var btn_red: UIButton!
    @IBOutlet weak var img_red: UIImageView!
    
    @IBOutlet weak var txt_notes: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.img_green.RoundCornerRadius()
        self.img_yellow.RoundCornerRadius()
        self.img_red.RoundCornerRadius()
        self.setString()
    }
    
    func setString(){
        self.lbl_no.text = "NO".localized
        self.lbl_yes.text = "YES".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
