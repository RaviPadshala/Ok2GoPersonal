//
//  TrackingReportActionView.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/1/20.
//

import UIKit

class TrackingReportActionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addReportButton: UIButton!
    @IBOutlet weak var addTravelButton: UIButton!
    @IBOutlet weak var emailReportButton: UIButton!
    @IBOutlet weak var sortingView: UIView!
    @IBOutlet weak var titleSortingView: UILabel!
    @IBOutlet weak var titleCalendarView: UILabel!
    @IBOutlet weak var calendarView: UIView!

    var viewModel: ReportActionViewModel!

    var sortingListViewTapped: ((_ type: SortingBy) -> Void)?
    var calendarViewTapped: ((_ index: Int) -> Void)?

    @IBAction func backButtonTapped(_ sender: Any) {
        _ = NavigationController.shared?.popViewController(animated: false)
    }

    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("TrackingReportActionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setupTaps()
    }

    func setupUI() {
        addTravelButton.roundCorners(.allCorners, radius: 16)
        addTravelButton.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1))
        addTravelButton.setTitle("הוסף נסיעות", for: .normal)

        emailReportButton.roundCorners(.allCorners, radius: 16)
        emailReportButton.border(width: 1, color: #colorLiteral(red: 0.1137254902, green: 0.3019607843, blue: 0.4352941176, alpha: 1))
        emailReportButton.setTitle("שלח דו״ח במייל", for: .normal)

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

        titleSortingView.text = viewModel.getSortTypeString()
        titleCalendarView.text = viewModel.getMonthString()

        addReportButton.isHidden = !viewModel.shouldShowCloseMonthButton()

    }

    func setupTaps() {
        let tapSortingListView = UITapGestureRecognizer.init(target: self, action: #selector(selectTappedSorting))
        sortingView.addGestureRecognizer(tapSortingListView)

        let tapCalendarView = UITapGestureRecognizer.init(target: self, action: #selector(selectTappedCalendar))
        calendarView.addGestureRecognizer(tapCalendarView)
    }
    @objc func selectTappedSorting() {
        print("tap sorting")

        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve
//
//        let top = stackView.frame.origin.y
//        let left = sortingView.frame.origin.x + stackView.frame.origin.x
//        let width = sortingView.frame.size.width
//
//        let model = SortingListViewModel(type: .filter)
//
//        chooseVC.configure(viewModel: model, top: top, left: left, width: width)
//
//        chooseVC.choosedType = { index, title in
//            if let type = SortingBy.withTitle(title) {
//                self.viewModel.setSortType(type: type)
//                self.updateUI()
//                self.sortingListViewTapped?(type)
//            }
//        }

        if let vc = NavigationController.shared?.getCurrentViewController() {
            vc.present(chooseVC, animated: true, completion: nil)
        }
    }

    @objc func selectTappedCalendar() {
        print("tap calendar")

        let chooseVC = ViewSource.sortingListView()
        chooseVC.modalPresentationStyle = .overCurrentContext
        chooseVC.modalTransitionStyle = .crossDissolve

//        let top = stackView.frame.origin.y
//        let left = calendarView.frame.origin.x + stackView.frame.origin.x
//        let width = calendarView.frame.size.width
//
//        let model = SortingListViewModel(type: .month)
//
//        chooseVC.configure(viewModel: model, top: top, left: left, width: width)
//
//        chooseVC.choosedType = { index, title in
//            let monthIndex = Calendar.current.monthSymbols.firstIndex(of: title) ?? 0
//            self.viewModel.setMonthByIndex(monthIndex)
//            self.viewModel.setSortType(type: .allReports)
//            self.updateUI()
//            self.calendarViewTapped?(monthIndex)
//        }

        if let vc = NavigationController.shared?.getCurrentViewController() {
            vc.present(chooseVC, animated: true, completion: nil)
        }
    }

    @IBAction func sendEmailButtonTapped(_ sender: UIButton) {
        let vc = ViewSource.emailReportView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        // vc.viewModel = viewModel.getModelForSendEmailView()

        if let currentVC = NavigationController.shared?.getCurrentViewController() {
            currentVC.present(vc, animated: true, completion: nil)
        }
    }
}
