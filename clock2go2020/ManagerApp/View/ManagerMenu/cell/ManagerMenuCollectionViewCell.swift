//
//  ManagerMenuCollectionViewCell.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/9/20.
//

import UIKit

class ManagerMenuCollectionViewCell: UICollectionViewCell {

    static var identifier: String = "ManagerMenuCollectionViewCell"

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.isUserInteractionEnabled = true
    }

}
