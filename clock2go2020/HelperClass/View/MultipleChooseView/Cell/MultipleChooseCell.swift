//
//  MultipleChooseCell.swift
//  clock2go2020
//
//  Created by Admin on 4/14/20.
//

import UIKit

class MultipleChooseCell: UITableViewCell {

    static let identifier = "MultipleChooseCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!

    var viewModel: MultipleChooseCellViewModel!

    func configure(model: MultipleChooseCellViewModel) {
        viewModel = model

        titleLabel.text = viewModel.getTitle()
        if let image = viewModel.getSelectButtonImage() {
            selectedButton.setImage(image, for: .normal)
        }
    }
}
