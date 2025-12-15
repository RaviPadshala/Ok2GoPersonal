//
//  LoadingView.swift
//  clock2go2020
//
//  Created by Admin on 2/4/20.
//

import UIKit

class LoadingView: UIView {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
    }

}
