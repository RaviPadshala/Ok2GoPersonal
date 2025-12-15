//
//  EmployeesView.swift
//  clock2go2020
//
//  Created by Admin on 4/11/20.
//

import UIKit

class EmployeesView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var filterRoundedView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var addEmployeeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var viewModel = EmployeesViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("EmployeesView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setupTableView()
        setupTaps()
        setupFilter()
        viewModel.delegate = self
    }

    func setupUI() {
        if CompaniesDataManager.shared.getSpecialClientType() == 3665 {
            addEmployeeButton.isHidden = true
        } else {
            addEmployeeButton.isHidden = false
            addEmployeeButton.roundCorners(.allCorners, radius: 17)
            addEmployeeButton.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
            addEmployeeButton.border(width: 3.5, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        }

        filterRoundedView.roundCorners([.bottomLeft, .bottomRight], radius: 30)
        filterRoundedView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        filterView.roundCorners(.allCorners, radius: 25)
        filterView.border(width: 0.7, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let cell = UINib(nibName: EmployeeTableViewCell.identifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: EmployeeTableViewCell.identifier)
    }

    func reloadView() {
        tableView.reloadData()
    }

    func setupTaps() {
        let filterTap = UITapGestureRecognizer(target: self, action: #selector(showFilterView))
        filterView.addGestureRecognizer(filterTap)
    }

    @objc func showFilterView() {
        let vc = ViewSource.chooseListView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = viewModel.getModelForChooseFilterTypeView()
        vc.choosedType = { _, title in
            self.viewModel.setFilterType(title: title)
            self.setupFilter()
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @IBAction func addEmployeeAction(_ sender: Any) {
        let vc = ViewSource.addEmployeeView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.confirmAction = { employee in
            self.viewModel.addEmployee(employee: employee)
        }
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showEditEmployeeView(employee: EmployeeObj?) {
        let vc = ViewSource.addEmployeeView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        if let emp = employee {
            vc.configure(model: AddEmployeeViewModel(employee: emp, isEditMode: true))
        }

        vc.confirmAction = { employee in
            self.viewModel.editEmployee(employee: employee)
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func setupFilter() {
        filterLabel.text = viewModel.getFilterTitle()
    }

}

extension EmployeesView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier) as? EmployeeTableViewCell, let model = viewModel.getModelForCellAt(indexPath: indexPath) {
            cell.configure(model: model)
            cell.editTapped = {
                self.viewModel.getEmployeesDetail(index: indexPath)
            }
            cell.selectionStyle = .none
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}

extension EmployeesView: EmployeesViewModelDelegate {
    func shouldReloadView() {
        self.reloadView()
    }

    func shouldShowEditView(_ employee: EmployeeObj?) {
        self.showEditEmployeeView(employee: employee)
    }

    func shouldShowConfirmView() {

    }
}
