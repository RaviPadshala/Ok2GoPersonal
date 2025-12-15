//
//  ManagerViewController.swift
//  clock2go2020
//
//  Created by Admin on 4/13/20.
//

import UIKit

class ManagerViewController: UIViewController {

    @IBOutlet weak var accountInfoView: AccountInfoView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var currentView: UIView!

    var viewModel = ManagerViewModel()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        try? addReachabilityObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeReachabilityObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupActions()
        setupCollectionView()

        /// set manager app activity
        UserDefaultsManager.isManagerApp = true
        UserDefaultsManager.userLoggedInManager = true
    }

    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }

    func setupUI() {
        // account info view
        self.accountInfoView.config(viewModel: AccountInfoViewModel(type: .withName))

        let employeesView = DailyStatusView()
        currentView.addSubview(employeesView)
        employeesView.frame = currentView.bounds
    }

    func setupActions() {
        accountInfoView.delegate = self
    }

    func setupCollectionView() {
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self

        let nib = UINib(nibName: "ManagerMenuCollectionViewCell", bundle: nil)
        menuCollectionView.register(nib, forCellWithReuseIdentifier: ManagerMenuCollectionViewCell.identifier)
      //  menuCollectionView.scrollToItem(at: IndexPath(row: 3, section: 0), at: .centeredHorizontally, animated: false)

    }

    func select(type: ManagerMenu) {
        for view in currentView.subviews {
            view.removeFromSuperview()
        }

        if let view = type.view {
            currentView.addSubview(view)
            view.frame = currentView.bounds
        }
    }
}

extension ManagerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ManagerMenu.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManagerMenuCollectionViewCell.identifier, for: indexPath) as? ManagerMenuCollectionViewCell

            cell?.icon.image = ManagerMenu.init(rawValue: indexPath.row)?.icon
            cell?.titleLabel.text = ManagerMenu.init(rawValue: indexPath.row)?.title

        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = ManagerMenu(rawValue: indexPath.row) else { return }
        select(type: type)

        if indexPath.row == 2 {
            let vc = ViewSource.employeesReportManagementScreen()
            NavigationController.shared?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/3 - 2), height: (collectionView.bounds.height))
    }
}

extension ManagerViewController: AccountInfoViewDelegate {
    func userDidTapImageButton() {
        
    }
    


    func userDidTapMessagesButton() {
        let vc = ViewSource.notificationScreen()
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    func userDidTapSettingsButton() {
        let vc = ViewSource.sideBarView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = SideBarViewModel(type: .manager)

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

}

extension ManagerViewController: ReachabilityObserverDelegate {

    // MARK: Reachability

    func reachabilityChanged(_ isReachable: Bool) {
        ReachabilityManager.shared.hasInternetConnection = isReachable

        if !isReachable {
            print("No internet connection")
        } else {
            print("Has Internet connection")
        }
    }

}
