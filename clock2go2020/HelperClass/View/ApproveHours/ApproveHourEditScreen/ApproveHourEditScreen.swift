//
//  ApproveHourEditScreen.swift
//  clock2go2020
//
//  Created by Mac on 18/03/24.
//

import UIKit

class ApproveHourEditScreen: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet weak var popupView: UIView!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var approveHourTextField: UITextField!
    @IBOutlet weak var approveHoursTextfieldView: UIView!
    
   
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelLabel: UILabel!
   
    @IBOutlet weak var approvalView: UIView!
    @IBOutlet weak var approvalLabel: UILabel!
    
    var viewModel = ApproveHoursEditModel()
  
  
    var approvedHour : ApproveHourObj?
    
    var month : String = "0"
    var year : String = "0"
    var hours : String = "0"
    var id : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            month = "\(approvedHour?.month ?? 0)"
            year = "\(approvedHour?.year ?? 0)"
            hours = "\(approvedHour?.hoursApproved ?? 0)"
            id = approvedHour?.id ?? 0
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        setUpUI()
        setLocalizedStrings()
        setupTaps()
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func setUpUI(){
        popupView.roundCorners([.allCorners], radius: 30.0)
        popupView.shadow(CGSize(width: 1, height: 1), opacity: 0.3, radius: 5, color: CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
        approveHoursTextfieldView.roundCorners([.allCorners], radius: 15)
        approveHoursTextfieldView.shadow(CGSize(width: 1, height: 1), opacity: 0.4, radius: 5, color: CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
        
        approvalView.roundCorners([.allCorners], radius: 15)
        approvalView.shadow(CGSize(width: 1, height: 1), opacity: 0.1, radius: 5, color: CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
        cancelView.roundCorners([.allCorners], radius: 15)
        cancelView.shadow(CGSize(width: 1, height: 1), opacity: 0.1, radius: 5, color: CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
    }
    

    func setLocalizedStrings() {
        let monthAndYear = "\(month)/\(year)"
        let message = String(format: "Please_enter_the_hours_reports_for_the_month_of".localized, monthAndYear)
        titleLabel.text = message
        let amountOfHours  = String(format: "Enter_the_amount_of_hours".localized, hours)
        approveHourTextField.placeholder = amountOfHours
        cancelLabel.text = "Cancel".localized
        approvalLabel.text = "approve".localized
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(tap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmAction))
        approvalView.addGestureRecognizer(confirmTap)
        
       
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func showErrorView(message: String?, errorCode: Int?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: String(errorCode ?? 0), message: message)
        self.present(vc, animated: true, completion: nil)
    }
    @objc func confirmAction() {
        
        if ((approveHourTextField.text?.isEmpty) == true) || approveHourTextField.text == "" || approveHourTextField.text == nil  {
            viewModel.sentHoursApproved(hourId: id, hoursApproved: Int(hours)){[weak self] success,error in
                if (success){
                    let vc = ViewSource.approveHourSuccessView()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self?.dismissView()
                    NavigationController.shared?.showErrorView(error: error)
                }
            }
        }else{
            if let aprHour = Int(approveHourTextField.text!) {
                if aprHour <= Int(hours)!{
                    
                    viewModel.sentHoursApproved(hourId: id, hoursApproved: Int(approveHourTextField.text!)){[weak self] success,error in
                        if (success){
                            let vc = ViewSource.approveHourSuccessView()
                            self?.navigationController?.pushViewController(vc, animated: true)
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
    
   
    @IBAction func backButtonTapped(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)
    }
    
    
}
