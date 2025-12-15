//
//  WeeklyScheduleViewController.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 08.08.2022.
//

import UIKit

class WeeklyScheduleViewController: UIViewController {
    
    private var viewModel: WeeklyScheduleViewModel!
    private let loadingView = LoadingView()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var previousView: UIView!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WeeklyScheduleViewModel(delegate: self)
        prepareUI()
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        let screenFrame = UIScreen.main.bounds
        self.view.frame = CGRect(x: 0, y: 0, width: screenFrame.height, height: screenFrame.width)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    func prepareUI() {
        previousLabel.text = viewModel.previousButtonTitle
        currentLabel.text = viewModel.currentButtonTitle
        nextLabel.text = viewModel.nextButtonTitle
        
        previousView.border(width: 1, color: UIColor(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1.0).cgColor)
        previousView.roundCorners(.allCorners, radius: 16)
        currentView.border(width: 1, color: UIColor(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1.0).cgColor)
        currentView.roundCorners(.allCorners, radius: 16)
        nextView.border(width: 1, color: UIColor(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1.0).cgColor)
        nextView.roundCorners(.allCorners, radius: 16)

        refreshUI()
    }
    
    func refreshUI() {
        titleLabel.text = viewModel.titleString
        previousLabel.textColor = viewModel.previousButtonTextColor
        previousLabel.font = viewModel.previousButtonFont
        previousView.backgroundColor = viewModel.previousButtonBackground
        currentLabel.textColor = viewModel.currentButtonTextColor
        currentLabel.font = viewModel.currentButtonFont
        currentView.backgroundColor = viewModel.currentButtonBackground
        nextLabel.textColor = viewModel.nextButtonTextColor
        nextLabel.font = viewModel.nextButtonFont
        nextView.backgroundColor = viewModel.nextButtonBackground
    }
}

extension WeeklyScheduleViewController {
 
    @IBAction func backAction(_ sender: Any) {
        let _ = NavigationController.shared?.popViewController(animated: true)
    }
    
    @IBAction func previousAction(_ sender: Any) {
        viewModel.showPreviousWeek()
        refreshUI()
    }
    
    @IBAction func currentAction(_ sender: Any) {
        viewModel.showCurrentWeek()
        refreshUI()
    }

    @IBAction func nextAction(_ sender: Any) {
        viewModel.showNextWeek()
        refreshUI()
    }
}

extension WeeklyScheduleViewController: WeeklyScheduleViewModelDelegate {
    
    func didStartLoading() {
        view.addSubview(loadingView)
    }
    
    func didLoadData(_ viewModels: [WeeklyScheduleCellViewModel]) {
        tableView.reloadData()
    }
    
    func didFinishLoading() {
        loadingView.removeFromSuperview()
    }
}

extension WeeklyScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func prepareTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }

        tableView.register(UINib(nibName: String(describing: WeeklyScheduleCell.self), bundle: nil), forCellReuseIdentifier: String(describing: WeeklyScheduleCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed(String(describing: WeeklyScheduleSectionView.self), owner: self)?.first as? WeeklyScheduleSectionView
        view?.fill(with: viewModel.sectionHeaderViewModel)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeeklyScheduleCell.self)) as! WeeklyScheduleCell
        cell.fill(with: viewModel.cellViewModels[indexPath.row])
        return cell
    }
}
