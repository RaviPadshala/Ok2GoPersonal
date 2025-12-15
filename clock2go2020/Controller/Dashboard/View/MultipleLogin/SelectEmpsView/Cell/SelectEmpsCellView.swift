//
//  SelectEmpsCellView.swift
//  clock2go2020
//
//  Created by Admin on 5/11/20.
//

import UIKit

class SelectEmpsCellView: UITableViewCell {

    static let identifier = "SelectEmpsCellView"

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var usersButton: UIButton!
    @IBOutlet var selectedButton: UIButton!

    var selectAction: (() -> Void)?
    var select = false

    func config(viewModel: SelectEmpsCellViewModel) {
        nameLabel.text = viewModel.getName()
        selectedButton.setImage(viewModel.getSelectImage(), for: .normal)

        usersButton.isHidden = !viewModel.shouldHaveUsersButton()
        usersButton.setImage(viewModel.getExpandedIcon(), for: .normal)
        contentView.backgroundColor = viewModel.getBackgroundColor()
    }

    @IBAction func selectButtonAction(_ sender: Any) {
        self.selectAction?()
    }

}
