//
//  SideBarTableViewCell.swift
//  we
//
//  Created by MacBookPro on 1/29/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import UIKit

class SideBarTableViewCell: UITableViewCell {

    static let identifier = "SideBarTableViewCell"

    @IBOutlet var imageCell: UIImageView!
    @IBOutlet var titleCell: UILabel!
    @IBOutlet var additionalView: UIView!

    var viewModel: SideBarCellViewModel!

    func removeAllSubviews() {
        for view in additionalView.subviews {
            view.removeFromSuperview()
        }
    }

    func configure(model: SideBarCellViewModel) {
       // viewModel = model

        imageCell.image = viewModel.getImage()
        titleCell.text = viewModel.getTitle()
        removeAllSubviews()
        if viewModel.getAdditionalView() != nil{
            if let view = viewModel.getAdditionalView() {
                
                additionalView.addSubview(view)
            }
        }
    }

}
