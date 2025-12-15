//
//  CommentListCellTableViewCell.swift
//  clock2go2020
//
//  Created by MacPro4 on 24.04.2021.
//

import UIKit

class CommentListCellTableViewCell: UITableViewCell {

    static let identifier  = "CommentListCellTableViewCell"

    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
