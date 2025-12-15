//
//  ReminderDaysView.swift
//  clock2go2020
//
//  Created by Admin on 2/11/20.
//

import UIKit

class ReminderDaysView: UIView {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var saveTitle: UILabel!

    var viewModel = ReminderDaysViewModel()

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
        Bundle.main.loadNibNamed("ReminderDaysView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
      
        setupUI()
        setupLocalized()
        setupTableView()
        setupTap()
    }
    
    func refresh(){
        tableView.reloadData()
    }
    
    
    func setupUI() {
        saveView.roundCorners([.allCorners], radius: 34)
    }

    func setupLocalized() {
        saveTitle.text = "SAVE".localized
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: "ReminderDaysViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ReminderDaysViewCell.identifier)
    }

    func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(saveTapped))
        saveView.addGestureRecognizer(tap)
    }

    @objc func saveTapped() {
        viewModel.saveNewSelectedDays()
    }

}

extension ReminderDaysView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReminderDaysViewCell.identifier, for: indexPath) as? ReminderDaysViewCell {
            cell.config(viewModel: viewModel.getModelFor(index: indexPath.row))
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.changeDaySelection(index: indexPath.row)
//        tableView.reloadData()
        
        let vc = ViewSource.reminderTimeScreen()
        UserDefaultsManager.selectedDay = indexPath.row
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

}
