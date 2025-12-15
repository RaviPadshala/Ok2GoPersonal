//
//  CloseMonthReportView.swift
//  clock2go2020
//
//  Created by Gleb on 01.12.2020.
//

import UIKit

class CloseMonthReportView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("CloseMonthReportView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }

}
