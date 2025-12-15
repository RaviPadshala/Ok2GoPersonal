//
//  ChooseLanguageView.swift
//  clock2go2020
//
//  Created by Admin on 12/22/19.
//

import UIKit

class ChooseLanguageView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageImage: UIImageView!

    var changeLanguageTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ChooseLanguageView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setupTap()
    }

    func setupUI() {
        contentView.roundCorners([.allCorners], radius: 30.0)
        contentView.border(width: 1.0, color: #colorLiteral(red: 0.2758387029, green: 0.5907399058, blue: 0.82116431, alpha: 1))
    }

    func setupTap() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(changeLanguageTap))
        contentView.addGestureRecognizer(tap)
    }

    @objc func changeLanguageTap() {
        changeLanguageTapped?()
    }

}
