//
//  ExtendedListCell.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 29.06.2022.
//

import UIKit

class ExtendedListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicatorView.roundCorners([.topLeft, .bottomLeft], radius: 7)
    }
    
    func fill(with viewModel: ExtendedListCellViewModel) {
        titleLabel.text = viewModel.titleString
    }
}
