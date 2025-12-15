//
//  TrackingReportHeaderTableView.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/1/20.
//

import UIKit

class TrackingReportHeaderTableView: UIView {

    @IBOutlet weak var contentView: UIView!

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
        Bundle.main.loadNibNamed("TrackingReportHeaderTableView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

    }

}
