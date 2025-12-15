//
//  NotificationViewCell.swift
//  clock2go2020
//
//  Created by Admin on 2/10/20.
//

import UIKit

class NotificationViewCell: UICollectionViewCell {

    static var identifier: String = "NotificationViewCell"

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    var viewModel: NotificationCellViewModel!

    var selectedAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupUI()
        setupTap()

         roundedView.translatesAutoresizingMaskIntoConstraints = false
         roundedView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 25).isActive = true

        }

    func setupUI() {
        roundedView.roundCorners([.topRight, .bottomRight], radius: 9)
        roundedView.shadow(CGSize(width: 0, height: 4), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.3338113816, green: 0.3614248776, blue: 0.4015404281, alpha: 1))
    }

    func setupTap() {
        let selectTap = UITapGestureRecognizer(target: self, action: #selector(selectAction))
        selectView.addGestureRecognizer(selectTap)
    }

    @objc func selectAction() {
        selectedAction?()
    }

    func configure(model: NotificationCellViewModel) {
        self.viewModel = model

        dateLabel.text = viewModel.getDateLabel()
        timeLabel.text = viewModel.getTimeLabel()
        messageLabel.text = viewModel.getMessageLabel()

        if let color = viewModel.getBorderColor() {
            roundedView.border(width: 2, color: color.cgColor)
        }

        if let image = viewModel.getSelectButtonImage() {
            selectButton.setImage(image, for: .normal)
        }
    }

    @IBAction func selectedButtonAction(_ sender: Any) {
        selectedAction?()
    }

}
