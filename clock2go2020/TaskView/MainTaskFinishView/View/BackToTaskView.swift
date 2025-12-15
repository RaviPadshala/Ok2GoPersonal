//
//  BackToTaskView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 04.01.2020.
//

import UIKit

class BackToTaskView: UIView {

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
        Bundle.main.loadNibNamed("BackToTaskView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()

    }

    func setupUI() {
        contentView.roundCorners([.allCorners], radius: 30.0)
        contentView.clipsToBounds = true

    }

}
