//
//  TaskListView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 03.01.2020.
//

import UIKit

class SelectTheraphyTypeView: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var taskListView: UIView!
    @IBOutlet weak var selectTaskTitle: UILabel!
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    //    weak var delegate: ChooseTaskDelegate?
    
    var arr = ["Medical".localized, "Group".localized, "Projective".localized, "Individual".localized]
    var theraphyEventTypeArr: [TherapyeventTypesObj?]?
    var didSelectTherapy: ((_ type: Int) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setLocalizedStrings()
        setupTaps()
        setupTableView()
        
        if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
            let arr = CompaniesDataManager.shared.getTherapyeventTypes()
            self.theraphyEventTypeArr = arr.filter({ $0?.TransType == "\(UserDefaultsManager.holocustLastLoginType - 3)" })
            self.taskListTableView.reloadData()
        }
    }
    
    func setupUI() {
        taskListView.roundCorners([.allCorners], radius: 30.0)
        taskListView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        taskListTableView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
    }
    
    func setLocalizedStrings() {
        selectTaskTitle.text = "Choose_Therapy".localized
    }
    
    private func setupTableView() {
        let cell = UINib(nibName: TaskListTableViewCell.identifier, bundle: nil)
        taskListTableView.register(cell, forCellReuseIdentifier: TaskListTableViewCell.identifier)
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
    }
    
    
    func setupTaps() {
        let closeTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        closeImage.addGestureRecognizer(closeTap)
        
        let backgroundTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(backgroundTap)
    }
    
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SelectTheraphyTypeView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.identifier, for: indexPath) as! TaskListTableViewCell
        cell.selectionStyle = .none
        cell.taskTitle.text = self.arr[indexPath.row]
        cell.subtaskButton.isHidden = true
        cell.subtaskIndicatorView.isHidden = true
        
        cell.contentView.alpha = 0.5
        
        if let filteredUsers = self.theraphyEventTypeArr{
            if indexPath.row == 0 {
                if filteredUsers.contains(where: { $0?.TherapyType == "1"}) {
                    cell.contentView.alpha = 1.0
                }
            }else if indexPath.row == 1 {
                if filteredUsers.contains(where: { $0?.TherapyType == "2"}) {
                    cell.contentView.alpha = 1.0
                }
            }else if indexPath.row == 2 {
                if filteredUsers.contains(where: { $0?.TherapyType == "3"}) {
                    cell.contentView.alpha = 1.0
                }
            }else{
                if filteredUsers.contains(where: { $0?.TherapyType == "4"}) {
                    cell.contentView.alpha = 1.0
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let filteredUsers = self.theraphyEventTypeArr{
            if indexPath.row == 0 {
                if filteredUsers.contains(where: { $0?.TherapyType == "1"}) {
                    UserDefaultsManager.holocustLastTheraphyType = 1
                    self.dismiss(animated: true, completion: nil)
                    self.didSelectTherapy?(UserDefaultsManager.holocustLastTheraphyType)
                }
            }else if indexPath.row == 1 {
                if filteredUsers.contains(where: { $0?.TherapyType == "2"}) {
                    UserDefaultsManager.holocustLastTheraphyType = 2
                    self.dismiss(animated: true, completion: nil)
                    self.didSelectTherapy?(UserDefaultsManager.holocustLastTheraphyType)
                }
            }else if indexPath.row == 2 {
                if filteredUsers.contains(where: { $0?.TherapyType == "3"}) {
                    UserDefaultsManager.holocustLastTheraphyType = 3
                    self.dismiss(animated: true, completion: nil)
                    self.didSelectTherapy?(UserDefaultsManager.holocustLastTheraphyType)
                }
            }else{
                if filteredUsers.contains(where: { $0?.TherapyType == "4"}) {
                    UserDefaultsManager.holocustLastTheraphyType = 4
                    self.dismiss(animated: true, completion: nil)
                    self.didSelectTherapy?(UserDefaultsManager.holocustLastTheraphyType)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
}
