//
//  CityListView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 03.01.2020.
//

import UIKit

class CityListView: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var taskListView: UIView!
    @IBOutlet weak var selectTaskTitle: UILabel!
    @IBOutlet weak var taskListViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var taskListTableViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    var cityArr = [CitylistObj?]()
    var filterCityArr = [CitylistObj?]()
    
    var tapCity: ((_ city: CitylistObj) -> ())?
    var selectedCityID = Int()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setLocalizedStrings()
        setupTextField()
        setupTaps()
        setupTableView()
        self.getCityList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        taskListView.roundCorners([.allCorners], radius: 30.0)
        taskListView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        taskListTableView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
    }
    
    func setLocalizedStrings() {
        selectTaskTitle.text = "select_city".localized
        addTaskTextField.placeholder = "Search_a_city".localized
    }
    
    func setupTextField() {
        addTaskTextField.addCloseToolbar()
        addTaskTextField.setPaddingPoints(right: 30, left: 30)
        
        if #available(iOS 11.0, *) {
            addTaskTextField.smartInsertDeleteType = .no
        }
        
        addTaskTextField.delegate = self
        addTaskTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        addTaskTextField.roundCorners([.bottomLeft, .topLeft, .bottomRight, .topRight], radius: 25)
        addTaskTextField.border(width: 2, color: #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1))
        addTaskTextField.borderStyle = .none
    }
    
    private func setupTableView() {
        let cell = UINib(nibName: CityListTableViewCell.identifier, bundle: nil)
        taskListTableView.register(cell, forCellReuseIdentifier: CityListTableViewCell.identifier)
        
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
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}

extension CityListView {
    
    @objc func keyboardWillShow() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 3) {
            self.taskListViewCenterYConstraint.priority = UILayoutPriority(rawValue: 250)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.taskListViewCenterYConstraint.priority = UILayoutPriority(rawValue: 750)
            self.view.layoutIfNeeded()
        }
    }
    
}



extension CityListView: UITextFieldDelegate {
    
    func filterModels(searchText: String) -> [CitylistObj?] {
        return self.cityArr.filter { model in
            model!.city!.lowercased().contains(searchText.lowercased())
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            self.filterCityArr = filterModels(searchText: text)
            taskListTableView.reloadData()
        } else {
            self.filterCityArr = self.cityArr
            taskListTableView.reloadData()
        }
    }
    
}

extension CityListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterCityArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.identifier, for: indexPath) as! CityListTableViewCell
        cell.selectionStyle = .none
        
        cell.contentView.alpha = 1.0
        if let dict = self.filterCityArr[indexPath.row]{
            cell.taskTitle.text = dict.city ?? ""
            if dict.ID! == self.selectedCityID{
                cell.contentView.alpha = 0.5
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dict = self.filterCityArr[indexPath.row]{
            if dict.ID! != self.selectedCityID{
                dismissView()
                self.tapCity?(dict)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CityListView{
    
    func getCityList(){
        self.cityArr.removeAll()
        let arr = CompaniesDataManager.shared.getCityList()
        let sortedCitiesReverse = arr.sorted { $0!.city! < $1!.city! }
        self.cityArr = sortedCitiesReverse
        self.filterCityArr = self.cityArr
        self.taskListTableView.reloadData()
    }
    
}
