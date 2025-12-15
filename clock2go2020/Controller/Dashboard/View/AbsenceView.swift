//
//  AbsenceView.swift
//  clock2go2020
//
//  Created by Admin on 1/22/20.
//

import UIKit

class AbsenceView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var reasonTitle: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("AbsenceView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setLocalizedStrings()
        setupUI()
    }

    func setLocalizedStrings() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = Date()
        let result = formatter.string(from: date)

        let dateTitleString = "DATE".localized + " - " + result
        let dateTitleAttributedString = dateTitleString.getBolded(fontSize: 17, stringForBold: result)

        dateTitle.attributedText = dateTitleAttributedString

        var absenceTitle = ""
        if let absenceType = Int(CompaniesDataManager.shared.getLastAbcenseReport()?.actionType ?? ""),
            let absence = AbsenceTypeEntity.withIdentifier(absenceType) {
            absenceTitle = " - " + absence.absenceTitle
        }

        let reasonTitleString = "ABSCENCE_REASON".localized + absenceTitle
        let reasonTitleAttributedString = reasonTitleString.getBolded(fontSize: 20, stringForBold: absenceTitle)

        reasonTitle.attributedText = reasonTitleAttributedString
    }

    func setupUI() {
        roundView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
    }

}
