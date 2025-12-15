//
//  TaskFinishView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 04.01.2020.
//

import UIKit

class TaskFinishView: UIView {

    // MARK: Outlets
 @IBOutlet weak var endTaskView: EndTaskView!
    @IBOutlet weak var topFinishTaskView: TopFinishTaskView!
    @IBOutlet weak var backToTaskView: BackToTaskView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var commentTaskTextField: UITextField!
    @IBOutlet var contentView: UIView!

    // MARK: OVerride
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Property
    private func commonInit() {
        Bundle.main.loadNibNamed("TaskFinishView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setTextField()
    }
    func setupUI() {
        contentView.roundCorners([.allCorners], radius: 30.0)
        contentView.clipsToBounds = true

    }

    func setTextField() {
        commentTaskTextField.clipsToBounds = true
        commentTaskTextField.layer.cornerRadius = 30.0
        commentTaskTextField.layer.borderWidth = 2.0
        commentTaskTextField.layer.borderColor = #colorLiteral(red: 0.06274509804, green: 0.2823529412, blue: 0.462745098, alpha: 1)
        commentTaskTextField.placeholder = "הוסף הערה"
        commentTaskTextField.placeholderColor(color: #colorLiteral(red: 0.06274509804, green: 0.2823529412, blue: 0.462745098, alpha: 1))
        commentTaskTextField.font = .boldSystemFont(ofSize: 18.0)
        commentTaskTextField.addCloseToolbar()
    }
}
