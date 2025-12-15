//
//  SortingListTableViewCell.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/19/20.
//

import UIKit

class SortingListTableViewCell: UITableViewCell {

    // Cell's reuse identifier and Nib name.
    static let identifier = "SortingListTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
