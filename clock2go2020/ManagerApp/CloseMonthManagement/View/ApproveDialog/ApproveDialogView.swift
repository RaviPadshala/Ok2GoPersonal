//
//  ApproveDialogView.swift
//  clock2go2020
//
//  Created by Gleb on 21.10.2020.
//

import UIKit

// MARK: Var
var textStatus: String?

class ApproveDialogView: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var successTitle: UILabel!
    @IBOutlet weak var approveView: UIView!
    @IBOutlet weak var approveTitle: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    var viewModel: ApproveDialogViewModel!
    weak var delegate: UpdateCloseMonthDelegate?

    var didSelect: (() -> Void)?
    var approveMgrReports: (() -> Void)?
    var approveAllReports: (() -> Void)?

    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTaps()
        setupLocalized()
    }

    override func viewWillAppear(_ animated: Bool) {
        successTitle.text = textStatus
    }

    // MARK: Property
    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)
        approveView.roundCorners([.allCorners], radius: 25.0)
        cancelView.roundCorners([.allCorners], radius: 25.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    func setupLocalized() {
        approveTitle.text = "APPROVE".localized
        cancelTitle.text  = "CANCEL".localized
    }

    func setupTaps() {
        let approveTap = UITapGestureRecognizer(target: self, action: #selector(approveTapped))
        approveView.addGestureRecognizer(approveTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)

        let dismissTap = UITapGestureRecognizer(target: self, action: #selector((dismissTapped)))
        view.addGestureRecognizer(dismissTap)
    }

    @objc func dismissTapped() {
        self.dismiss(animated: true, completion: nil)
        print("dismiss")
    }

    @objc func approveTapped() {
        self.didSelect?()
        self.approveMgrReports?()
        self.approveAllReports?()
        print("Approve")
        self.dismiss(animated: true, completion: nil)

    }

    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
}

protocol UpdateCloseMonthDelegate: AnyObject {
    func updateCloseMonth()
}
