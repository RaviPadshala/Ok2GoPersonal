//
//  ProjectsListView.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 29.06.2022.
//

import UIKit

protocol ExtendedListViewDelegate: AnyObject {
    func didSelectItem(type: ExtendedListContentType, itemId: Int?, parameters: Any?)
}

class ExtendedListView: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var approveView: UIView!
    @IBOutlet weak var approveTitle: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!
    
    var viewModel: ExtendedListViewModel!
    weak var delegate: ExtendedListViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTaps()
        prepareTableView()
        
        approveView.roundCorners([.allCorners], radius: 30.0)
        approveView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        cancelView.roundCorners([.allCorners], radius: 30.0)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        approveTitle.text = "CONFIRM".localized
        cancelTitle.text = "CANCEL".localized
        
        titleLabel.text = viewModel.titleString
        
        contentView.roundCorners([.allCorners], radius: 30.0)
        contentView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        updateUI()
    }
    
    func updateUI() {
        approveView.alpha = viewModel.approveViewAlpha
        approveButton.isEnabled = viewModel.approveButtonEnabled
    }
    
    func setupTaps() {
        let closeTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        closeImage.addGestureRecognizer(closeTap)
        
        let backgroundTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(backgroundTap)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func approveAction(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.didSelectItem(type: self.viewModel.type, itemId: self.viewModel.selectedItemId(), parameters: self.viewModel.parameters)
        }
    }
}

extension ExtendedListView: UITableViewDelegate, UITableViewDataSource {
    
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeight.constant = viewModel.tableViewHeight
        
        tableView.register(UINib(nibName: String(describing: ExtendedListCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ExtendedListCell.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExtendedListCell.self)) as! ExtendedListCell
        cell.fill(with: viewModel.cellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectProject(at: indexPath)
        updateUI()
    }
}
