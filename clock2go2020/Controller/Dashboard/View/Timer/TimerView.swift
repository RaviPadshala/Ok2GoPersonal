//
//  TimerView.swift
//  clock2go2020
//
//  Created by Admin on 1/22/20.
//

import UIKit

class TimerView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!

    let shapeLayer = CAShapeLayer()

    let bgShapeLayer = CAShapeLayer()
    let bgLineShapeLayer = CAShapeLayer()
    let borderShapeLayer = CAShapeLayer()

    let point = CAShapeLayer()

    var viewModel = TimerViewModel()

    var timer = Timer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("TimerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer), name: Notification.Name(rawValue: "CompanyIndexChanged"), object: nil)

        setupUI()
    }

    func setupUI() {
        drawBackgroundShape()
        setupTimerLabel()
        setupTimer()
    }

    func config(viewModel: TimerViewModel) {
        self.viewModel = viewModel
    }

    func drawBackgroundShape() {
        let bgPath = getCGPath(radius: 0)
        bgShapeLayer.setup(path: bgPath, color: #colorLiteral(red: 0.9231129289, green: 0.9492073655, blue: 0.9671584964, alpha: 1), fillColor: UIColor.clear.cgColor, width: 14)
        timerView.layer.addSublayer(bgShapeLayer)

        let bgLinePath = getCGPath(radius: 0)
        bgLineShapeLayer.setup(path: bgLinePath, color: #colorLiteral(red: 0.8461438417, green: 0.8631595969, blue: 0.9029210806, alpha: 1), fillColor: UIColor.clear.cgColor, width: 2)
        timerView.layer.addSublayer(bgLineShapeLayer)

        let borderPath = getCGPath(radius: 7.0)
        borderShapeLayer.setup(path: borderPath, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), fillColor: UIColor.clear.cgColor, width: 2.3)
        timerView.layer.addSublayer(borderShapeLayer)
    }

    func drawTimerShape() {
        let circularPath = getCGPath(radius: 0)

        shapeLayer.setup(path: circularPath, color: viewModel.getTimerColor(), fillColor: UIColor.clear.cgColor, width: 5.8)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = viewModel.getShapeStrokeEnd()

        timerView.layer.addSublayer(shapeLayer)
    }

    func drawStrokeEndPoint() {
        point.removeFromSuperlayer()

        let center = viewModel.getCenterForStrokeEndPoint(frame: contentView.frame)

        let pointPath = UIBezierPath(arcCenter: center,
                                    radius: 6,
                                    startAngle: -90.degreesToRadians,
                                    endAngle: 270.degreesToRadians,
                                    clockwise: true).cgPath

        point.setup(path: pointPath, color: UIColor.white.cgColor, fillColor: viewModel.getTimerColor(), width: 2)

        timerView.layer.addSublayer(point)
    }

    func getCGPath(radius: CGFloat) -> CGPath {
        return UIBezierPath(arcCenter: CGPoint(x: contentView.frame.midX, y: contentView.frame.midY),
                            radius: contentView.frame.width / 2.0 + radius,
                            startAngle: -90.degreesToRadians,
                            endAngle: 270.degreesToRadians,
                            clockwise: true).cgPath
    }

    func setupTimerLabel() {
        timerLabel.text = viewModel.getTimeLeftString()
    }

    func setupTimer() {
        viewModel = TimerViewModel()
        stopTimer()
        viewModel.setupTimer()
        drawTimerShape()
        drawStrokeEndPoint()
        setupTimerLabel()
        
        if viewModel.shouldUpdateTimer() {
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        } else {
            stopTimer()
        }
    }

    @objc func stopTimer() {
        timer.invalidate()
        timerLabel.text = viewModel.getTimeLeftString()
        // shapeLayer.removeFromSuperlayer()
    }

    @objc func updateTime() {
        self.viewModel.updateTimer()
        self.timerLabel.text = viewModel.getTimeLeftString()
        self.shapeLayer.strokeEnd = viewModel.getShapeStrokeEnd()
                                                                    
        drawStrokeEndPoint()
    }
}



extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * .pi / 180
    }
}

extension CAShapeLayer {
    func setup(path: CGPath, color: CGColor?, fillColor: CGColor?, width: CGFloat) {
        self.path = path
        self.strokeColor = color
        self.fillColor = fillColor
        self.lineWidth = width
    }
}
