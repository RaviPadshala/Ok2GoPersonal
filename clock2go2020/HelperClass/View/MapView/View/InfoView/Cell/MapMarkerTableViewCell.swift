//
//  MapMarkerTableViewCell.swift
//  ok2go_Map
//
//  Created by MacBookPro on 2/12/20.
//

import UIKit

class MapMarkerTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet var imageCell: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
