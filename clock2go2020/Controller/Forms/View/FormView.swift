//
//  FormView.swift
//  clock2go2020
//
//  Created by Mac on 26/09/24.
//

import UIKit

class FormView: UIView {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var saveTitle: UILabel!

    var viewModel = FormViewModel()

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
        Bundle.main.loadNibNamed("FormView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
      
     
        setupTableView()
      
    }
    
    func refresh(){
        tableView.reloadData()
    }
    
    
  
  

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: "FormViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FormViewCell.identifier)
    }

    
   
}

extension FormView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FormViewCell.identifier, for: indexPath) as? FormViewCell {
            cell.config(viewModel: viewModel.getModelFor(index: indexPath.row))
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.changeDaySelection(index: indexPath.row)
//        tableView.reloadData()
        let vc = ViewSource.formWebViewScreen()
        vc.url = viewModel.getURL(index: indexPath.row)
        vc.formName = viewModel.getformName(index: indexPath.row)
//        vc.mandotoryBeforeReport = viewModel.getformMandatoryBeforeReport(index: indexPath.row) ?? false
        vc.mandotoryBeforeReport = false
        vc.isFormListView = true
        NavigationController.shared?.pushViewController(vc, animated: true)
//        let vc = ViewSource.reminderTimeScreen()
//        UserDefaultsManager.selectedDay = indexPath.row
//        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
