//
//  AttachedFileCell.swift
//  clock2go2020
//
//  Created by Admin on 2/3/20.
//

import UIKit

class AttachedFileCell: UITableViewCell {

    // Cell's reuse identifier and Nib name.
    static let identifier = "AttachedFileCell"

    @IBOutlet weak var attachedFileName: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var attachIcon: UIImageView!

    var viewModel: AttachedFileCellViewModel?

    var removeAction: (() -> Void)?

    func config(viewModel: AttachedFileCellViewModel) {
        self.viewModel = viewModel

        attachedFileName.text = self.viewModel?.getFileName() ?? ""
        removeButton.isHidden = !(self.viewModel?.shouldShowRemoveButton() ?? true)
        attachIcon.isHidden = !(self.viewModel?.shouldShowAttachIcon() ?? true)
    }

    @IBAction func removeFileAction(_ sender: Any) {
        self.removeAction?()
    }

}
