//
//  ConfirmTaskView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 04.01.2020.
//

import UIKit
import IQKeyboardToolbarManager
import IQKeyboardManagerSwift

class DistanceView: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var taskTitle: UILabel!
    
    @IBOutlet weak var view_cancel: UIView!
    @IBOutlet weak var lbl_cancelTitle: UILabel!
    
    @IBOutlet weak var view_confirm: UIView!
    @IBOutlet weak var lbl_confirm: UILabel!
    
    @IBOutlet weak var view_fromCity: UIView!
    @IBOutlet weak var lbl_fromCity: UILabel!
    @IBOutlet weak var view_toCity: UIView!
    @IBOutlet weak var lbl_toCity: UILabel!
    @IBOutlet weak var view_enterDistace: UIView!
    @IBOutlet weak var txt_distace: UITextField!
    @IBOutlet weak var view_icon: UIView!
    
    var tapConfirm: ((_ fromCity: CitylistObj?, _ toCity: CitylistObj?, _ distace: String?) -> ())?
    var tapCancel: (() -> ())?
    var selectedFromCity: CitylistObj?
    var selectedToCity: CitylistObj?
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setLocalizedStrings()
        setupTaps()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.isEnabled = false
        IQKeyboardToolbarManager.shared.isEnabled = false
    }
    
    // MARK: Property
    func setupUI() {
        
        self.txt_distace.delegate = self
        
        self.roundedView.roundCorners([.allCorners], radius: 30.0)
        setupUIForView(self.view_confirm)
        setupUIForView(self.view_cancel)
        
        self.view_fromCity.border(width: 1.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        self.view_toCity.border(width: 1.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        self.view_enterDistace.border(width: 1.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        self.view_icon.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        self.view_confirm.isUserInteractionEnabled = false
        self.view_confirm.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        if CompaniesDataManager.shared.shouldTravelReportEnable(){
            self.view_toCity.isHidden = false
            self.view_fromCity.isHidden = false
            self.view_enterDistace.isHidden = true
        }else{
            self.view_toCity.isHidden = true
            self.view_fromCity.isHidden = true
            self.view_enterDistace.isHidden = false
        }
    }
    
    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 30.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }
    
    
    func setLocalizedStrings() {
        self.lbl_confirm.text = "CONFIRM".localized
        self.lbl_cancelTitle.text = "CANCEL".localized
        self.taskTitle.text = "Please_select_a_travel_route".localized
        self.lbl_cancelTitle.textAlignment = .center
        self.lbl_fromCity.text = "select_city".localized
        self.lbl_toCity.text = "select_city".localized
        self.txt_distace.placeholder = "Enter_manual_distance".localized
    }
    
    func setupTaps() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
//        backgroundView.addGestureRecognizer(tap)
        
        let entryTap = UITapGestureRecognizer(target: self, action: #selector(self.confirmTapped))
        self.view_confirm.addGestureRecognizer(entryTap)
        
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        self.view_cancel.addGestureRecognizer(cancelTap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmTapped() {
        dismissView()
        self.tapConfirm?(self.selectedFromCity, self.selectedToCity, self.txt_distace.text)
    }
    
    @objc func cancelTapped() {
        dismissView()
        self.tapCancel?()
    }
    
    func checkCityValidation(){
        if let city1 = self.selectedFromCity, let city2 = self.selectedToCity{
            self.view_confirm.isUserInteractionEnabled = true
            self.view_confirm.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.2980392157, blue: 0.4862745098, alpha: 1)
        }else{
            self.view_confirm.isUserInteractionEnabled = false
            self.view_confirm.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    @IBAction func clickSelectFromCity(_ sender: UIButton) {
        let vc = ViewSource.cityListScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.tapCity = { cityObj in
            self.selectedFromCity = cityObj
            self.lbl_fromCity.text = cityObj.city ?? "select_city".localized
            self.checkCityValidation()
        }
        if let dict = self.selectedToCity{
            vc.selectedCityID = dict.ID ?? 0
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func clickSelectToCity(_ sender: UIButton) {
        let vc = ViewSource.cityListScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.tapCity = { cityObj in
            self.selectedToCity = cityObj
            self.lbl_toCity.text = cityObj.city ?? "select_city".localized
            self.checkCityValidation()
        }
        if let dict = self.selectedFromCity{
            vc.selectedCityID = dict.ID ?? 0
        }
        self.present(vc, animated: true)
    }
}

extension DistanceView: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        // Check if the updated text is valid (non-negative and matches the format)
        return isValidAmount(updatedText)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            textField.text = formatAmount(text)
            
            if let value = Double(text), value > 0 {
                self.view_confirm.isUserInteractionEnabled = true
                self.view_confirm.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.2980392157, blue: 0.4862745098, alpha: 1)
            }else{
                self.view_confirm.isUserInteractionEnabled = false
                self.view_confirm.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
    }
    
    // MARK: - Validation and Formatting
    func isValidAmount(_ text: String) -> Bool {
        // Regular expression to match up to 4 digits before the decimal and 2 after the decimal
        let regex = "^[0-9]{0,4}(\\.[0-9]{0,2})?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
    
    func formatAmount(_ text: String) -> String {
        var formattedText = text
        
        // Ensure there is only 2 digits after the decimal point
        if let decimalRange = formattedText.range(of: ".") {
            let digitsAfterDecimal = formattedText[decimalRange.upperBound...]
            if digitsAfterDecimal.count > 2 {
                formattedText = String(formattedText.prefix(upTo: decimalRange.upperBound))
                formattedText = String(formattedText.prefix(7)) // Keep it at most 4 digits + 2 decimals
            }
        }
        
        // Ensure there are no more than 4 digits before the decimal
        if formattedText.count > 7 { // 4 digits + decimal point + 2 digits after decimal
            formattedText = String(formattedText.prefix(7))
        }
        
        // Return the formatted text
        return formattedText
    }
}
