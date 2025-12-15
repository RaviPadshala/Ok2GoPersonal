//
//  SkipView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 29.12.2019.
//

import UIKit

class SkipView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var skipTitle: UILabel!

    var skipTapped: (() -> Void)?

    // MARK: Override
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
        Bundle.main.loadNibNamed("SkipView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setLocalizedStrings()
        setupTap()
    }

    func setupUI() {
        contentView.roundCorners([.allCorners], radius: 30.0)
        contentView.clipsToBounds = true
    }

    func setLocalizedStrings() {
        skipTitle.text = "SKIP".localized
    }

    func setupTap() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(skipTap))
        contentView.addGestureRecognizer(tap)
    }

    @objc func skipTap() {
        skipTapped?()
    }
}
