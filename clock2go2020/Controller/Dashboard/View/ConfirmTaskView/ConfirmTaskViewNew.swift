//
//  ConfirmTaskView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 04.01.2020.
//

import UIKit

class ConfirmTaskViewNew: UIViewController {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var entryReportView: UIView!
    @IBOutlet weak var entryReportTitle: UILabel!
    
    @IBOutlet weak var exitReportView: UIView!
    @IBOutlet weak var exitReportTitle: UILabel!

    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewTitle: UnderlinedLabel!


    var message = String()
    var descirptionString = String()
    
    var tapConfirm: ((_ reportType: Int) -> ())?
    var tapCancel: (() -> ())?
    
    var timer: Timer?

    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setLocalizedStrings()
        setupTaps()
        self.startTimer()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cancelTimer()
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillLayoutSubviews() {
        config()
    }

    // MARK: Property
    func setupUI() {
        self.roundedView.roundCorners([.allCorners], radius: 30.0)

        self.setupUIForView(self.entryReportView)
        self.setupUIForView(self.exitReportView)
    }

    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 25.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setLocalizedStrings() {
        self.entryReportTitle.text = "LOGIN".localized
        self.exitReportTitle.text = "LOGOUT".localized
        self.cancelViewTitle.text = "CANCEL".localized
        self.cancelViewTitle.textAlignment = .center
    }

    func config() {
        self.taskTitle.text = self.descirptionString
        self.taskNameLabel.text = self.message
        self.view.layoutIfNeeded()
    }


    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        backgroundView.addGestureRecognizer(tap)

        let entryTap = UITapGestureRecognizer(target: self, action: #selector(self.entryTapped))
        self.entryReportView.addGestureRecognizer(entryTap)
        
        let exitTap = UITapGestureRecognizer(target: self, action: #selector(self.exitTapped))
        self.exitReportView.addGestureRecognizer(exitTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func entryTapped() {
        dismissView()
        self.tapConfirm?(0)
    }

    @objc func exitTapped() {
        dismissView()
        self.tapConfirm?(1)
    }
    
    @objc func cancelTapped() {
        dismissView()
        self.tapCancel?()
    }

    func startTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { timer in
            DispatchQueue.main.async {
                // Code to execute after 10 seconds
                self.dismissView()
                self.tapCancel?()
            }
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}
