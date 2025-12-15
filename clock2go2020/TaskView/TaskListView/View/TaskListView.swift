//
//  TaskListView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 03.01.2020.
//

import UIKit

class TaskListView: UIView {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var addTaskTextField: UITextField!

    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Propertu
    private func commonInit() {
        Bundle.main.loadNibNamed("TaskListView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setupTextField()
    }

    func setupUI() {
        contentView.roundCorners([.allCorners], radius: 30.0)
        contentView.clipsToBounds = true
        contentView.layer.borderColor = #colorLiteral(red: 0.2758387029, green: 0.5907399058, blue: 0.82116431, alpha: 1)
        contentView.layer.borderWidth = 1.0
    }

    func setupTextField() {
        addTaskTextField.addCloseToolbar()

        addTaskTextField.layer.masksToBounds = true
        addTaskTextField.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        addTaskTextField.borderStyle = .none
        addTaskTextField.layer.borderWidth = 2
        addTaskTextField.layer.cornerRadius = 15

    }

}
