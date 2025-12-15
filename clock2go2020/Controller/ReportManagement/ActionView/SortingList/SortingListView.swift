//
//  SortingListView.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/19/20.
//

import UIKit

class SortingListView: UIViewController {

    // MARK: Outlet
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var viewImage: UIImageView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableVIewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthViewConstraint: NSLayoutConstraint!

    var viewModel: SortingListViewModel?
    var choosedType: ((_ index: Int, _ title: String, _ taskData: TaskListItem?) -> Void)?

    var dismisSelfSubview: (() -> ())?
    
    var top: CGFloat = 0
    var left: CGFloat = 0
    var width: CGFloat = 0
    var tableHeight: CGFloat = 0
    
    var theraphyEventTypeArr: [TherapyeventTypesObj?]?

    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupTap()
        setupUI()
                
        if let model = self.viewModel, model.type == .holocustTherapy{
            if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
                let arr = CompaniesDataManager.shared.getTherapyeventTypes()
                self.theraphyEventTypeArr = arr.filter({ $0?.TransType == "\(UserDefaultsManager.holocustLastLoginType - 3)" })
                self.tableView.reloadData()
            }
        }
        
    }

    override func viewWillLayoutSubviews() {
        topViewConstraint.constant = top
        leftViewConstraint.constant = left
        widthViewConstraint.constant = width
        tableVIewHeightConstraint.constant = tableHeight

        viewTitle.text = viewModel?.getTitle()
        viewImage.image = viewModel?.getImage()

        headerView.isHidden = !(viewModel?.shouldShowHeaderView() ?? false)
    }

    // MARK: Property
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let cell = UINib(nibName: SortingListTableViewCell.identifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: SortingListTableViewCell.identifier)
    }

    func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)

        let headerTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        headerView.addGestureRecognizer(headerTap)
    }

    func setupUI() {
        contentView.roundCorners(.allCorners, radius: 16.0)
        contentView.border(width: 1, color: #colorLiteral(red: 0.06274509804, green: 0.2823529412, blue: 0.462745098, alpha: 1))

        tableView.roundCorners(.allCorners, radius: 16.0)
    }

    func configure(viewModel: SortingListViewModel, top: CGFloat, left: CGFloat, width: CGFloat) {
        self.viewModel = viewModel

        self.top = top
        self.left = left
        self.width = width
        self.tableHeight = viewModel.getTableViewHeight()
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SortingListView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortingListTableViewCell.identifier) as! SortingListTableViewCell
        print("viewModel", viewModel?.getCellTitle(index: indexPath.row) ?? "")
        
        
        if let model = self.viewModel{
            let titleStr = model.getCellTitle(index: indexPath.row)
            cell.titleLabel.text = titleStr
            
            if model.type == .holocust {
                if titleStr == "Clinic_treatment".localized{
                    if model.getOfficeOptionEnable(){
                        cell.contentView.alpha = 1
                    }else{
                        cell.contentView.alpha = 0.5
                    }
                }
                
                if titleStr == "On_site_treatment".localized{
                    if model.getOnSiteOptionEnable(){
                        cell.contentView.alpha = 1
                    }else{
                        cell.contentView.alpha = 0.5
                    }
                }
                
                if titleStr == "Online".localized{
                    if model.getOnlineOptionEnable(){
                        cell.contentView.alpha = 1
                    }else{
                        cell.contentView.alpha = 0.5
                    }
                }
            }
        }
        
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let model = self.viewModel{
            let titleStr = model.getCellTitle(index: indexPath.row)
            if model.type == .holocust {
                if titleStr == "Clinic_treatment".localized{
                    if model.getOfficeOptionEnable(){
                        choosedType?(3, titleStr, nil)
                        self.dismissView()
                        self.dismisSelfSubview?()
                    }
                }
                
                if titleStr == "On_site_treatment".localized{
                    if model.getOnSiteOptionEnable(){
                        choosedType?(1, titleStr, nil)
                        self.dismissView()
                        self.dismisSelfSubview?()
                    }
                }
                
                if titleStr == "Online".localized{
                    if model.getOnlineOptionEnable(){
                        choosedType?(2, titleStr, nil)
                        self.dismissView()
                        self.dismisSelfSubview?()
                    }
                }
            }else if model.type == .holocustTherapy {
                if let filteredUsers = self.theraphyEventTypeArr{
                    if indexPath.row == 0 {
                        if filteredUsers.contains(where: { $0?.TherapyType == "1"}) {
                            choosedType?(1, titleStr, nil)
                            self.dismissView()
                            self.dismisSelfSubview?()
                        }
                    }else if indexPath.row == 1 {
                        if filteredUsers.contains(where: { $0?.TherapyType == "2"}) {
                            choosedType?(2, titleStr, nil)
                            self.dismissView()
                            self.dismisSelfSubview?()
                        }
                    }else if indexPath.row == 2 {
                        if filteredUsers.contains(where: { $0?.TherapyType == "3"}) {
                            choosedType?(3, titleStr, nil)
                            self.dismissView()
                            self.dismisSelfSubview?()
                        }
                    }else{
                        if filteredUsers.contains(where: { $0?.TherapyType == "4"}) {
                            choosedType?(4, titleStr, nil)
                            self.dismissView()
                            self.dismisSelfSubview?()
                        }
                    }
                }
            }else if model.type == .holocustEvent {
                choosedType?(indexPath.row, titleStr, self.viewModel!.taskListItems[indexPath.row])
                self.dismissView()
                self.dismisSelfSubview?()
            }else{
                choosedType?(indexPath.row, titleStr, nil)
                self.dismissView()
                self.dismisSelfSubview?()
            }
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let model = self.viewModel, model.type == .holocustTherapy {
            if let filteredUsers = self.theraphyEventTypeArr{
                if indexPath.row == 0 {
                    if filteredUsers.contains(where: { $0?.TherapyType == "1"}) {
                        return 50.0
                    }
                }else if indexPath.row == 1 {
                    if filteredUsers.contains(where: { $0?.TherapyType == "2"}) {
                        return 50.0
                    }
                }else if indexPath.row == 2 {
                    if filteredUsers.contains(where: { $0?.TherapyType == "3"}) {
                        return 50.0
                    }
                }else{
                    if filteredUsers.contains(where: { $0?.TherapyType == "4"}) {
                        return 50.0
                    }
                }
            }
            
            return 0.0
        }
        return viewModel?.getCellHeight(index: indexPath.row) ?? 30.0
    }

}
