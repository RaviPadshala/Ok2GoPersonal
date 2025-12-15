//
//  MonthEmpActionView.swift
//  clock2go2020
//
//  Created by Gleb on 02.12.2020.
//

import UIKit

class MonthEmpActionView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var closeMonthButton: UIButton!
    @IBOutlet weak var emailReportButton: UIButton!
    @IBOutlet weak var sortingView: UIView!
    @IBOutlet weak var titleSortingView: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var titleCalendarView: UILabel!
    @IBOutlet weak var addReportButton: UIButton!
    @IBOutlet weak var selectAllView: UIView!
    @IBOutlet weak var selectAllLabel: UILabel!
    @IBOutlet weak var selectAllCheckboxIcon: UIImageView!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var titleScreenLabel: UILabel!

    // MARK: - Public var
    var sortingListViewTapped: ((_ type: SortingBy) -> Void)?
    var calendarViewTapped: ((_ index: Int) -> Void)?
    var approveReports:(() -> Void)?
    var selectAll: (() -> Void)?
    var addReport:(() -> Void)?

    weak var delegate: MonthEmpActionViewDelegate?
    var viewModel: ReportActionViewModel!
    var monthEmpActionVM = MonthEmpActionViewModel()

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
        Bundle.main.loadNibNamed("MonthEmpActionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        loadMonthlyStats()
        setupUI()
        setLocalized()
        setupTaps()

        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload),
                                               name: NSNotification.Name(rawValue: "managerUpdateMonthStatus"), object: nil)
    }

    private func loadMonthlyStats() {
        monthEmpActionVM.delegate = self
        monthEmpActionVM.loadData()
        monthEmpActionVM.loadMonthStats()
    }

    private func setLocalized() {
        emailReportButton.setTitle("SEND_EMAIL_TITLE".localized, for: .normal)
        closeMonthButton.setTitle("CLOSE_MONTH_TITLE".localized, for: .normal)
        titleCalendarView.text = Date().toString(format: "MM-dd")
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
        emailReportButton.isHidden = shouldEnableSendEmail()

        sortingView.roundCorners(.allCorners, radius: 16)
        sortingView.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1))

        calendarView.roundCorners(.allCorners, radius: 16)
        calendarView.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1))

        addReportButton.roundCorners(.allCorners, radius: 16)
        addReportButton.border(width: 2.5, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        addReportButton.shadow(.zero, opacity: 0.4, radius: 5, color: #colorLiteral(red: 0.2443430722, green: 0.800511539, blue: 0.1960784314, alpha: 1))
        addReportButton.imageView?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
    }

    func updateUI() {
        loadMonthlyStats()
        titleSortingView.text = viewModel.getSortTypeString()
        titleCalendarView.text = viewModel.getMonthString()
    }

    func setupCloseMonth() {
        closeMonthButton.isEnabled = !monthEmpActionVM.monthIsClosed()
        closeMonthButton.setTitle(monthEmpActionVM.getStringMonthClose(), for: .normal)
    }

    private func setupTaps() {
        let tapSortingListView = UITapGestureRecognizer.init(target: self, action: #selector(selectTappedSorting))
        sortingView.addGestureRecognizer(tapSortingListView)

        let tapCalendarView = UITapGestureRecognizer.init(target: self, action: #selector(selectTappedCalendar))
        calendarView.addGestureRecognizer(tapCalendarView)

        let tapSelectAllView = UITapGestureRecognizer.init(target: self, action: #selector(selectAllTapped))
        selectAllView.addGestureRecognizer(tapSelectAllView)

    }
    @objc func shouldReload() {
        self.loadMonthlyStats()
    }

    private func shouldEnableSendEmail() -> Bool {
        if CompaniesDataManager.shared.getSpecialClientType() == 3665 {
            return true
        }
        return false
    }
    @objc func selectAllTapped() {
        print("select all")
        self.selectAll?()
    }

    @objc func selectTappedSorting() {
        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve

        let top = stackView.frame.origin.y
        let left = sortingView.frame.origin.x + stackView.frame.origin.x
        let width = sortingView.frame.size.width

        let model = SortingListViewModel(type: .filter)

        chooseVC.configure(viewModel: model, top: top, left: left, width: width)

        chooseVC.choosedType = { _, title, _ in
            if let type = SortingBy.withTitle(title) {
                self.viewModel.setSortType(type: type)
                self.updateUI()
                self.sortingListViewTapped?(type)
            }
        }

        if let vc = NavigationController.shared?.getCurrentViewController() {
            vc.present(chooseVC, animated: true, completion: nil)
        }
    }

    @objc func selectTappedCalendar() {

        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve

        let top = stackView.frame.origin.y
        let left = calendarView.frame.origin.x + stackView.frame.origin.x
        let width = calendarView.frame.size.width

        let model = SortingListViewModel(type: .month)

        chooseVC.configure(viewModel: model, top: top, left: left, width: width)

        chooseVC.choosedType = { _, title, _ in
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")

            let monthIndex = calendar.monthSymbols.firstIndex(of: title) ?? 0
            self.viewModel.setMonthByIndex(monthIndex)
            self.viewModel.setSortType(type: .allReports)
            self.updateUI()
            self.calendarViewTapped?(monthIndex)
            self.monthEmpActionVM = MonthEmpActionViewModel(monthIndex: monthIndex)
        }

        if let vc = NavigationController.shared?.getCurrentViewController() {
            vc.present(chooseVC, animated: true, completion: nil)
        }
    }

    @IBAction func closeMonthButtonTapped(_ sender: UIButton) {
        showCloseMonthView()
    }

    @IBAction func addNewReport(_ sender: UIButton) {
        let vc = ViewSource.addMgrReportsScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = AddMgrReportViewModel(date: viewModel.getDate())
        vc.delegate = self

        if let currentVC = NavigationController.shared?.getCurrentViewController() {
            currentVC.present(vc, animated: true, completion: nil)
        }
    }

    func showCloseMonthView() {
        let vc = ViewSource.closeMonthReportView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = viewModel.getModelForCloseMonthView()

        vc.managerMonthClosed = {
            vc.absentTitle.text = self.monthEmpActionVM.getAbsenceTitle() ?? "0"
            vc.hoursTitle.text = self.monthEmpActionVM.getHoursTitle() ?? "0"
            vc.missingTitle.text = self.monthEmpActionVM.getMissingTitle()
            if CompaniesDataManager.shared.getSpecialClientType() == 3665 {
                vc.emailTextField.text = self.monthEmpActionVM.getEmployerEmial() ?? ""
            }
        }

        if monthEmpActionVM.getMissing() ?? 0 > 0 {
            NavigationController.shared?.showErrorView(error: ErrorObject(success: false, error_message: "MUST_REPORT_PAIRS_TITLE".localized, error_code: nil))
        } else {
            if let currentVC = NavigationController.shared?.getCurrentViewController() {
                currentVC.present(vc, animated: true, completion: nil)
            }
        }
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
        _ = NavigationController.shared?.popViewController(animated: false)
    }
    @IBAction func approveSelectedReports(_ sender: UIButton) {
        self.approveReports?()
    }
}

protocol MonthEmpActionViewDelegate: NSObjectProtocol {
    func createDayReport(_ report: GetMgrEmpReportsObj)
}

extension MonthEmpActionView: AddMgrReportViewDelegate {
    func updateDayReport(_ report: GetMgrEmpReportsObj) {
        delegate?.createDayReport(report)
    }
}
extension MonthEmpActionView: MonthEmpActionViewModelDelegate {
    func didLoadData() {
        setupCloseMonth()
    }
}
