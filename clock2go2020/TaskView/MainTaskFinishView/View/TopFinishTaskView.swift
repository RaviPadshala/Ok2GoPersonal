//
//  TopFinishView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 04.01.2020.
//

import UIKit

class TopFinishTaskView: UIView {

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
        Bundle.main.loadNibNamed("TopFinishTaskView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()

    }

    func setupUI() {
        contentView.roundCorners([.allCorners], radius: 33.0)
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 7.3
        contentView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    }
}
