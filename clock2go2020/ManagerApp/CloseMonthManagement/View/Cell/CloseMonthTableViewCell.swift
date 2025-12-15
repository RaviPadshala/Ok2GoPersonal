//
//  CloseMonthTableViewCell.swift
//  clock2go2020
//
//  Created by Gleb on 22.09.2020.
//

import  UIKit
import  Foundation

class CloseMonthTableViewCell: UITableViewCell {

    /// identifier cell
    static let identifier = "CloseMonthTableViewCell"

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalHour: UILabel!
    @IBOutlet weak var totalMissingReports: UILabel!
    @IBOutlet weak var totalAbsenseReports: UILabel!
    @IBOutlet weak var shlomitApprovel: UILabel!
    @IBOutlet weak var shlomitName: UILabel!
    @IBOutlet weak var closeDateLabel: UILabel!

    @IBOutlet weak var closeByEmpButton: UIButton!
    @IBOutlet weak var mgrApproveButton: UIButton!

    // MARK: - Publica var
    var viewModel: CloseMonthMgrCellViewModel!
    var empId: Int?
    var send: Bool?
    weak var delegate: CloseMonthDelegate?

    var showApprovalTapped:(() -> Void)?
    var empNameTapped:(() -> Void)?

    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTaps()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // MARK: - Config view model for cell
    func configure(viewModel: CloseMonthMgrCellViewModel) {
        self.viewModel = viewModel

        let name    = viewModel.getEmpName()
        nameLabel.attributedText = name.getUnderlined(color: #colorLiteral(red: 0.06274509804, green: 0.2823529412, blue: 0.462745098, alpha: 1), stringForUnderline: name)

        totalHour.text           = String(viewModel.getTotalHours())
        totalMissingReports.text = String(viewModel.getMissing())
        totalAbsenseReports.text = String(viewModel.getAbsence())
        closeDateLabel.text      = viewModel.getCloseDate()
        shlomitName.text         = viewModel.getShlomitName()
        shlomitApprovel.text     = viewModel.getEmployerApproval()

        closeByEmpButton.setImage(viewModel.getMonthClosedImage(), for: .normal)
        mgrApproveButton.setImage(viewModel.getMgrAppImage(), for: .normal)
    }

    // MARK: - Private func
    private func setupTaps() {
        let tapSortingListView = UITapGestureRecognizer.init(target: self, action: #selector(selectTappedSorting))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(tapSortingListView)

        let tapApprovalView = UITapGestureRecognizer.init(target: self, action: #selector(approvalTapped))
        shlomitApprovel.isUserInteractionEnabled = true
        shlomitApprovel.addGestureRecognizer(tapApprovalView)
    }

    private func showDialogView() {
        let vc = ViewSource.approveDialogView()

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @objc func selectTappedSorting() {
        self.empNameTapped?()
    }

    @objc func approvalTapped() {
        print(viewModel.getEmployerApproval())
        self.showApprovalTapped?()
    }

    @IBAction func selectButtonAction(_ sender: Any) {
        let status = viewModel.getMonthClosed()
        if status == 0 {
            self.delegate?.setStatus(close: 1, tag: self.tag)
            textStatus = "CLOSE_MONTH_EMP".localized
        } else {
            self.delegate?.setStatus(close: 0, tag: self.tag)
            textStatus = "OPEN_MONTH_EMP".localized
        }
    }

    @IBAction func selectMgrButtonAction(_ sender: Any) {
        let status = viewModel.getMonthClosed()
        if status == 0 {
            self.delegate?.setStatus(close: 2, tag: self.tag)
            textStatus = "APPROVE_EMP".localized
        } else {
            self.delegate?.setStatus(close: 0, tag: self.tag)
            textStatus = "REMOVE_APPROVAL_EMP".localized
        }
    }
}

protocol CloseMonthDelegate: AnyObject {
    func setStatus(close: Int, tag: Int)
}
extension CloseMonthTableViewCell: UpdateCloseMonthDelegate {
    func updateCloseMonth() {
    }

}
