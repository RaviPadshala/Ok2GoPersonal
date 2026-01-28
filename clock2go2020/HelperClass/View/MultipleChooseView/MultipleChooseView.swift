//
//  MultipleChooseView.swift
//  clock2go2020
//
//  Created by Admin on 4/14/20.
//

import UIKit

class MultipleChooseView: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmview: UIView!
    @IBOutlet weak var lbl_confirm: UILabel!
    
    var viewModel: MultipleChooseViewModel?
    var choosedTypes: ((_ titles: [String]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        setupTap()

        definesPresentationContext = true
    }

    func setupUI() {
        roundedView.roundCorners([.allCorners], radius: 25.0)
        roundedView.border(width: 0.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        tableView.roundCorners([.allCorners], radius: 25.0)

        chooseLabel.text = viewModel?.getChooseListTitle()
        
        self.lbl_confirm.text = "SAVE_EDIT".localized
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let cell = UINib(nibName: MultipleChooseCell.identifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: MultipleChooseCell.identifier)

        tableViewHeightConstraint.constant = viewModel?.getTableViewHeight() ?? 0
    }

    func setupTap() {
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(closeTap)
        
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        self.confirmview.addGestureRecognizer(confirmTap)
    }
    
    @objc func confirmTapped() {
        if let titles = viewModel?.getSelectedValues() {
            self.choosedTypes?(titles)
        }
        dismissView()
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        dismissView()
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension MultipleChooseView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberofRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: MultipleChooseCell.identifier) as? MultipleChooseCell, let model = viewModel?.getModelForCellAt(indexPath: indexPath) {
            cell.configure(model: model)
            cell.selectionStyle = .none

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.updateSelections(index: indexPath.row)
        tableView.reloadData()
    }

}
