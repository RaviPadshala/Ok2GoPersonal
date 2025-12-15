//
//  TaskListTableViewCell.swift
//  clock2go2020
//
//  Created by Admin on 1/13/20.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    // Cell's reuse identifier and Nib name.
    static let identifier = "TaskListTableViewCell"

    private var viewModel: TaskListItemViewModel!

    var expandedAction : (() -> Void)?

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var subtaskIndicatorView: UIView!
    @IBOutlet weak var subtaskButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupUI()
    }

    func setupUI() {
        subtaskIndicatorView.roundCorners([.topLeft, .bottomLeft], radius: 7)
    }

    func configure(viewModel: TaskListItemViewModel) {
        self.viewModel = viewModel

        taskTitle.text = viewModel.getTaskTitle()
        subtaskButton.isHidden = !viewModel.shouldHaveSubtaskButton()
        subtaskButton.setImage(viewModel.getExpandedIcon(), for: .normal)
        subtaskIndicatorView.isHidden = !viewModel.shouldHaveSubtaskIndicatorView()
        contentView.backgroundColor = viewModel.getBackgroundColor()
    }

    @IBAction func expandAction() {
        expandedAction?()
    }

}
