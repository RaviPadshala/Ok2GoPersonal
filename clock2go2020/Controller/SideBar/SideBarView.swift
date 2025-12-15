import UIKit

class SideBarView: UIViewController {

    // MARK: Otlets
    @IBOutlet var userPhotoView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var userPhotoImageView: UIView!
    @IBOutlet var userPhotoImage: UIImageView!
    @IBOutlet var menuButtonOutlet: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var settingsContentView: UIView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var versionLabel: UILabel!
    
    var viewModel: SideBarViewModel!
    weak var delegate: SideBarViewDelegate?

    // MARK: Override
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.trailingConstraint.constant = -self.settingsContentView.bounds.width
     
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name(rawValue: "PushNotificationRecieved"), object: nil)

        UIView.animate(withDuration: 0.25) {
            self.trailingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
        setupTap()
        setupTableView()
        
        
    }

    func setupUI() {
        settingsContentView.roundCorners([.bottomLeft, .topLeft], radius: 40)
        userPhotoView.roundCorners([.bottomLeft, .bottomRight], radius: 35)

        userPhotoImageView.roundCorners([.allCorners], radius: 25)
        userPhotoImageView.shadow(CGSize(width: 0.3, height: 3), opacity: 0.3, radius: 3, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        userPhotoImageView.border(width: 2.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

        userPhotoImage.roundCorners([.allCorners], radius: 25.0)

        userPhotoImage.image = getImage()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        versionLabel.text = "v\(version)"
    }

    @objc func updateTableView() {
        tableView.reloadData()
    }

    func getImage() -> UIImage? {
        var image = UIImage(named: "surface1")

        if let imageData = UserDefaultsManager.image {
            image = UIImage(data: imageData)
        }

        return image
    }

    func setupTap() {
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(animatedDismissView))
        backgroundView.addGestureRecognizer(dismissTap)
    }

    func setupTableView() {
       

        let nibCell = UINib(nibName: SideBarTableViewCell.identifier, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: SideBarTableViewCell.identifier)
    }

    @objc func animatedDismissView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.trailingConstraint.constant = -self.settingsContentView.bounds.width
            self.view.layoutIfNeeded()
        }) { completion in
            self.dismiss(animated: true, completion: nil)
        }
    }

    func dismissView() {
        self.trailingConstraint.constant = -self.settingsContentView.bounds.width
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        animatedDismissView()
    }

}

extension SideBarView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header = view as! UITableViewHeaderFooterView

        header.textLabel?.textColor = #colorLiteral(red: 0.1137254902, green: 0.3019607843, blue: 0.4352941176, alpha: 1)
        header.textLabel?.textAlignment = .right
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        header.frame.origin.x = -30
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTitleForSection(section: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumbersOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: SideBarTableViewCell.identifier, for: indexPath) as? SideBarTableViewCell
            ,let model = viewModel.getModelForCellAt(indexPath: indexPath){
            cell.viewModel = model
            cell.selectedBackgroundView = viewModel.getSelectedBackgroundView()
            cell.configure(model: model)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let section = SideBarSection.init(rawValue: indexPath.section),
           section == .Settings,
           let selectedRow = SettingRow(rawValue: indexPath.row),
           selectedRow == .logout {
            self.showLogoutAlert()
            return
        }

        guard let vc = viewModel.getViewControllerForCellAt(indexPath: indexPath) else { return }

        if let viewController = vc as? LanguageListViewController {
            viewController.delegate = self
            self.show(viewController, sender: self)
            return
        }

        if vc.isKind(of: DashboardViewController.self) || vc.isKind(of: ManagerViewController.self) {
            self.animatedDismissView()
            NavigationController.shared?.setRoot(vc, animated: true)
            return
        }

        if let viewController = vc as? ReportManagementViewController {
            viewController.config(model: ReportManagementViewModel(date: Date()))
            self.dismissView()
            NavigationController.shared?.pushViewController(viewController, animated: true)
            return
        }

        if let viewController = vc as? WeeklyScheduleViewController {
            self.dismissView()
            NavigationController.shared?.pushViewController(viewController, animated: true)
            return
        }
        
        self.animatedDismissView()
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !CompaniesDataManager.shared.hasReportFeature() {
            if indexPath.row == 3 {
                return 0
            }
        }
        return viewModel.getHeightOfCellAt(indexPath: indexPath)
    }
    
    //

}

protocol SideBarViewDelegate: NSObjectProtocol {
    func userDidTapLanguage()
}


extension SideBarView: LanguageListDelegate {
    
   
  
    func userDidTapLanguage(_ row: Int) {

              DispatchQueue.main.async 
                {
                   
                  self.tableView.reloadData()
                  
                  self.delegate?.userDidTapLanguage()
              }
   
    }
    
    
    func reload(completion : @escaping ()-> () ){
        self.tableView.reloadData()
    }

}

// MARK: - Logout
extension SideBarView: ConfirmationAlertViewDelegate {
    func view(_ view: ConfirmationAlertView, didPressOk button: UIButton) {
        //logout user
        self.animatedDismissView()
        self.logoutUser()
    }
    
    func view(_ view: ConfirmationAlertView, didPressCancel button: UIButton) {
        //
    }
    
    
    private func showLogoutAlert() {
        let vc = ViewSource.confirmationAlertView()
        vc.setupView(delegate: self, message: "logoutAlert".localized)
        
        vc.view.frame = self.view.bounds
        self.view.addSubviewWithAnimation(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    private func logoutUser() {
        UserDefaultsManager.udid = nil
        UserDefaultsManager.phoneNumber = nil
//        UserDefaultsManager.reminderDays = nil
//        UserDefaultsManager.loginReminderTime = nil
//        UserDefaultsManager.logoutReminderTime = nil
        NavigationController.shared?.checkRootViewController()
    }
}
