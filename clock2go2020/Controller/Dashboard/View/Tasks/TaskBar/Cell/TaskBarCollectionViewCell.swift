//
//  TaskBarCollectionViewCell.swift
//  clock2go2020
//
//  Created by Admin on 1/4/20.
//

import UIKit

class TaskBarCollectionViewCell: UICollectionViewCell {

    static var identifier: String = "TaskBarCollectionViewCell"

    private var viewModel: TaskBarItemViewModel!

    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var taskLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        // Setup cell.
        taskView.roundCorners([.allCorners], radius: 20)
        taskView.shadow(.zero, opacity: 0.3, radius: 3, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        taskView.border(width: 2.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }

    func configure(viewModel: TaskBarItemViewModel) {
        self.viewModel = viewModel

        taskLabel.text = viewModel.getTaskDateString()
        taskView.backgroundColor = viewModel.getBackgroundColor()
    }

}
