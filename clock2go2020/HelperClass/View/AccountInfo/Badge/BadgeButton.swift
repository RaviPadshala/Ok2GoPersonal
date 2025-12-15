//
//  BadgeButton.swift
//  clock2go2020
//
//  Created by Admin on 3/13/20.
//

import UIKit

class BadgeButton: UIButton {

    var badgeLabel = UILabel()

    var badge: String! = "" {
        didSet {
            self.layoutSubviews()
        }
    }

    public var badgeBackgroundColor = #colorLiteral(red: 1, green: 0.3137254902, blue: 0.3137254902, alpha: 1) {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }

    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }

    public var badgeFont = UIFont.systemFont(ofSize: 9.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }

    override init(frame: CGRect) {
        // Initialize the UIView
        super.init(frame: frame)

        self.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.awakeFromNib()
    }

    override func awakeFromNib() {
        self.drawBadgeLayer()
    }

    var badgeLayer: CAShapeLayer!
    func drawBadgeLayer() {
        badgeLayer = CAShapeLayer()
        badgeLabel.removeFromSuperview()

        if Int(badge) == 0 || badge == "" {
            return
        }

        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size

        let height = max(15, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)

        let x = self.frame.width - CGFloat((width / 2.0)) - 3
        let y = CGFloat(-(height / 2.0)) + 2
        badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))

        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = badge != nil ? false : true

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawBadgeLayer()
        self.setNeedsDisplay()
    }

}
