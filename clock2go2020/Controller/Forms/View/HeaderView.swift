//
//  HeaderView.swift
//  clock2go2020
//
//  Created by Mac on 26/09/24.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    var headerTitle : String? = ""
    
    var backButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        dateLabel.text = getCurrentDateString()
        headerLabel.font = UIFont(name: "OpenSansHebrew-Regular", size: 18)
      
    }
    
    func changeHeaderTitle(text : String?){
        headerLabel.text = text
    }
    
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let date = Date()
        let result = formatter.string(from: date)

        return result
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        backButtonTapped?()
            //  _ = NavigationController.shared?.popViewController(animated: true)
        
    }
    
}
