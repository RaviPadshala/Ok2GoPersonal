//
//  SuccessView.swift
//  clock2go2020
//
//  Created by Admin on 4/28/20.
//

import UIKit

class SuccessView: UIViewController {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var successTitle: UILabel!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!

    var viewModel: SuccessViewModel?
    var confirmTapped: (() -> Void)?
    
    var isStartTimer = Bool()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setLocalizedStrings()
        setupTaps()
        if self.isStartTimer{
            self.startTimer()
        }
    }

    override func viewWillLayoutSubviews() {
        config()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isStartTimer{
            self.cancelTimer()
        }
    }

    // MARK: Property
    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)
        confirmView.roundCorners([.allCorners], radius: 30.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    func setViewModel(_ viewModel: SuccessViewModel) {
        self.viewModel = viewModel
    }

    func config() {
        guard let viewModel = self.viewModel else { return }

        successTitle.text = viewModel.message
    }

    func setLocalizedStrings() {
        successTitle.text = "SUCCESS_TITLE".localized
        confirmTitle.text = "CONFIRM".localized
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmAction))
        confirmView.addGestureRecognizer(confirmTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmAction() {
        self.dismissView()
        confirmTapped?()
    }

    func startTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            DispatchQueue.main.async {
                // Code to execute after 10 seconds
                self.cancelTimer()
                self.dismissView()
                self.confirmTapped?()
            }
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}
