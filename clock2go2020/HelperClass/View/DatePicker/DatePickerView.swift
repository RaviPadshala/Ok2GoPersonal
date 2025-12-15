//
//  DatePickerView.swift
//  clock2go2020
//
//  Created by Admin on 2/8/20.
//

import UIKit

class DatePickerView: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var datePickerTitle: UILabel!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmLabel: UILabel!

    var isDate: Bool = true
    var minimumDate: Date?
    var maximumDate: Date?

    var datePicker = UIDatePicker()

    var selectedValue: ((_ value: Date?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalized()
        setupUI()
        setupDatePicker()
        setupTaps()
    }

    override func viewWillLayoutSubviews() {
        setupDatePicker()
    }

    func config(isDate: Bool = true, maxDate: Date?) {
        self.isDate = isDate
        self.maximumDate = maxDate
    }

    func setupLocalized() {
        confirmLabel.text = "CONFIRM".localized
    }

    func setupUI() {
        contentView.roundCorners([.allCorners], radius: 30.0)

        confirmView.border(width: 1.0, color: #colorLiteral(red: 0.06591648608, green: 0.2839878201, blue: 0.4638021588, alpha: 1))
        confirmView.roundCorners([.allCorners], radius: 30.0)
    }

    func setupDatePicker() {
        datePicker = UIDatePicker.init()

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        datePicker.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")
        datePicker.backgroundColor = UIColor.white
        datePicker.setValue(#colorLiteral(red: 0.06591648608, green: 0.2839878201, blue: 0.4638021588, alpha: 1), forKey: "textColor")

        datePicker.minimumDate = isDate ? minimumDate : nil
        datePicker.maximumDate = isDate ? maximumDate : maximumDate

        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = isDate ? .date : .time

        datePicker.frame = datePickerView.bounds
        datePickerView.addSubview(datePicker)
    }

    func setupTaps() {
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirm))
        confirmView.addGestureRecognizer(confirmTap)
    }

    @objc func confirm() {
        self.dismiss(animated: true, completion: nil)
        selectedValue?(datePicker.date)
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        selectedValue?(nil)
    }

}
