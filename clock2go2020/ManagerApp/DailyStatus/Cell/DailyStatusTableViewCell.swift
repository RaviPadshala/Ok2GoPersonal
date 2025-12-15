//
//  DailyStatusTableViewCell.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/10/20.
//

import UIKit

class DailyStatusTableViewCell: UITableViewCell {

    static var identifier = "DailyStatusTableViewCell"

    // MARK: Outlet
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var logOutIconView: UIView!

    @IBOutlet weak var logInLabel: UILabel!
    @IBOutlet weak var logInIconView: UIView!

    @IBOutlet weak var workerNameLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!

    // Property
   var viewModel: DailyStatsDetailsCellViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupUI()

    }

    func setupUI() {
        logOutIconView.roundCorners(.allCorners, radius: 2.7)
        logInIconView.roundCorners(.allCorners, radius: 2.7)
        roundedView.roundCorners([.topLeft, .bottomLeft], radius: 5)
    }

    func configure(model: DailyStatsDetailsCellViewModel) {
        viewModel = model
        logInLabel.text = viewModel.getDailyStatsDetailsLogInTime()
        logOutLabel.text = viewModel.getDailyStatsDetailsLogOutTime()
        workerNameLabel.text = viewModel.getDailyStatsDetailsEmpName()
        roundedView.backgroundColor = viewModel.getIconColorByStatus()
    }

}
