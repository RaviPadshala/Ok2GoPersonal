//
//  GuideView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 28.12.2019.
//

import UIKit

class GuideView: UIView {

    @IBOutlet weak var showGuideLabel: UILabel!

    var showGuideTapped: (() -> Void)?

    // MARK: Outlets
    @IBOutlet var contentView: UIView!

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
        Bundle.main.loadNibNamed("GuideView", owner: self, options: nil)
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
        showGuideLabel.text = "WATCH_GUIDE".localized
    }

    func setupTap() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showTaskListTap))
        contentView.addGestureRecognizer(tap)
    }

    @objc func showTaskListTap() {
        showGuideTapped?()

        let vc = ViewSource.guideVideoView()
        NavigationController.shared?.pushViewController(vc, animated: true)
    }
}
