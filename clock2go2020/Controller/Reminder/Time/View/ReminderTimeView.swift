//
//  ReminderTimeView.swift
//  clock2go2020
//
//  Created by Admin on 2/11/20.
//

import UIKit


class ReminderTimeView: UIView {
    


    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reminderDaysView: UIView!
    @IBOutlet weak var reminderDaysViewTitle: UILabel!

    var viewModel = ReminderTimeViewModel()

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
        Bundle.main.loadNibNamed("ReminderTimeView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        setupUI()
        setupLocalized()
        setupTableView()
        setupTap()
    }

    func setupUI() {
        reminderDaysView.roundCorners([.allCorners], radius: 34)
    }

    func setupLocalized() {
        reminderDaysViewTitle.text = "Add new reminder".localized
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: "ReminderTimeViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ReminderTimeViewCell.identifier)
    }

    func setupTap() {
        if UserDefaultsManager.selectedDay == 0{
            let tap = UITapGestureRecognizer(target: self, action: #selector(showDaysReminderScreenForAllDays))
            reminderDaysView.addGestureRecognizer(tap)
        }else{
            let tap = UITapGestureRecognizer(target: self, action: #selector(showDaysReminderScreen))
            reminderDaysView.addGestureRecognizer(tap)
        }
    }

    @objc func showDaysReminderScreen() {
        CompanywiseReminderHelper.shared.addCompanywiseReminder(reminder: CompanywiseReminder(clientId: CompaniesDataManager.shared
            .getClienId(), clientName: CompaniesDataManager.shared.getClientName(),id: UUID().uuidString, loginNotificationId: UUID().uuidString, loginTime: "" , isLogin: false, logoutNotificationId: UUID().uuidString, logoutTime: "", isLogout: false, weekday: UserDefaultsManager.selectedDay ?? 0))
        tableView.reloadData()
        scrollToBottom()
    }
    
    @objc func showDaysReminderScreenForAllDays() {
        let everyDayId = UUID().uuidString
        for weekday in 1...7{
            CompanywiseReminderHelper.shared.addCompanywiseReminder(reminder: CompanywiseReminder(clientId: CompaniesDataManager.shared
                .getClienId(), clientName: CompaniesDataManager.shared.getClientName(),everyDayId:everyDayId,isEveryday: true,id: UUID().uuidString, loginNotificationId: UUID().uuidString, loginTime: "" , isLogin: false, logoutNotificationId: UUID().uuidString, logoutTime: "", isLogout: false, weekday: weekday))
        }
        
        
        tableView.reloadData()
        scrollToBottom()
    }
    
    func scrollToBottom(){
        if UserDefaultsManager.selectedDay == 0{
            if let companies = CompanywiseReminderHelper.shared.getSameReminderForEveryDay(){
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: companies.count-1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }else{
            if let companies = CompanywiseReminderHelper.shared.getCompanywiseReminder(clinetId: CompaniesDataManager.shared.getClienId() ?? 0, weekday:     UserDefaultsManager.selectedDay ?? 0){
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: companies.count-1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }

        
    }

}


extension ReminderTimeView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTimeViewCell.identifier, for: indexPath) as? ReminderTimeViewCell {
        
            let cellViewModel = self.viewModel.getModelFor(index: indexPath.row)
            cell.config(viewModel: cellViewModel)
            cell.switchValueChanged = { reminder in
                if UserDefaultsManager.selectedDay == 0{
                    print(self.viewModel.getReminderForAll(index: indexPath.row) ?? "")
                    self.viewModel.updateNotificationForAll(index: indexPath.row, time: reminder.time, isLogin: reminder.isOn, loginOrLogoutflag: true)
                }else{
                    
                    self.viewModel.updateNotification(index: indexPath.row, time: reminder.time, isLogin: reminder.isOn, loginOrLogoutflag: true)
                }
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            cell.switchValueChangedLogout = { reminder in
                if UserDefaultsManager.selectedDay == 0{
                    
                    self.viewModel.updateNotificationForAll(index: indexPath.row, time: reminder.timeLogout, isLogin: reminder.isOnLogout, loginOrLogoutflag: false)
                }else{
                    self.viewModel.updateNotification(index: indexPath.row, time: reminder.timeLogout, isLogin: reminder.isOnLogout, loginOrLogoutflag: false)

                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            if UserDefaultsManager.selectedDay == 0{
                if CompanywiseReminderHelper.shared.checkIfdayHasSameEmptyReminderForAll(){
                    reminderDaysView.isHidden = true
                }else{
                    reminderDaysView.isHidden = false
                }
            }else{
                if CompanywiseReminderHelper.shared.checkIfdayHasReminderIsEmpty(){
                    reminderDaysView.isHidden = true
                }else{
                    reminderDaysView.isHidden = false
                }
            }
            
            return cell
        }

        return UITableViewCell()
    }
 
  

}
