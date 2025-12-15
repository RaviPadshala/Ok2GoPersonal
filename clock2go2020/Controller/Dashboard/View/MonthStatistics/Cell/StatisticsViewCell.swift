//
//  StatisticsViewCell.swift
//  clock2go2020
//
//  Created by Admin on 1/31/20.
//

import UIKit

class StatisticsViewCell: UICollectionViewCell {

    static var identifier: String = "StatisticsViewCell"

    @IBOutlet weak var missingTitle: UILabel!
    @IBOutlet weak var totalHoursTitle: UILabel!
    @IBOutlet weak var absencesTitle: UILabel!

    @IBOutlet weak var leftArrowImage: UIImageView!
    @IBOutlet weak var rightArrowImage: UIImageView!

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var missingLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var absencesLabel: UILabel!

    private var viewModel: StatistictCellViewModel?

    var backTapped: (() -> Void)?
    var forwardTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        setLocalizedStrings()
        setTaps()
    }

    func setLocalizedStrings() {
        missingTitle.text = "MISSING".localized
        totalHoursTitle.text = "TOTAL_HOURS".localized
        absencesTitle.text = "ABSENCES".localized
    }

    func setTaps() {
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftArrowTapped))
        leftArrowImage.isUserInteractionEnabled = true
        leftArrowImage.addGestureRecognizer(leftTap)

        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightArrowTapped))
        rightArrowImage.isUserInteractionEnabled = true
        rightArrowImage.addGestureRecognizer(rightTap)
    }

    @objc func leftArrowTapped() {
        backTapped?()
    }

    @objc func rightArrowTapped() {
        forwardTapped?()
    }

    func setLabels() {
        monthLabel.text = viewModel?.getMonthString() ?? "-"
        missingLabel.text = viewModel?.getMissesString() ?? "-"
        totalHoursLabel.text = viewModel?.getWorkingHoursString() ?? "-"
        absencesLabel.text = viewModel?.getVacationsString() ?? "-"

        leftArrowImage.isHidden = !(viewModel?.shouldShowLeftArrow() ?? false)
        rightArrowImage.isHidden = !(viewModel?.shouldShowRightArrow() ?? false)
    }

    func configure(viewModel: StatistictCellViewModel) {
        setLocalizedStrings()
        setLabels()
        self.viewModel = viewModel
    }

    override func prepareForReuse() {
        monthLabel.text = "-"
        missingLabel.text = "-"
        totalHoursLabel.text = "-"
        absencesLabel.text = "-"
    }

}
