//
//  TaskListView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 03.01.2020.
//

import UIKit

class TaskListView: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var taskListView: UIView!
    @IBOutlet weak var selectTaskTitle: UILabel!
    @IBOutlet weak var taskListViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskListViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var taskListTableViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var searchTaskButton: UIButton!
    
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    let taskListCellHeight = 50
    let maximumCountOfTaskListCell = 4
    let offset = 5
    private let taskNameLimit = 35

    var viewModel = TaskListViewModel()
    
    weak var delegate: ChooseTaskDelegate?
    
    let loadingView = LoadingView()
    
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
        setupViewModel()
        updateAddTaskButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        taskListView.roundCorners([.allCorners], radius: 30.0)
        taskListView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        taskListTableView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
        
        addTaskButton.isHidden = viewModel.shouldHideAddTaskButton()
        searchTaskButton.isHidden = viewModel.searchButtonHidden
    }
    
    func setLocalizedStrings() {
        selectTaskTitle.text = viewModel.listTitle()
        addTaskTextField.placeholder = viewModel.getSearchPlaseholder()
    }
    
    func setupTextField() {
        addTaskTextField.addCloseToolbar()
        addTaskTextField.setPaddingPoints(right: 30, left: 30)
        
        if #available(iOS 11.0, *) {
            addTaskTextField.smartInsertDeleteType = .no
        }
        
        addTaskTextField.delegate = self
        addTaskTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        addTaskTextField.roundCorners([.bottomLeft, .topLeft], radius: 25)
        addTaskTextField.border(width: 2, color: #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1))
        addTaskTextField.borderStyle = .none
    }
    
    func updateAddTaskButton() {
        if viewModel.shouldEnableAddTaskButton() {
            addTaskButton.isUserInteractionEnabled = true
            addTaskButton.alpha = 1
        } else {
            addTaskButton.isUserInteractionEnabled = false
            addTaskButton.alpha = 0.5
        }
    }
    
    private func setupTableView() {
        let cell = UINib(nibName: TaskListTableViewCell.identifier, bundle: nil)
        taskListTableView.register(cell, forCellReuseIdentifier: TaskListTableViewCell.identifier)
        
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        
        taskListTableView.tableFooterView = UIView()
        
        refreshTableViewHeight(animation: false)
    }
    
    func refreshTableViewHeight(animation: Bool = true) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.taskListTableViewHeightConstraints.constant = CGFloat(self.viewModel.getNumberOfExpandedRows() > self.maximumCountOfTaskListCell
                                                                        ? self.maximumCountOfTaskListCell * self.taskListCellHeight + self.offset
                                                                        : self.viewModel.getNumberOfExpandedRows() * self.taskListCellHeight + self.offset)
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupViewModel() {
        addTaskTextField.isHidden = viewModel.shouldShowAddTaskTextField()
        
        viewModel.sectionCollapsed = { [weak self] (sectionIndex) in
            let sections = IndexSet(arrayLiteral: sectionIndex)
            self?.taskListTableView.reloadSections(sections, with: .none)
        }
    }
    
    func setupTaps() {
        let closeTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        closeImage.addGestureRecognizer(closeTap)
        
        let backgroundTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(backgroundTap)
    }
    
    @IBAction func addTaskItemAction(_ sender: Any) {
        if let name = addTaskTextField.text, name.count > 0 {
            addTaskTextField.resignFirstResponder()
            addTaskTextField.text = ""
            
            // dismissView()
            self.userDidAddTask(name)
        }
    }
    
    @IBAction func searchTaskAction(_ sender: Any) {
        let destVC = ViewSource.searchTaskScreen()
        destVC.delegate = self
        
        destVC.modalPresentationStyle = .overCurrentContext
        destVC.modalTransitionStyle = .crossDissolve
        present(destVC, animated: true)
    }
    
    @objc func dismissView() {
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.userDidCloseList(self)
        })
    }
    
    func userDidAddTask(_ name: String) {
        self.view.addSubview(loadingView)
        
        if viewModel.shouldAddClientTask() {
            dismiss(animated: true) {
                self.delegate?.userShouldSelectProject(forTask: name)
            }
        } else {
            let addTask = AddTaskEndpoint.init(taskName: name)
            addTask.apiCall { (result, error) in
                self.loadingView.removeFromSuperview()
                
                if error?.success ?? false {
                    // self.loadData()
                    if let tasks = result?.data {
                        CompaniesDataManager.shared.setTaskList(tasks: tasks)
                        self.viewModel.updateTaskList()
                        
                        self.viewModel.selectTask(by: name)
                        if let task = self.viewModel.selectedTask {
                            self.dismissView()
                            self.delegate?.userDidSelectTask(task)
                        }
                    }
                } else {
                    NavigationController.shared?.showErrorView(error: error)
                }
            }
        }
    }
    
}

extension TaskListView {
    
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

protocol ChooseTaskDelegate: NSObjectProtocol {
    func userDidSelectTask(_ task: TaskObj?)
    func userShouldSelectProject(forTask withName: String)
    func userDidCloseList(_ list: TaskListView)
}

extension ChooseTaskDelegate {
    func userShouldSelectProject(forTask withName: String) {}
    func userDidCloseList(_ list: TaskListView) {}
}

extension TaskListView: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            viewModel.filterList(filterText: text)
            taskListTableView.reloadData()
        } else {
            viewModel.unfilterList()
            taskListTableView.reloadData()
        }
        updateAddTaskButton()
        refreshTableViewHeight()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= taskNameLimit
    }
    
}

extension TaskListView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskListTableViewCell.identifier,
            for: indexPath) as? TaskListTableViewCell,
           
           let cellViewModel = viewModel.getModelForItemAt(
            section: indexPath.section, row: indexPath.row) {
            
            cell.configure(viewModel: cellViewModel)
            cell.expandedAction = {
                self.expandAction(indexPath: indexPath)
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func expandAction(indexPath: IndexPath) {
        if viewModel.isItemExpandable(section: indexPath.section, row: indexPath.row) {
            // Expandable menu items should expand or collapse only.
            viewModel.toggleItem(section: indexPath.section, row: indexPath.row)
            
            refreshTableViewHeight()
            taskListTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isItemExpandable(section: indexPath.section, row: indexPath.row) {
            expandAction(indexPath: indexPath)
        } else {
            // if we haven`t active login
            DispatchQueue.main.async(execute: {
                self.dismiss(animated: true) {
                    self.viewModel.selectTask(by: indexPath)
                    let task = self.viewModel.selectedTask
                    self.delegate?.userDidSelectTask(task)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(taskListCellHeight)
    }
}

extension TaskListView: SearchTaskViewDelegate {
    
    func didFinishSearching(_ task: TaskObj?, error: ErrorObject?) {
        if let task = task {
            saveTask(task)
            taskListTableView.reloadData()
            delegate?.userDidSelectTask(task)
            dismissView()
        } else {
            showErrorView(error)
        }
    }
    
    private func saveTask(_ task: TaskObj) {
        viewModel.addTask(task)
        //TODO: save task to CoreData
    }
    
    private func showErrorView(_ error: ErrorObject?) {
        guard let error = error else { return }
        
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: String(error.error_code ?? 0), message: String(error.error_code ?? 0).localized)
        if error.error_code == 401 {
            vc.confirmTapped = {
                let vc = ViewSource.chooseLanguageScreen()
                NavigationController.shared?.setRoot(vc, animated: true)
            }
        }

        present(vc, animated: true, completion: nil)
    }
}
