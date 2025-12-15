//
//  FormViewCell.swift
//  clock2go2020
//
//  Created by Mac on 26/09/24.
//

import UIKit

class FormViewCell: UITableViewCell {
    
    static var identifier: String = "FormViewCell"
    
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    
    var viewModel: FormCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    func setupUI() {
//        self.dayView.border(width: 2.0, color: UIColor(named: "ColorF876C6")!.cgColor)
        self.dayView.roundCorners([.topLeft, .bottomLeft], radius: 9)
        self.dayView.shadow(CGSize(width: 0, height: 4), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.3338113816, green: 0.3614248776, blue: 0.4015404281, alpha: 1))
    }
    
    func config(viewModel: FormCellViewModel) {
        self.viewModel = viewModel
        self.dayLabel.text = self.viewModel?.getTitle()
    }
}
