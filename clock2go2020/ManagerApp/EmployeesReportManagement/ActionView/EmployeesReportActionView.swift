//
//  EmployeesReportActionView.swift
//  clock2go2020
//
//  Created by Gleb on 16.09.2020.
//

import UIKit

class EmployeesReportActionView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var closeMonthButton: UIButton!
    @IBOutlet weak var emailReportButton: UIButton!
    @IBOutlet weak var sortingView: UIView!
    @IBOutlet weak var titleSortingView: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var titleCalendarView: UILabel!
    @IBOutlet weak var selectAllView: UIView!
    @IBOutlet weak var selectAllLabel: UILabel!
    @IBOutlet weak var selectAllCheckboxIcon: UIImageView!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var upSlashView: UILabel!
    @IBOutlet weak var titleScreenLabel: UILabel!

    // MARK: - Public var
    weak var delegate: EmployeesReportActionViewDelegate?
    var sortingListViewTapped: ((_ type: SortingBy) -> Void)?
    var calendarViewTapped: ((_ date: Date) -> Void)?
    var selectAll: (() -> Void)?
    var approveReports:(() -> Void)?

    var viewModel: ReportActionViewModel!

    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Private func
    private func commonInit() {
        Bundle.main.loadNibNamed("EmployeesReportActionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setLocalized()
        setupTaps()
    }

    private func setLocalized() {
        emailReportButton.setTitle("SEND_EMAIL_TITLE".localized, for: .normal)
        closeMonthButton.setTitle("CLOSE_MONTH_TITLE".localized, for: .normal)
        titleCalendarView.text = Date().toString(format: "dd.MM.yyyy")
        approveButton.setTitle("APPROVE".localized, for: .normal)
        selectAllLabel.text = "SELECT_ALL".localized
        titleScreenLabel.text = ("MY_REPORTS".localized + ":")
    }

    private func setupUI() {
        closeMonthButton.roundCorners(.allCorners, radius: 16)
        closeMonthButton.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1))
        closeMonthButton.setTitle("סגור חודש", for: .normal)

        emailReportButton.roundCorners(.allCorners, radius: 16)
        emailReportButton.border(width: 1, color: #colorLiteral(red: 0.1137254902, green: 0.3019607843, blue: 0.4352941176, alpha: 1))
        emailReportButton.shadow(.zero, opacity: 0.4, radius: 5, color: #colorLiteral(red: 0.1137254902, green: 0.3019607843, blue: 0.4352941176, alpha: 1))
        emailReportButton.setTitle("שלח דו״ח במייל", for: .normal)

        sortingView.roundCorners(.allCorners, radius: 16)
        sortingView.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1))

        calendarView.roundCorners(.allCorners, radius: 16)
        calendarView.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1))
    }

    func updateUI() {
        titleSortingView.text = viewModel.getSortTypeString()
        calendarView.isUserInteractionEnabled = viewModel.shouldEnableMonthView()

        print(CompaniesDataManager.shared.hasReportCompletionFeature())
        print(CompaniesDataManager.shared.hasCloseMonthFeature())

        closeMonthButton.isHidden = !CompaniesDataManager.shared.hasCloseMonthFeature()
        selectAllView.isHidden    = !CompaniesDataManager.shared.hasReportCompletionFeature()
        approveButton.isHidden    = !CompaniesDataManager.shared.hasReportCompletionFeature()
        upSlashView.isHidden      = !CompaniesDataManager.shared.hasReportCompletionFeature()
        emailReportButton.isHidden = viewModel.shouldEnableSendEmail()
    }

    private func setupTaps() {
        let tapSortingListView = UITapGestureRecognizer.init(target: self, action: #selector(selectTappedSorting))
        sortingView.addGestureRecognizer(tapSortingListView)

        let tapCalendarView = UITapGestureRecognizer.init(target: self, action: #selector(selectTappedCalendar))
        calendarView.addGestureRecognizer(tapCalendarView)

        let tapSelectAllView = UITapGestureRecognizer.init(target: self, action: #selector(selectAllTapped))
        selectAllView.addGestureRecognizer(tapSelectAllView)
    }

    @objc func selectAllTapped() {
        print("select all")
        self.selectAll?()
    }

    @objc func selectTappedSorting() {
        print("tap sorting")
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve

        let top = stackView.frame.origin.y
        let left = sortingView.frame.origin.x + stackView.frame.origin.x
        let width = sortingView.frame.size.width

        let model = SortingListViewModel(type: .filter)

        chooseVC.configure(viewModel: model, top: top, left: left, width: width)

        chooseVC.choosedType = { _, title, taskItem in
            if let type = SortingBy.withTitle(title) {
                self.viewModel.setSortType(type: type)
                self.sortingListViewTapped?(type)
                self.updateUI()
            }
        }

        if let vc = NavigationController.shared?.getCurrentViewController() {
            vc.present(chooseVC, animated: true, completion: nil)
        }
    }

    @objc func selectTappedCalendar() {
        print("tap calendar")
        let vc = ViewSource.datePickerView()

        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.config(isDate: true, maxDate: nil)

        vc.selectedValue = { value in
            if value != nil {
                self.calendarViewTapped?(value ?? Date())
                self.titleCalendarView.text = value?.toString(format: "dd.MM.yyyy")
                self.viewModel.setSortType(type: .allReports)
                self.updateUI()
            }
        }
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @IBAction func closeMonthButtonTapped(_ sender: UIButton) {
        showCloseMonthView()
    }

    func showCloseMonthView() {
        let vc = ViewSource.closeMonthManagementScreen()
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    @IBAction func sendEmailButtonTapped(_ sender: UIButton) {
        let vc = ViewSource.emailReportView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

                   vc.viewModel = viewModel.getModelForSendMgrEmailView()

                   vc.emailSend = { email in
                       self.viewModel.setEmail(email: email)
                   }

        if let currentVC = NavigationController.shared?.getCurrentViewController() {
            currentVC.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        UserDefaultsManager.dateMgrReport = Date()
        UserDefaultsManager.empIdMgrReport =  0
        _ = NavigationController.shared?.popViewController(animated: false)
    }

    @IBAction func approveSelectedReports(_ sender: UIButton) {
        self.approveReports?()
    }
}

protocol EmployeesReportActionViewDelegate: NSObjectProtocol {
    func createDayReport(_ report: EmpDayReportsObj)
    func closeMonth()
}

extension EmployeesReportActionView: UpdateReportConfirmViewDelegate {
    func updateDayReport(_ report: EmpDayReportsObj) {
        delegate?.createDayReport(report)
    }
}
