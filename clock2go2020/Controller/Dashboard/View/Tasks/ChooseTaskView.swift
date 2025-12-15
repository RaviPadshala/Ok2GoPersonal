//
//  ChooseTaskView.swift
//  clock2go2020
//
//  Created by Admin on 1/3/20.
//

import UIKit

class ChooseTaskView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var chooseTaskView: UIView!
    @IBOutlet weak var selectTaskTitle: UILabel!
    @IBOutlet weak var selectTaskView: UIView!
    @IBOutlet weak var selectTaskLabel: UILabel!
    
    var selectTaskTapped: (() -> Void)?

    var isLastReportLogin: Bool {
        guard let report = CompaniesDataManager.shared.getLastLoginReport() else { return false }

        if let task = report.taskName, task != "" {
            return true
        }

        return CompaniesDataManager.shared.shouldReportTask()
    }

    var isPaused: Bool {
        return CompaniesDataManager.shared.getLastBreakReport() != nil
    }

    var hasLastReports: Bool {
        return CompaniesDataManager.shared.getLastReports().count != 0
    }

    var shouldShowLastReports: Bool {
        return CompaniesDataManager.shared.hasShowReportsFeature()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ChooseTaskView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setLocalizedStrings()
        setupUI()
        setupTaps()

        reloadView()
    }

    func setLocalizedStrings() {
        selectTaskTitle.text = "SELECT_TASK_MESSAGE".localized
        selectTaskLabel.text = "SELECT_TASK".localized
    }

    func setupUI() {
        selectTaskView.roundCorners([.allCorners], radius: 25.0)
        selectTaskView.layer.borderColor = #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1)
        selectTaskView.layer.borderWidth = 0.7
    }

    func shouldDisableChooseTaskView() -> Bool {
        if CompaniesDataManager.shared.isBituachLeumi() {
            return false
        }
        return (isPaused || isLastReportLogin) && !CompaniesDataManager.shared.hasRequestExitCompletionFeature()
    }

    func reloadView() {
        if !CompaniesDataManager.shared.hasBarcodeReportsFeature() {
            chooseTaskView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
            chooseTaskView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        } else {
            chooseTaskView.roundCorners([], radius: 0)
            chooseTaskView.shadow(.zero, opacity: 0.0, radius: 0.0, color: UIColor.clear.cgColor)
        }

        isUserInteractionEnabled = shouldDisableChooseTaskView() ? false : true
        selectTaskView.alpha = shouldDisableChooseTaskView() ? 0.5 : 1
        selectTaskTitle.alpha = shouldDisableChooseTaskView() ? 0.5 : 1
        selectTaskTitle.isHidden = hasLastReports // && shouldShowLastReports
        
  
        
        
    }
    func disbaleChooseTaskView(disable: Bool){
        if disable{
            isUserInteractionEnabled = false
            selectTaskView.alpha = 0.5
            selectTaskTitle.alpha = 0.5
        }else{
            isUserInteractionEnabled = true
            selectTaskView.alpha = 1
            selectTaskTitle.alpha = 1
        }
        
        
        
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectTapped))
        selectTaskView.addGestureRecognizer(tap)
    }

    @objc func selectTapped() {
        selectTaskTapped?()
    }

}
