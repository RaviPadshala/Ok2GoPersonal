//
//  DailyWorkScheduleView.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 04.08.2022.
//

import UIKit

class DayWorkScheduleView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewModel: DayWorkScheduleViewModel?
    
    var onSelectItem: ((Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("DayWorkScheduleView", owner: self, options: nil)

        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        prepareTableView()
    }
    
    func addViewModel(_ viewModel: DayWorkScheduleViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.titleString
        tableView.reloadData()
    }
    
    func reloadInfo() {
        viewModel?.reloadInfo()
        titleLabel.text = viewModel?.titleString ?? ""
        tableView.reloadData()
    }
}

extension DayWorkScheduleView: UITableViewDelegate, UITableViewDataSource {
    
    private func prepareTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }

        tableView.register(UINib(nibName: String.init(describing: DayWorkScheduleCell.self), bundle: nil), forCellReuseIdentifier: String.init(describing: DayWorkScheduleCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerViewModel = viewModel?.headerViewModel {
            let headerView = Bundle.main.loadNibNamed(String.init(describing: DayWorkScheduleHeaderView.self), owner: self, options: nil)?.first as? DayWorkScheduleHeaderView
            headerView?.fill(with: headerViewModel)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel = viewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: DayWorkScheduleCell.self)) as! DayWorkScheduleCell
            cell.fill(with: viewModel.cellViewModels[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectItem?(indexPath.row)
    }
}
