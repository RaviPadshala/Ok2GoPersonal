//
//  DailyStatusView.swift
//  clock2go2020
//
//  Created by MacBookPro on 4/10/20.
//

import UIKit

class DailyStatusView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workingView: UIView!
    @IBOutlet weak var backgroundSortingView: UIView!
    @IBOutlet weak var sortingView: UIView!
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet weak var workingRoundedView: UIView!
    @IBOutlet weak var circleView: circleView!
    @IBOutlet weak var dailyStatsView: UIView!
    @IBOutlet weak var empNumberLabel: UILabel!
    @IBOutlet weak var empFilterLabel: UILabel!
    @IBOutlet weak var backgroundWorkingView: UIView!

    var viewModel = DailyStatsDetailsViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("DailyStatusView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setupTableView()
        setupTaps()
        viewModel.delegate = self
        circleView.delegate = self
    }

    func setupUI() {
        backgroundSortingView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
        backgroundSortingView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        sortingView.roundCorners(.allCorners, radius: 23)
        sortingView.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2823529412, blue: 0.462745098, alpha: 1))

        backgroundWorkingView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
        backgroundWorkingView.shadow(CGSize(width: 0, height: 3), opacity: 0.1, radius: 1.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        workingRoundedView.roundCorners([.bottomRight, .bottomLeft], radius: 70)
        workingRoundedView.shadow(CGSize(width: 0, height: 3), opacity: 0.1, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        dailyStatsView.roundCorners(.allCorners, radius: 36)
        dailyStatsView.shadow(CGSize(width: 0, height: 3), opacity: 0.4, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        circleView.roundCorners(.allCorners, radius: 72)
        circleView.shadow(CGSize(width: 0, height: 3), opacity: 0.2, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

         let nib = UINib(nibName: "DailyStatusTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DailyStatusTableViewCell.identifier)
    }

    func reloadView() {
        tableView.reloadData()

        empNumberLabel.text = viewModel.getNumberOfEmployees().description
        empNumberLabel.textColor = viewModel.getNumberOfEmployeesColor()
        empFilterLabel.text = viewModel.getFilterTitle()
        sortingLabel.text = viewModel.getSortingTitle()
    }

    func setupTaps() {
        let filterTap = UITapGestureRecognizer(target: self, action: #selector(showFilterView))
        sortingView.addGestureRecognizer(filterTap)
    }

    @objc func showFilterView() {
        let vc = ViewSource.chooseListView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = viewModel.getModelForChooseDepartmentView()
        vc.choosedType = { _, title in
            self.viewModel.setDepartment(departmentTitle: title)
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

}

extension DailyStatusView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.getNumbersOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DailyStatusTableViewCell.identifier) as? DailyStatusTableViewCell, let model = viewModel.getModelForCellAt(indexPath: indexPath) {
            cell.configure(model: model)
            return cell
        }

        return UITableViewCell()
    }
}
extension DailyStatusView: DailyStatsDetailsViewModelDelegate {
    func shouldReloadView() {
        self.reloadView()
    }

}

extension DailyStatusView: circleViewDelegate {
    func selectedType(_ type: typeCircle?) {
        viewModel.setFilterType(filter: type)
    }
}
