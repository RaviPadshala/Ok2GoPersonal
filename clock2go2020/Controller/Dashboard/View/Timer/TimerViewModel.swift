//
//  TimerViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/22/20.
//

import UIKit

enum TimerMode: Int {
    case login
    case pause
    case stop

    func getTimeInterval() -> TimeInterval {
        switch self {
            case .login, .stop:
                return 60 * 60 * 12 // 12 hours
            case .pause:
                return 60 * 60 * 1 // 1 hour
        }
    }

    func getTimerColor() -> CGColor {
        switch self {
            case .login, .stop:
                return #colorLiteral(red: 0.9619900584, green: 0.3149540126, blue: 0.3148945868, alpha: 1)
            case .pause:
                return #colorLiteral(red: 0.9680743814, green: 0.4295662642, blue: 0.8037929535, alpha: 1)
        }
    }
}

class TimerViewModel {

    var mode: TimerMode = .stop
    var timerTime: TimeInterval
    var timeLeft: TimeInterval
    var savedTimeLeft: TimeInterval
    var startTime: Date?

    var shapeStrokeEnd: CGFloat = 0

    init() {
        self.timerTime = 0
        self.savedTimeLeft = 0
        self.timeLeft = 0

        self.timeLeft = self.getTimeLeft()
        self.mode = self.getTimerMode()
        self.timerTime = mode.getTimeInterval()
    }

    func getTimerMode() -> TimerMode {
        var timerMode: TimerMode = .stop

        if CompaniesDataManager.shared.getLastLoginReport() != nil {
            timerMode = .login
        }

        if CompaniesDataManager.shared.getLastBreakReport() != nil {
            timerMode = .pause
        }
        
//        print("TIMER MODE: \(timerMode)")
        
        return timerMode
    }

    func getTimerColor() -> CGColor? {
        return mode.getTimerColor()
    }

    func setStartTime() {
        switch mode {
            case .login, .stop:
                    startTime = Date().addingTimeInterval(TimeInterval(0 - timeLeft))
            case .pause:
                    startTime = Date().addingTimeInterval(TimeInterval(0 - timeLeft))
        }
    }

    func getStartTime() -> Date {
        if startTime != nil {
            return startTime ?? Date()
        }

        setStartTime()

        return startTime ?? Date()
    }

    func setTimeLeft() {
        switch mode {
            case .stop, .login:
                let seconds = CompaniesDataManager.shared.getTodayWorkingTime()
                timeLeft = TimeInterval(seconds)
            case .pause:
                let seconds = CompaniesDataManager.shared.getActiveBreakTime()
                timeLeft = TimeInterval(seconds)
        }
    }

    func updateTimeLeft() {
        let start = getStartTime()
        let currentDate = getCurrentDate()
        timeLeft = currentDate.timeIntervalSince(start) + savedTimeLeft

        switch mode {
            case .stop, .login:
                CompaniesDataManager.shared.setTodayWorkingTime(Int(timeLeft))
            case .pause:
                CompaniesDataManager.shared.setActiveBreakTime(Int(timeLeft))
        }
    }

    func getTimeLeft() -> TimeInterval {
        if timeLeft != 0 {
            return timeLeft
        }

        setTimeLeft()

        return timeLeft
    }

    func getCurrentDate() -> Date {
        return Date()
    }

    func getTimeLeftString() -> String {
        return timeLeft.time
    }

    func shouldUpdateTimer() -> Bool {
        switch mode {
            case .login, .pause:
                    return true
            case .stop:
                return false
        }
    }

    func updateTimer() {
        updateTimeLeft()
        shapeStrokeEnd = CGFloat(timeLeft) / CGFloat(timerTime)
    }

    func getShapeStrokeEnd() -> CGFloat {
        shapeStrokeEnd = abs(CGFloat(timeLeft.truncatingRemainder(dividingBy: timerTime)) / CGFloat(timerTime))
        return shapeStrokeEnd
    }

    func setupTimer() {
        mode = getTimerMode()
        setTimeLeft()
        setStartTime()
        timerTime = mode.getTimeInterval()
    }

    func getCenterForStrokeEndPoint(frame: CGRect) -> CGPoint {
        var x = frame.midX
        var y = frame.midY - (frame.width / 2.0)

        let strokeEnd = getShapeStrokeEnd()

        switch strokeEnd {
            case 0..<0.25: do {
                x = frame.midX + (frame.width / 2.0) * sin((strokeEnd * 360).degreesToRadians)
                y = frame.midY - (frame.width / 2.0) * cos((strokeEnd * 360).degreesToRadians)
            }
            case 0.25..<0.50: do {
                x = frame.midX + (frame.width / 2.0) * cos((strokeEnd * 360 - 90).degreesToRadians)
                y = frame.midY + (frame.width / 2.0) * sin((strokeEnd * 360 - 90).degreesToRadians)
            }
            case 0.50..<0.75: do {
                x = frame.midX - (frame.width / 2.0) * sin((strokeEnd * 360 - 180).degreesToRadians)
                y = frame.midY + (frame.width / 2.0) * cos((strokeEnd * 360 - 180).degreesToRadians)
            }
            case 0.75..<1: do {
                x = frame.midX - (frame.width / 2.0) * cos((strokeEnd * 360 - 270).degreesToRadians)
                y = frame.midY - (frame.width / 2.0) * sin((strokeEnd * 360 - 270).degreesToRadians)
            }
            default:
                break
        }

        return CGPoint(x: x, y: y)
    }

}

extension TimeInterval {
    var time: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}
