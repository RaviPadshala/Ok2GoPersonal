//
//  SelectEmpsView.swift
//  clock2go2020
//
//  Created by Admin on 5/12/20.
//

import UIKit

class SelectEmpsView: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectAllLabel: UILabel!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nextChooseEmpsButton: UIButton!

    var viewModel = SelectEmpsViewModel()
    weak var delegate: SelectEmpsViewDelegate?

    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        nextChooseEmpsButton.isHidden = true
          NotificationCenter.default.addObserver(
              self,
              selector: #selector(keyboardWillShow(_:)),
              name: UIResponder.keyboardWillShowNotification,
              object: nil)
          NotificationCenter.default.addObserver(
              self,
              selector: #selector(keyboardWillHide(_:)),
              name: UIResponder.keyboardWillHideNotification,
              object: nil)
      }

      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)

          NotificationCenter.default.removeObserver(self)
      }

    override func viewDidLoad() {
        super.viewDidLoad()

        setLocalization()
        setupUI()
        setupTableView()
        setupViewModel()
        updateSelectAllButton()
        searchBar.delegate = self
        searchBar.keyboardType = .default
        searchBar.returnKeyType = .done
    }

    func setLocalization() {
        titleLabel.text = "Choose Employees".localized
        selectAllLabel.text = "Select all".localized
    }

    func setupUI() {
        roundedView.roundCorners([.allCorners], radius: 25.0)
        roundedView.border(width: 0.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        tableView.roundCorners([.allCorners], radius: 5.0)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.tableFooterView = UIView()

        let cell = UINib(nibName: SelectEmpsCellView.identifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: SelectEmpsCellView.identifier)

//        tableViewHeightConstraint.constant = viewModel?.getTableViewHeight() ?? 0
        refreshTableViewHeight()
    }

    func refreshTableViewHeight(animation: Bool = true) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.tableViewHeightConstraints.constant = self.viewModel.getTableViewHeight()
            self.view.layoutIfNeeded()
        }
    }

    private func setupViewModel() {
        viewModel.sectionCollapsed = { [weak self] (sectionIndex) in
            let sections = IndexSet(arrayLiteral: sectionIndex)
            self?.tableView.reloadSections(sections, with: .none)
        }
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func selectAllButtonAction(_ sender: Any) {
        self.viewModel.selectAll()

        self.tableView.reloadData()
        self.updateSelectAllButton()
    }

    func updateSelectAllButton() {
        if let image = viewModel.getSelectAllButtonImage() {
            selectAllButton.setImage(image, for: .normal)
        }
    }
    // When button "Search" pressed
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           print("end searching --> Close Keyboard")
           self.searchBar.endEditing(true)

       }
     @objc
        fileprivate func keyboardWillShow(_ notification: Notification) {
            let keyboardFrame = ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero

            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets

            UIView.animate(withDuration: 0.25) {
                self.tableView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }

        @objc
        fileprivate func keyboardWillHide(_ notification: Notification) {
            tableView.contentInset = .zero
        }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.userDidSelectEmployees(viewModel.getSelectedEmployees())
    }
}

protocol SelectEmpsViewDelegate: NSObjectProtocol {
    func userDidSelectEmployees(_ emps: [Int])
}

extension SelectEmpsView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if let text = searchBar.text, text.count > 0 {
                viewModel.filterList(filterText: text)
                tableView.reloadData()
            } else {
                viewModel.unfilterList()
                tableView.reloadData()
            }
            refreshTableViewHeight()
    }
}

extension SelectEmpsView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SelectEmpsCellView.identifier) as! SelectEmpsCellView

        if let model = viewModel.getModelForItemAt(section: indexPath.section, row: indexPath.row) {
            cell.config(viewModel: model)
        }

        cell.selectAction = {
            self.viewModel.selectEmployee(by: indexPath)
            self.tableView.reloadData()
            self.updateSelectAllButton()
            self.refreshTableViewHeight()
        }
        if viewModel.nextActivated() {
            nextChooseEmpsButton.isHidden = false
            print(viewModel.nextActivated())
        } else {
            nextChooseEmpsButton.isHidden = true
        }
        cell.selectionStyle = .none

        return cell
    }

    func expandAction(indexPath: IndexPath) {
        if viewModel.isItemExpandable(section: indexPath.section, row: indexPath.row) {
            // Expandable menu items should expand or collapse only.
            viewModel.toggleItem(section: indexPath.section, row: indexPath.row)

            tableView.reloadData()
            refreshTableViewHeight()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isItemExpandable(section: indexPath.section, row: indexPath.row) {
            expandAction(indexPath: indexPath)
        }
    }

}
