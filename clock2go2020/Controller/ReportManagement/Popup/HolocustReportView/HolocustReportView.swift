//
//  RevachaReportView.swift
//  clock2go2020
//
//  Created by Gleb on 09.06.2021.
//

import Foundation
import UIKit

class HolocustReportView: UIView {
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var therapyView: UIView!
    @IBOutlet weak var therapyTitle: UILabel!
    
    @IBOutlet weak var transactionTypeView: UIView!
    @IBOutlet weak var transactionTypeTitle: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
        
    var trnsTypeTapped:(() -> ())?
    var therapyTapped:(() -> ())?
    var eventTapped:(() -> ())?
    var frameType:[CGFloat] = []
    
    var reportDidChanged:((_ complete: Bool) -> ())?
    var reportRemark: ((_ remark: String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func showEventButton() {
        eventView.isHidden = false
    }
    
    func hideEventButton() {
        eventView.isHidden = true
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HolocustReportView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        setupUI()
        setupLocalized()
        setupTaps()
    }
    
    private func setupUI() {
        setupUIForView(eventView)
        setupUIForView(therapyView)
        setupUIForView(transactionTypeView)
    }
    
    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 20.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08235294118, green: 0.2823529412, blue: 0.462745098, alpha: 1))
        view.border(width: 1, color: #colorLiteral(red: 0.08235294118, green: 0.2823529412, blue: 0.462745098, alpha: 1))
    }
    
    func setupLocalized() {
        therapyTitle.text = "Select_Therapy".localized
        transactionTypeTitle.text = "TRNS_TYPE".localized
        eventTitle.text = "SELECT_CLIENT".localized
        
        self.transactionTypeTitle.text = HolocustTrnsType.init(rawValue: 0)?.title ?? ""
    }
    
    func setupTaps() {
        let tapType = UITapGestureRecognizer(target: self, action: #selector(chooseType))
        transactionTypeView.isUserInteractionEnabled = true
        transactionTypeView.addGestureRecognizer(tapType)
        
        let tapClient = UITapGestureRecognizer(target: self, action: #selector(chooseTheraphy))
        therapyView.isUserInteractionEnabled = true
        therapyView.addGestureRecognizer(tapClient)
        
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(chooseEvent))
        eventView.isUserInteractionEnabled = true
        eventView.addGestureRecognizer(tapEvent)
    }
    
    @objc func chooseType() {
        trnsTypeTapped?()
    }
    
    @objc func chooseTheraphy() {
        therapyTapped?()
    }
    
    @objc func chooseEvent() {
        eventTapped?()
    }
}
