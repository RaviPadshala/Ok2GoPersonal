//
//  ApproveHours.swift
//  clock2go2020
//
//  Created by Mac on 18/03/24.
//

import UIKit

class ApproveHours: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var popupView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var approveHoursTextfieldView: UIView!
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var approveHoursLabel: UILabel!
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelLabel: UILabel!
   
    @IBOutlet weak var approvalView: UIView!
    @IBOutlet weak var approvalLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    var viewModel = ApproveHoursModel()
  
   
    
 
    var approvedHour : ApproveHourObj?
    
    var month : String = "0"
    var year : String = "0"
    var hours : String = "0"
    var id : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        month = "\(approvedHour?.month ?? 0)"
            year = "\(approvedHour?.year ?? 0)"
            hours = "\(approvedHour?.hoursApproved ?? 0)"
            id = approvedHour?.id ?? 0
            
        
        setUpUI()
        setLocalizedStrings()
        setupTaps()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        
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
        let message = String(format: "Please_confirm_the_hours_reports_for_the_month_of".localized, monthAndYear)
        titleLabel.text = message
        let amountOfHours  = String(format: "amount_of_hours".localized, hours)
        approveHoursLabel.text = amountOfHours
        cancelLabel.text = "Cancel".localized
        approvalLabel.text = "approve".localized
        noteLabel.text = "To_edit_click_on_the_pencil".localized
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(tap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmAction))
        approvalView.addGestureRecognizer(confirmTap)
        
        let editHourTap = UITapGestureRecognizer(target: self, action: #selector(editAction))
        editView.addGestureRecognizer(editHourTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmAction() {
        
        viewModel.sentHoursApproved(hourId: id, hoursApproved: Int(hours)){[weak self] success,error in
            if (success){
                let vc = ViewSource.approveHourSuccessView()
                self?.navigationController?.pushViewController(vc, animated: true)
            }else{
               
                self?.dismissView()
                NavigationController.shared?.showErrorView(error: error)
            }
        }
        
    }
    
    
    @objc func editAction() {
        
        let vc = ViewSource.approveHourEditView()
        vc.approvedHour = approvedHour
        self.navigationController?.pushViewController(vc, animated: true)
        
       
    }

}
