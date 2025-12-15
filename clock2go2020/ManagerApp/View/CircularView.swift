//
//  CircularView.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/15/20.
//

import UIKit

@IBDesignable class circleView: UIView {

    weak var delegate: circleViewDelegate?

    typealias ArcAction = () -> Void

    struct ArcInfo {
        var outlinePath: UIBezierPath
        var action: ArcAction
    }

    private var arcInfos: [ArcInfo]!

    let bgShapeLayer = CAShapeLayer()

    var redRadius: Float?
    var greenRadius: Float?
    var blueRadius: Float?
    var grayRadius: Float?

    var selectedType: typeCircle? = .entry

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_ :)))
        addGestureRecognizer(recognizer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func draw(_ rect: CGRect) {

        let fullCircle = CGFloat.pi * 2
        let arcAngle = fullCircle * 1.5 / 6

        var lastArcAngle = CGFloat.pi / 4.0 + CGFloat.pi // -CGFloat.pi
        // background
        let backPath = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.height/2), radius: 55.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        #colorLiteral(red: 0.9931474328, green: 0.9932896495, blue: 0.9931163192, alpha: 1).setStroke()
        backPath.lineWidth = 2.3
        backPath.stroke()

        #colorLiteral(red: 0.9212146401, green: 0.9490351081, blue: 0.9671724439, alpha: 1).setFill()
        backPath.fill()

        arcInfos = []

        // Red Arc
        func redArc( action: @escaping ArcAction) {

            let path = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.height/2), radius: CGFloat(redRadius ?? 46), startAngle: lastArcAngle, endAngle: lastArcAngle + arcAngle, clockwise: true)

            #colorLiteral(red: 1, green: 0.3137254902, blue: 0.3137254902, alpha: 1).setStroke()
            path.lineWidth = 10
            path.stroke()
            lastArcAngle += arcAngle

            // separators
            #colorLiteral(red: 0.927436769, green: 0.9490308166, blue: 0.967099607, alpha: 1).setStroke()
            let outlinePath = hitTestPath(for: path)
            outlinePath.lineWidth = 3
            outlinePath.stroke()

            arcInfos.append(ArcInfo(outlinePath: outlinePath, action: action))
        }

        // Green Arc
        func greenArc( action: @escaping ArcAction) {

            let path = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.height/2), radius: CGFloat(greenRadius ?? 56), startAngle: lastArcAngle, endAngle: lastArcAngle + arcAngle, clockwise: true)

            #colorLiteral(red: 0.2443430722, green: 0.800511539, blue: 0.4006313086, alpha: 1).setStroke()
            path.lineWidth = 10
            path.stroke()
            lastArcAngle += arcAngle

            // separators
            #colorLiteral(red: 0.927436769, green: 0.9490308166, blue: 0.967099607, alpha: 1).setStroke()
            let outlinePath = hitTestPath(for: path)
            outlinePath.lineWidth = 3
            outlinePath.stroke()

            arcInfos.append(ArcInfo(outlinePath: outlinePath, action: action))
        }

        // Blue Arc
        func blueArc( action: @escaping ArcAction) {
            let path = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.height/2), radius: CGFloat(blueRadius ?? 46), startAngle: lastArcAngle, endAngle: lastArcAngle + arcAngle, clockwise: true)

            #colorLiteral(red: 0.1514689922, green: 0.4388672411, blue: 0.7514092326, alpha: 1).setStroke()
            path.lineWidth = 10
            path.stroke()
            lastArcAngle += arcAngle

            // separators
            #colorLiteral(red: 0.927436769, green: 0.9490308166, blue: 0.967099607, alpha: 1).setStroke()
            let outlinePath = hitTestPath(for: path)
            outlinePath.lineWidth = 3
            outlinePath.stroke()

            arcInfos.append(ArcInfo(outlinePath: outlinePath, action: action))
        }
        // Gray Arc
        func grayArc( action: @escaping ArcAction) {
            let path = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.height/2), radius: CGFloat(grayRadius ?? 46), startAngle: lastArcAngle, endAngle: lastArcAngle + arcAngle, clockwise: true)

            #colorLiteral(red: 0.6731665134, green: 0.6732652783, blue: 0.673144877, alpha: 1).setStroke()
            path.lineWidth = 10
            path.stroke()
            lastArcAngle += arcAngle

            // separators
            #colorLiteral(red: 0.927436769, green: 0.9490308166, blue: 0.967099607, alpha: 1).setStroke()
            let outlinePath = hitTestPath(for: path)
            outlinePath.lineWidth = 3
            outlinePath.stroke()

            arcInfos.append(ArcInfo(outlinePath: outlinePath, action: action))
        }

        // Add Arc
        greenArc {
            self.redRadius = 46
            self.greenRadius = 56
            self.blueRadius = 46
            self.grayRadius = 46

            if self.selectedType == .entry {
                self.selectedType = nil
                self.greenRadius = 46
            } else {
                self.selectedType = .entry
            }

            self.delegate?.selectedType(self.selectedType)
        }

        redArc {
            self.redRadius = 56
            self.greenRadius = 46
            self.blueRadius = 46
            self.grayRadius = 46

            if self.selectedType == .miss {
                self.selectedType = nil
                self.redRadius = 46
            } else {
                self.selectedType = .miss
            }

            self.delegate?.selectedType(self.selectedType)
        }

        blueArc {
            self.blueRadius = 56
            self.redRadius = 46
            self.greenRadius = 46
            self.grayRadius = 46

            if self.selectedType == .full {
                self.selectedType = nil
                self.blueRadius = 46
            } else {
                self.selectedType = .full
            }

            self.delegate?.selectedType(self.selectedType)
        }

        grayArc {
            self.grayRadius = 56
            self.blueRadius = 46
            self.redRadius = 46
            self.greenRadius = 46

            if self.selectedType == typeCircle.none {
                self.selectedType = nil
                 self.grayRadius = 46
            } else {
                self.selectedType = typeCircle.none
            }

            self.delegate?.selectedType(self.selectedType)
        }

    }

    @objc func tap(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self)

        if let hitPath = (arcInfos.first { $0.outlinePath.contains(location) }) {
            hitPath.action()
            setNeedsDisplay()
            // print(hitPath)
        }
    }

    func hitTestPath(for path: UIBezierPath) -> UIBezierPath {
        let pathCopy = path.cgPath.copy(strokingWithWidth: 15, lineCap: .butt, lineJoin: .miter, miterLimit: 0)
        return UIBezierPath(cgPath: pathCopy)
    }
}

protocol circleViewDelegate: NSObjectProtocol {
    func selectedType(_ type: typeCircle?)
}
