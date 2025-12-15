//
//  ApproveHour.swift
//  clock2go2020
//
//  Created by Mac on 04/04/24.
//

import UIKit

class ApproveHour: UIViewController {
    
    // MARK: Outlets
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var approveHourTextField: UITextField!

    @IBOutlet weak var approvalView: UIView!
    @IBOutlet weak var approvalLabel: UILabel!

    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelLabel: UILabel!
    
    
    var approvedHour : ApproveHourObj?
    
    var viewModel = ApproveHourModel()
    
    var month : String = "0"
    var year : String = "0"
    var hours : String = "0"
    var id : Int = 0
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        month = "\(approvedHour?.month ?? 0)"
        year = "\(approvedHour?.year ?? 0)"
        hours = "\(approvedHour?.hoursApproved ?? 0)"
        id = approvedHour?.id ?? 0
    

        setupUI()
        setTextField()
        setLocalizedStrings()
        setupTaps()
        //reloadConfirmView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Property
     func setupUI() {
         roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

         iconView.roundCorners([.allCorners], radius: 50)
         iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
         iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

         setupUIForView(approvalView)
         setupUIForView(cancelView)
     }

     func setupUIForView(_ view: UIView) {
         view.roundCorners([.allCorners], radius: 30.0)
         view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
     }

     func setTextField() {
         approveHourTextField.delegate = self
         approveHourTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

         approveHourTextField.roundCorners([.allCorners], radius: 30)
         approveHourTextField.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
         approveHourTextField.border(width: 1.3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
         approveHourTextField.borderStyle = .none
         let amountOfHours  = String(format: "amount_of_hours".localized, hours)
         approveHourTextField.placeholder = amountOfHours
         approveHourTextField.placeholderColor(color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

         approveHourTextField.setPadding(rightImage: UIImage(named: "writing"), rightPadding: 50, leftPadding: 50)

         approveHourTextField.addCloseToolbar()
     }

    func setLocalizedStrings() {
        let monthAndYear = "\(month)/\(year)"
        let message = String(format: "Please_confirm_the_hours_reports_for_the_month_of".localized, monthAndYear)
        titleLabel.text = message
//        let amountOfHours  = String(format: "Enter_the_amount_of_hours".localized, hours)
//        approveHourTextField.placeholder = amountOfHours
       // approveHourTextField.text = "\(hours)"
        cancelLabel.text = "Cancel".localized
        approvalLabel.text = "approve".localized
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        backgroundView.addGestureRecognizer(tap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        approvalView.addGestureRecognizer(confirmTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)
        
        
        
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    func loadData() {
        vc?.view.addSubview(loadingView)
        let company = GetCompaniesEndpoint()
        company.apiCall { (result, error) in
            if error?.success ?? false {
                CompaniesDataManager.shared.setCompanies(result?.data)
                self.loadingView.removeFromSuperview()
                
            } else {
                self.loadingView.removeFromSuperview()
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

    @objc func confirmTapped() {
        
        if ((approveHourTextField.text?.isEmpty) == true) || approveHourTextField.text == "" || approveHourTextField.text == nil  {
          
        }else{
            
            if let aprHour = Int(approveHourTextField.text!) {
                if aprHour <= Int(hours)!{
                    
                    viewModel.sentHoursApproved(hourId: id, hoursApproved: Int(approveHourTextField.text!)){[weak self] success,error in
                        if (success){
                            //self?.loadData()
                            self?.dismissView()
                            NavigationController.shared?.showSuccessView(message: "The_report_was_made_successfully".localized)
                            
                        }else{
                            self?.dismissView()
                            NavigationController.shared?.showErrorView(error: error)
                        }
                    }
                }else{
                    let message = String(format: "The_maximum_number_of_hours_that_can_be_reported_is".localized,"\(hours)" )
                    self.showErrorView(message: message, errorCode: nil)
                    
                }
            }
        }
      
    }

    @objc func cancelTapped() {
        dismissView()
    }
    
    
    func showErrorView(message: String?, errorCode: Int?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: String(errorCode ?? 0), message: message)
        self.present(vc, animated: true, completion: nil)
    }

    func reloadConfirmView() {
        if approveHourTextField.text == nil || approveHourTextField.text == "" {
            approvalView.isUserInteractionEnabled = false
            approvalView.alpha = 0.5
        } else {
            approvalView.isUserInteractionEnabled = true
            approvalView.alpha = 1
        }
    }

}

extension ApproveHour: UITextFieldDelegate {
    
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 30
    }
//
    @objc func textFieldDidChange(_ textField: UITextField) {
        reloadConfirmView()
    }

}

extension ApproveHour {

    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.layoutIfNeeded()

        var keyboardHeight = CGFloat(0.0)

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        UIView.animate(withDuration: 3) {
            self.bottomConstraint.constant = keyboardHeight + 40
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.bottomConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }

}
