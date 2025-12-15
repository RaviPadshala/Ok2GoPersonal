//
//  ChooseListView.swift
//  clock2go2020
//
//  Created by Admin on 2/9/20.
//

import UIKit

protocol ChooseListViewDelegate: NSObjectProtocol {
    func didSelectItem(at index: Int, title: String)
}

class ChooseListView: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    var viewModel: ChooseListViewModel?
    var choosedType: ((_ index: Int, _ title: String) -> Void)?
    weak var delegate: ChooseListViewDelegate?

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalized()
        setupUI()
        setupTableView()
    }

    func setupLocalized() {
        chooseLabel.text = viewModel?.getChooseListTitle()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHeightConstraint.constant = viewModel?.getTableViewHeight() ?? 0
    }
    
    func setupUI() {
        roundedView.roundCorners([.allCorners], radius: 25.0)
        roundedView.border(width: 0.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        tableView.roundCorners([.allCorners], radius: 25.0)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let cell = UINib(nibName: ChooseListCell.identifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: ChooseListCell.identifier)

        tableViewHeightConstraint.constant = viewModel?.getTableViewHeight() ?? 0
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ChooseListView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberofRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseListCell.identifier) as! ChooseListCell
        cell.title.text = viewModel?.getCellTitle(index: indexPath.row)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = viewModel?.getCellTitle(index: indexPath.row) ?? ""
        choosedType?(indexPath.row, title)
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true) {
                self.delegate?.didSelectItem(at: indexPath.row, title: title)
            }
        })
    }
}
