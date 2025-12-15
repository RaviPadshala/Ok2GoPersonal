//
//  ApproveHourSuccess.swift
//  clock2go2020
//
//  Created by Mac on 18/03/24.
//

import UIKit

class ApproveHourSuccess: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var cancelView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setLocalizedStrings()
        setupTaps()

        // Do any additional setup after loading the view.
    }
    func setUpUI(){
        popupView.roundCorners([.allCorners], radius: 30.0)
        popupView.shadow(CGSize(width: 1, height: 1), opacity: 0.3, radius: 5, color: CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
        
        cancelView.roundCorners([.allCorners], radius: 15)
        cancelView.shadow(CGSize(width: 1, height: 1), opacity: 0.1, radius: 5, color: CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
    }
    

    func setLocalizedStrings() {
        
        titleLabel.text = "The_report_was_made_successfully".localized
        cancelLabel.text = "Back_to_main_screen".localized
        
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        cancelView.addGestureRecognizer(tap)

       
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
