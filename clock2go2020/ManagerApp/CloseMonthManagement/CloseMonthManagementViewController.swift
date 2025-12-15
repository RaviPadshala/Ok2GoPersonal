//
//  CloseMonthManagementViewController.swift
//  clock2go2020
//
//  Created by Gleb on 22.09.2020.
//

import UIKit
import  Foundation

class CloseMonthManagementViewController: UIViewController, MonthEmpReportsViewModelDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortingView: UIView!
    @IBOutlet weak var titleSortingView: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var titleCalendarView: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var approvalStackView: UIStackView!
    @IBOutlet weak var employeerStackView: UIStackView!
    @IBOutlet weak var approveAllReportsButton: UIButton!
    @IBOutlet weak var titleScreenLabel: UILabel!

    @IBOutlet weak var bgApprovalView: UIView!
    @IBOutlet weak var roundedApprovalView: UIView!
    @IBOutlet weak var approvalTextLabel: UILabel!
    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var missingLabel: UILabel!
    @IBOutlet weak var absenceLabel: UILabel!
    @IBOutlet weak var closeByEmpLabel: UILabel!
    @IBOutlet weak var closeDateLabel: UILabel!
    @IBOutlet weak var employerLabel: UILabel!
    @IBOutlet weak var employerApproval: UILabel!
    @IBOutlet weak var mgrApproval: UILabel!

    var viewModel = CloseMonthMgrViewModel()

    // MARK: Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)

        let screenFrame = UIScreen.main.bounds
        self.view.frame = CGRect(x: 0, y: 0, width: screenFrame.height, height: screenFrame.width)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        /// delegate
        viewModel.delegate = self

        setupTableView()
        setupTaps()
        setupLocalized()
        setupUI()
        updateUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    // MARK: - Private func
    private func setupUI() {
        sortingView.roundCorners(.allCorners, radius: 16)
        sortingView.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1))

        calendarView.roundCorners(.allCorners, radius: 16)
        calendarView.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1))

        bgApprovalView.isHidden = true
        roundedApprovalView.roundCorners([.topRight, .topLeft], radius: 30.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }

    private func setupLocalized() {
        titleScreenLabel.text = ( "CLOSE_MANAGER_REPORTS_TITLE".localized + ":")
        approveAllReportsButton.setTitle("APPROVE_ALL".localized, for: .normal)
        approvalTextLabel.text = "APPROVE_ALL_REPORTS".localized

        nameLabel.text = "NAME".localized
        totalLabel.text = "TOTAL_HOURS".localized
        missingLabel.text =  "MISSING".localized
        absenceLabel.text = "ABSENCES".localized
        closeByEmpLabel.text = "CLOSE_EMP_DATE".localized
        closeDateLabel.text = "CLOSE_MGR_DATE".localized
        employerLabel.text = "EMPLOYER_NAME".localized
        employerApproval.text = "APPROVAL_STATUS".localized
        mgrApproval.text = "APPROVAL_MGR".localized
    }
    // Setup Table View
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // init xib cell
        let nibCell = UINib(nibName: CloseMonthTableViewCell.identifier, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: CloseMonthTableViewCell.identifier)
    }
    func updateUI() {
        titleSortingView.text = viewModel.getSortTypeString()
        titleCalendarView.text = viewModel.getMonthString()
    }

    private func setupTaps() {
        let tapSortingListView = UITapGestureRecognizer.init(target: self, action: #selector(selectTappedSorting))
        sortingView.addGestureRecognizer(tapSortingListView)

        let tapCalendarView = UITapGestureRecognizer.init(target: self, action: #selector(selectTappedCalendar))
        calendarView.addGestureRecognizer(tapCalendarView)

        let tapBgApprovView = UITapGestureRecognizer.init(target: self, action: #selector(bgApprovViewTapped))
        bgApprovalView.addGestureRecognizer(tapBgApprovView)
    }

    @objc func bgApprovViewTapped() {
        bgApprovalView.isHidden = true
    }

    @objc func selectTappedSorting() {

        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve

        let top = stackView.frame.origin.y
        let left = sortingView.frame.origin.x +  stackView.frame.origin.x
        let width = sortingView.frame.size.width

        let model = SortingListViewModel(type: .mgrFilter)

        chooseVC.configure(viewModel: model, top: top, left: left, width: width)

        chooseVC.choosedType = { _, title, _ in
            if let type = SortingStatusMonth.withTitle(title) {
                self.viewModel.setSortType(type: type)
                self.viewModel.filterList(reportFilterType: type)
                self.updateUI()
                self.tableView.reloadData()
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
        let left = calendarView.frame.origin.x +  stackView.frame.origin.x
        let width = calendarView.frame.size.width

        let model = SortingListViewModel(type: .shlomitMonth)

        chooseVC.configure(viewModel: model, top: top, left: left, width: width)

        chooseVC.choosedType = { _, title, _ in
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: UserDefaultsManager.appleLanguagesNew.first ?? "en")

            let monthIndex = calendar.monthSymbols.firstIndex(of: title) ?? 0
            self.viewModel.unfilterList()
            self.viewModel.setMonthByIndex(monthIndex)
            self.viewModel.setSortType(type: .showAll)
            self.updateUI()
            self.viewModel.loadData()
            self.tableView.reloadData()
        }

        if let vc = NavigationController.shared?.getCurrentViewController() {
            vc.present(chooseVC, animated: true, completion: nil)
        }
    }

    @IBAction func approveAllReports(_ sender: Any) {
        let vc = ViewSource.approveDialogView()
        NavigationController.shared?.present(vc, animated: true, completion: nil)
        textStatus = "APPROVE_ALL_REPORTS".localized

        let meQueue = DispatchQueue(label: "test")

        vc.approveAllReports = {
            meQueue.sync {
                self.viewModel.approveAllReports()
            }

            meQueue.sync {
                self.viewModel.loadData()
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = NavigationController.shared?.popViewController(animated: false)
    }
}

// MARK: EXtension and protocols
extension CloseMonthManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNemOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: CloseMonthTableViewCell.identifier, for: indexPath) as? CloseMonthTableViewCell,

           let cellViewModel = viewModel.getModelForItemAt(index: indexPath.row) {
            cell.configure(viewModel: cellViewModel)
            cell.selectionStyle = .none
            cell.tag  = indexPath.row
            cell.delegate = self
            cell.empId = viewModel.getModelForItemAt(index: indexPath.row)?.getEmpId() ?? 0

            cell.empNameTapped = { [self] in
                let vc = ViewSource.mothEmpReportsScreen()
                let id = cell.viewModel.getEmpId()
                let empName = cell.viewModel.getEmpName()
                vc.viewModel.delegate = self
                UserDefaultsManager.empIdMgrReport = id
                vc.viewModel.loadData(empId: id)
                vc.empName = empName
                NavigationController.shared?.pushViewController(vc, animated: true)
            }

          if  !viewModel.shouldShowShlomitInfo() {
                cell.shlomitName.isHidden = false
                cell.shlomitApprovel.isHidden = false
                approvalStackView.isHidden = false
                employeerStackView.isHidden = false
            } else {
                cell.shlomitName.isHidden = true
                cell.shlomitApprovel.isHidden = true
                approvalStackView.isHidden = true
                employeerStackView.isHidden = true
            }

            cell.showApprovalTapped = { [self] in
                let status = cell.viewModel.getEmployerApprovalStatus()
                let date = cell.viewModel.getShlomitAppDate()

                switch status {
                case 1:
                    let id = cell.viewModel.getEmpId()
                    viewModel.getAmutaSignedPictures(empId: id)

                    guard let model = viewModel.getImage() else { return }

                    DispatchQueue.main.async { [self] in
                        let imageView = ImageView(frame: self.view.frame)
                        imageView.viewModel = model
                        self.view.addSubview(imageView)
                    }
                    break
                case 2:
                    bgApprovalView.isHidden = false
                    approvalTextLabel.text = "EMP_APPOVAL_DATE".localized + (date)
                    break
                case 3 :
                    bgApprovalView.isHidden = false
                    approvalTextLabel.text = "EMP_REJECT_DATE".localized + (date)
                    break
                default:
                    break
                }
            }

            return cell
        }
        return UITableViewCell()
    }
}

extension CloseMonthManagementViewController: CloseMonthManagemenViewModelDelegate {
    func didLoadData() {
            self.tableView.reloadData()
    }
}

extension CloseMonthManagementViewController: CloseMonthDelegate {
    func setStatus(close: Int, tag: Int) {
        let status = close

        let vc = ViewSource.approveDialogView()
        NavigationController.shared?.present(vc, animated: true, completion: nil)

        vc.didSelect  = {
            self.viewModel.setStatusForEmp(status: status, tag: tag )
            self.viewModel.loadData()
            self.tableView.reloadData()
        }
    }
}

protocol CloseMonthReportsDelegate: AnyObject {
    func setCloseMonthStatus(status: Int)
}
