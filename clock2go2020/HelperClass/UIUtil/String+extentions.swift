//
//  String+extentions.swift
//  clock2go2020
//
//  Created by Admin on 12/27/19.
//

import UIKit

extension String {

    var localized: String {
        var bundle: Bundle?
        guard let lang = UserDefaultsManager.appleLanguagesNew.first else { return self }

        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        if let path = path {
            bundle = Bundle(path: path)
        }

        return NSLocalizedString(self, tableName: nil, bundle: bundle ?? Bundle.main, value: "", comment: "")
    }

    func getUnderlined(color: UIColor?, stringForUnderline: String? = nil) -> NSMutableAttributedString {

        guard let string = stringForUnderline != nil ? stringForUnderline : self else { return NSMutableAttributedString(string: self) }

        let rangeColor = (self as NSString).range(of: string)
        let attributedString = NSMutableAttributedString(string: self)

        if let color = color {
            attributedString.addAttribute(.foregroundColor, value: color, range: rangeColor)
        }

        let rangeUnderline = (self as NSString).range(of: string)
        attributedString.addAttribute(.underlineStyle, value: NSNumber(value: 1), range: rangeUnderline)

        return attributedString
    }

    func getBolded(fontSize: CGFloat, stringForBold: String? = nil) -> NSMutableAttributedString {
        guard let string = stringForBold != nil ? stringForBold : self,
                let font = UIFont(name: "OpenSansHebrew-Bold", size: fontSize) else { return NSMutableAttributedString(string: self) }

        let attributedString = NSMutableAttributedString(string: self)

        let rangeBold = (self as NSString).range(of: string)
        attributedString.addAttribute(.font, value: font, range: rangeBold)

        return attributedString
    }

    func getDateFromStringWithFormat(_ format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        return formatter.date(from: self)
    }

    func getDateFromTimeString() -> Date {
        let hour = getHourComponent()
        let minutes = getMinuteComponent()
        let seconds = 0 // Calendar.current.dateComponents([.second], from: Date()).second ?? 0

        let date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: seconds, of: Date())

        return date ?? Date()
    }

    func getHourComponent() -> Int {
        let hourString = String(self.prefix(2))
        let hour = Int(hourString)
        return hour ?? 0
    }

    func getMinuteComponent() -> Int {
        let minuteString = String(self.suffix(2))
        let minute = Int(minuteString)
        return minute ?? 0
    }

    func changeDateFormat(from: String, to: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = from

        let date = formatter.date(from: self)

        return date?.toString(format: to) ?? ""
    }
    
    func getWeekDayNumberFormat() -> Int {
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "dd-MM-yyyy"

        if let date = formatter.date(from: self){
            return Calendar.current.component(.weekday, from: date)
        } else{
            return 0
        }
    }
   

    func getTotalHourStringToTimeString() -> String {
        guard let totalHour = Double(self), totalHour > 0 else { return "00:00" }

        let hour = Int(totalHour)
        let minutes = ((totalHour - Double(hour)) * 60.0).rounded()

        guard let date = Calendar.current.date(bySetting: .hour, value: hour, of: Date()),
            let finalDate = Calendar.current.date(bySetting: .minute, value: Int(minutes), of: date) else { return "00:00" }

        return finalDate.toString(format: "HH:mm")
    }

    func timeFormatted() -> String {
        let seconds = Int(((Double(self) ?? 0.0) * 60 * 60).rounded())

        let hours = seconds / 3600

        let minutes = (seconds % 3600) / 60

        return String(format: "%02d:%02d", hours, minutes)
    }

    // email validation
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func getLastCharacters(_ length: Int) -> String {
        return String(self.suffix(length))
    }
}
