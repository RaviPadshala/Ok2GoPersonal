//
//  LanguageListCellTableViewCell.swift
//  clock2go2020
//
//  Created by Admin on 12/23/19.
//

import UIKit

class LanguageListCellTableViewCell: UITableViewCell {

    // Cell's reuse identifier and Nib name.
    static let identifier = "LanguageListCellTableViewCell"

    // MARK: - Outlets
    @IBOutlet weak var languageImage: UIImageView!
    @IBOutlet weak var languageTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
