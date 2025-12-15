//
//  ContinueRegistrationView.swift
//  clock2go2020
//
//  Created by Admin on 12/22/19.
//

import UIKit

class ContinueRegistrationView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    var continueTapped: (() -> Void)?

    var isActive: Bool = true {
        didSet {
            if isActive {
               contentView.backgroundColor = #colorLiteral(red: 0.7417061925, green: 0.8273479342, blue: 0.9135255218, alpha: 1)
            } else {
               contentView.backgroundColor = #colorLiteral(red: 0.8478680253, green: 0.8907932639, blue: 0.9199658036, alpha: 1)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ContinueRegistrationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setLocalizedStrings()
        setupUI()
        setupTap()
    }

    func setLocalizedStrings() {
        titleLabel.text = "CONTINUE".localized
    }

    func setupUI() {
        contentView.roundCorners([.allCorners], radius: 30.0)
    }

    func setupTap() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(continueTap))
        contentView.addGestureRecognizer(tap)
    }

    @objc func continueTap() {
        continueTapped?()
    }

}
