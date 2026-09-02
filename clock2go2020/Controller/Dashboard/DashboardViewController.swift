//
//  DashboardViewController.swift
//  clock2go2020
//
//  Created by Admin on 1/3/20.
//

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import Network

class DashboardViewController: UIViewController {

    @IBOutlet weak var selectRevechaClientHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dashboardLine: UIImageView!
    @IBOutlet weak var studentReportBgView: UIView!
    @IBOutlet weak var accountInfoView: AccountInfoView!
    @IBOutlet weak var infoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var statisticsView: StatisticsView!
    @IBOutlet weak var taskBarView: TaskBarView!
    @IBOutlet weak var chooseTaskView: ChooseTaskView!
    @IBOutlet weak var chooseTaskViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trackingView: TrackingView!
    @IBOutlet weak var trackingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapPresenterView: UIView!
    @IBOutlet weak var showTrackingButton: UIButton!
    @IBOutlet weak var showTrackingButtonCenterAligment: NSLayoutConstraint!
    @IBOutlet weak var addRideView: UIView!
    @IBOutlet weak var addRideLabel: UILabel!
    @IBOutlet weak var addRideLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var hoursLimitLabel: UILabel!
    @IBOutlet weak var hoursCompletedLabel: UILabel!
    @IBOutlet weak var absenceView: AbsenceView!
    @IBOutlet weak var selectRevachaClient: SelectClientView!
    @IBOutlet weak var barcodeView: BarcodeScannerView!
    @IBOutlet weak var offlineLabel: UILabel!
    @IBOutlet weak var workScheduleView: DayWorkScheduleView!

    @IBOutlet weak var viewStudentReport: UIView!
    @IBOutlet weak var subviewStudentReport: UIView!
    @IBOutlet weak var lbl_cordinatorName: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_projectName: UILabel!
    @IBOutlet weak var lbl_taskName: UILabel!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var tbl_sperad: UITableView!
    @IBOutlet weak var tbl_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollview_inner: UIScrollView!
    @IBOutlet weak var btn_previous_date: UIButton!
    @IBOutlet weak var btn_next_date: UIButton!
    @IBOutlet weak var btn_chat: UIButton!
    @IBOutlet weak var view_chat: UIView!
    
    var mapView: MapView?
    var viewModel = DashboardViewModel()
    static var isRecentNFCScan = Bool()
    var timer: Timer?
    var timerSecond : Int = 10

    var isRevachaAction: Bool = false
//    var studentReportData: DailyStudentReportsObj?
    var studentReportArr = [DailyStudentReportsObj]()
    var studentDataArr = [Studentsdata]()
    
    let chatButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "ic_chatAI"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    private var isButtonPositioned = false

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var selectedDate: Date = Date() {
        didSet {
            updateDateLabel()
            updateButtonStates()
            checkEditPermission()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupTap()
        try? addReachabilityObserver()
        viewModel.startDataLoading(){

        }
        checkingDistanceMeasurement()
        UserDefaultsManager.isManagerApp = false
//        let fff = "400".localized
//        let hhh = "410".localized
//        let jjj = "421".localized
//        let uuu = "425".localized
//        let rrr = "434".localized
//        let qqq = "500".localized

        NotificationCenter.default.addObserver(self, selector: #selector(companyChnage), name: Notification.Name(rawValue: "LoadData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(companyChnage), name: Notification.Name(rawValue: "CompanyChnage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReturnFromSecondVC), name: NSNotification.Name("DidReturnFromFormWebViewControllerForDashBoard"), object: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(updateAccountInfo), name: Notification.Name(rawValue: "PushNotificationRecieved"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(checkOfflineLabelVisibility(_:)), name: Notification.Name(rawValue: "EndpointStatusNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.tbl_sperad.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        refreshView()
        refreshStrings()
        self.viewModel.loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.checkWifiConnection()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tbl_sperad.removeObserver(self, forKeyPath: "contentSize")
        removeReachabilityObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !self.isButtonPositioned {
            let buttonSize: CGFloat = 60
            let margin: CGFloat = 20
            let x = view.bounds.width - buttonSize - margin
            let y = view.bounds.height - buttonSize - margin
            
            self.chatButton.frame = CGRect(x: x, y: y, width: buttonSize, height: buttonSize)
            self.isButtonPositioned = true
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                print("table height:", newsize.height)
                self.tbl_heightConstraint.constant = newsize.height
            }
        }
    }
    
    private func updateDateLabel() {
        self.lbl_date.text = getSelectedDateInString()
    }
    
    func getSelectedDateInString(formate: String = "dd/MM/yyyy") -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = formate
        return formatter.string(from: self.selectedDate)
    }
    
    private func updateButtonStates() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let selectedDateOnly = calendar.startOfDay(for: self.selectedDate)
        
        let minDate = calendar.date(byAdding: .day, value: -6, to: today)!
        let maxDate = calendar.date(byAdding: .day, value: 6, to: today)!
        
        self.btn_previous_date.isEnabled = selectedDateOnly > minDate
        self.btn_next_date.isEnabled = selectedDateOnly < maxDate
        print(selectedDateOnly)
        print(today)

        if selectedDateOnly > today {
            self.btn_confirm.isUserInteractionEnabled = false
            self.btn_confirm.alpha = 0.5
        } else {
            self.btn_next_date.isUserInteractionEnabled = true
            self.btn_confirm.alpha = 1.0
        }
        
    }
    
    private func checkEditPermission() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: selectedDate)
        
        let daysDiff = calendar.dateComponents([.day], from: selectedDay, to: today).day ?? 0
        
        if daysDiff >= 0 && daysDiff <= 6 {
            print("✅ Editable: Within the last 6 days including today")
            // Enable editing of traffic light data
        } else {
            print("❌ Not editable: Outside editable range")
            // Disable editing of traffic light data
        }
    }

    @objc func companyChnage(){
        self.showApproveHour(approvedHours: CompaniesDataManager.shared.getApprovedHours())
    }

    @objc func updateData() {
        viewModel.loadData()
    }

    func setupUI() {
        let gradient = CAGradientLayer().get(topColor: #colorLiteral(red: 0.0860728398, green: 0.4160004258, blue: 0.7110635638, alpha: 1), bottomColor: #colorLiteral(red: 0.113828741, green: 0.5079905987, blue: 0.8489963412, alpha: 1), isVertical: true, frame: view.frame)
        self.view.layer.insertSublayer(gradient, at: 0)

        self.showTrackingButton.roundCorners([.topLeft, .topRight], radius: 5)
        
//        delay(durationInSeconds: 1.0) {
//            self.view_chat.frame = CGRect(x: self.view.frame.size.width - 80, y: self.view.frame.size.height - 80, width: 60, height: 60)
//            self.view_chat.frame.origin.x = 310
//        }
//        print("self.view_chat.frame", self.view_chat.frame)
//        self.btn_chat.RoundCornerRadius()
//        self.btn_chat.border(width: 1.0, color: UIColor.white.cgColor)

        self.addRideView.roundCorners(.allCorners, radius: 20.0)
        offlineLabel.text = "  " + "OFFLINE_MODE".localized + "  "

        self.setupTableview()
        self.setupChatButton()
    }
    
    func setupChatButton() {
        self.view.addSubview(self.chatButton)
        self.chatButton.border(width: 1.0, color: UIColor.white.cgColor)
        self.chatButton.addTarget(self, action: #selector(self.clickChat(_:)), for: .touchUpInside)
        
        // Add drag gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.chatButton.addGestureRecognizer(panGesture)
    }
    
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if let button = gesture.view {
            // Update position based on drag
            button.center = CGPoint(x: button.center.x + translation.x, y: button.center.y + translation.y)
        }
        
        gesture.setTranslation(.zero, in: view)
        
        // Optional: Keep button inside screen bounds
        if gesture.state == .ended {
            var finalFrame = self.chatButton.frame
            let safeArea = view.safeAreaLayoutGuide.layoutFrame
            
            if finalFrame.minX < safeArea.minX {
                finalFrame.origin.x = safeArea.minX
            } else if finalFrame.maxX > safeArea.maxX {
                finalFrame.origin.x = safeArea.maxX - finalFrame.width
            }
            
            if finalFrame.minY < safeArea.minY {
                finalFrame.origin.y = safeArea.minY
            } else if finalFrame.maxY > safeArea.maxY {
                finalFrame.origin.y = safeArea.maxY - finalFrame.height
            }
            
            UIView.animate(withDuration: 0.2) {
                self.chatButton.frame = finalFrame
            }
        }
    }
    
    func startTimer(){
        DashboardViewController.isRecentNFCScan = true
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.timerSecond), repeats: false) { _ in
            DashboardViewController.isRecentNFCScan = false
            self.cancelTimer()
        }
    }
    
    func cancelTimer() {
        DashboardViewController.isRecentNFCScan = false
        timer?.invalidate()
        timer = nil
    }

    func showFlightModePopup() {
        let alertController = UIAlertController(title: "airplane_mode_turned_off_message_alert".localized, message: "", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "SETTINGS".localized, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: "App-Prefs:root=AIRPLANE_MODE") else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve

        NavigationController.shared?.present(alertController, animated: true, completion: nil)
    }

    func showNoInternetPopup() {

//        if isAirplaneModeOn(){
//            self.showFlightModePopup()
//            return
//        }
        
        isAirplaneModeOnNew { isAirplane in
            if isAirplane {
                self.showFlightModePopup()
                return
            }else{
                let alertController = UIAlertController(title: "no_internet_message_alert".localized, message: "", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                alertController.addAction(settingsAction)
                alertController.modalPresentationStyle = .overCurrentContext
                alertController.modalTransitionStyle = .crossDissolve

                NavigationController.shared?.present(alertController, animated: true, completion: nil)
            }
        }

        
    }

    func setupActions() {
        viewModel.delegate = self
        trackingView.delegate = self

        accountInfoView.delegate = self
        taskBarView.delegate = self

        chooseTaskView.selectTaskTapped = {
            self.showChooseTaskView()
        }

        selectRevachaClient.selectClientTapped = { type in
            self.viewModel.trnsType = type
            self.showChooseTaskView()
        }

        selectRevachaClient.selectEventTapped = { type in
            self.viewModel.trnsType = type
            self.isRevachaAction = true
            if self.viewModel.selectedTask == nil {
                self.showRevachaClientView()
            } else {
                self.showChooseEventView()
            }
        }

        selectRevachaClient.selectTrnsTypeTapped  = { type in

            self.viewModel.trnsType = type
            switch type {
            case 3:
                self.trackingView.eventsView.alpha = 0.5
                self.trackingView.eventsView.isUserInteractionEnabled = false
                self.viewModel.clearSelectedEvent()
                break
            default:
                self.trackingView.eventsView.alpha = 1
                self.trackingView.eventsView.isUserInteractionEnabled = true
            }
            print("type",type)
        }
        
        selectRevachaClient.selectTheraphyTypeTapped = { type in
            self.showChooseTheraphyView()
        }
        
        
        trackingView.loginTapped = { [weak self] in
            guard let `self` = self else {
                return
            }

            guard UserDefaultsManager.connectionServiceCount > 0 else {
                showNoInternetPopup()
                return
            }

            if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
                if DashboardViewController.isRecentNFCScan {
                    self.cancelTimer()
                    self.viewModel.userDidTapConfirm(type: .login, task: nil, remark: "", isNFCRead: true)
                }else{
                    self.showErrorView(title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
                }
            }else{
                if CompaniesDataManager.shared.hasFormsEnterFeature(){
                    if let arr = CompaniesDataManager.shared.getEnterFormCount(), arr.count > 0{
                        let msgStr = String(format: "You_have_to_fill".localized, arguments: [arr.count])
                        
                        let otherAlert = UIAlertController(title: "", message: msgStr, preferredStyle: .alert)
                        let printSomething = UIAlertAction(title: "SHOW_TRAKING_CONFIRM_TITLE".localized, style: .default) { _ in
                            let vc = ViewSource.formWebViewScreen()
                            if let url = CompaniesDataManager.shared.getFormsURL(type: 1){
                                vc.url = url
                            }
                            if let formName = CompaniesDataManager.shared.getFormName(type: 1){
                                vc.formName = formName
                            }
                            vc.formdataArr = arr
                            vc.mandotoryBeforeReport = CompaniesDataManager.shared.hasFormsMandoryBeforeReportFeature(type: 1)
                            vc.actionTag = 0
                            NavigationController.shared?.pushViewController(vc, animated: true)
                        }
                        let cancelBtn = UIAlertAction(title: "cancel".localized, style: .cancel)
                        otherAlert.addAction(printSomething)
                        otherAlert.addAction(cancelBtn)
                        self.present(otherAlert, animated: true)
                    }
                }else{
                    if self.viewModel.shouldShowCheckInConfirmationAlert() {
                        self.viewModel.showConfirmationAlert(delegate: self, isForCheckIn: true)
                    }else {
                        self.performCheckIn()
                    }
                }
            }
        }

        trackingView.logoutTapped = { [weak self] in
            
            guard let `self` = self else {
                return
            }
            
            guard UserDefaultsManager.connectionServiceCount > 0 else {
                self.showNoInternetPopup()
                return
            }

            if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
                if DashboardViewController.isRecentNFCScan {
                    self.cancelTimer()
                    self.viewModel.userDidTapConfirm(type: .logout, task: nil, remark: "", isNFCRead: true)
                }else{
                    self.showErrorView( title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
                }
                return
            }
            
            if self.viewModel.shouldShowCheckOutConfirmationAlert() {
                self.viewModel.showConfirmationAlert(delegate: self, isForCheckIn: false)
            }else {
                if CompaniesDataManager.shared.hasFormsExitFeature(){
                    if let arr = CompaniesDataManager.shared.getExitFormCount(), arr.count > 0{
                        let msgStr = String(format: "You_have_to_fill".localized, arguments: [arr.count])
                        let otherAlert = UIAlertController(title: "", message: msgStr, preferredStyle: .alert)
                        let printSomething = UIAlertAction(title: "SHOW_TRAKING_CONFIRM_TITLE".localized, style: .default) { _ in
                            let vc = ViewSource.formWebViewScreen()
                            if let url = CompaniesDataManager.shared.getFormsURL(type: 2){
                                vc.url = url
                            }
                            if let formName = CompaniesDataManager.shared.getFormName(type: 2){
                                vc.formName = formName
                            }
                            vc.mandotoryBeforeReport = CompaniesDataManager.shared.hasFormsMandoryBeforeReportFeature(type: 2)
                            vc.actionTag = 1
                            vc.formdataArr = arr
                            NavigationController.shared?.pushViewController(vc, animated: true)
                        }
                        let cancelBtn = UIAlertAction(title: "cancel".localized, style: .cancel)
                        otherAlert.addAction(printSomething)
                        otherAlert.addAction(cancelBtn)
                        self.present(otherAlert, animated: true)
                    }
                }else{
                    if CompaniesDataManager.shared.shouldTravelReportEnable() || CompaniesDataManager.shared.shouldManualTravelReportEnable(){
                        let vc = ViewSource.distanceView()
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.modalTransitionStyle = .crossDissolve
                        vc.tapConfirm = { fromCity, toCity, distance in
                            self.viewModel.selectedFromCity = fromCity
                            self.viewModel.selectedToCity = toCity
                            self.viewModel.enteredDistance = distance
                            self.performCheckOut()
                        }
                        
                        vc.tapCancel = {
//                            self.performCheckOut()
                        }
                        
                        NavigationController.shared?.present(vc, animated: true, completion: nil)
                        return
                    }
                    self.performCheckOut()
                }
            }
        }
        
        trackingView.tappedReturnFormService = { [weak self] in
            print("tappedReturnFormService")
            
            guard let `self` = self else {
                return
            }
            
            guard UserDefaultsManager.connectionServiceCount > 0 else {
                self.showNoInternetPopup()
                return
            }

            if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
                if DashboardViewController.isRecentNFCScan {
                    self.cancelTimer()
                    self.viewModel.userDidTapConfirm(type: .logout, task: nil, remark: "", isNFCRead: true)
                }else{
                    self.showErrorView( title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
                }
                return
            }else{
                
            }
        }
        
        trackingView.tappedExitFormService = { [weak self] in
            print("tappedExitFormService")
            
            guard let `self` = self else {
                return
            }
            
            guard UserDefaultsManager.connectionServiceCount > 0 else {
                self.showNoInternetPopup()
                return
            }

            if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
                if DashboardViewController.isRecentNFCScan {
                    self.cancelTimer()
                    self.viewModel.userDidTapConfirm(type: .logout, task: nil, remark: "", isNFCRead: true)
                }else{
                    self.showErrorView( title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
                }
                return
            }else{
                
            }
        }

        trackingView.pauseTapped = {
            if CompaniesDataManager.shared.hasBreakFeature(){
                guard self.viewModel.checkLocationValues() else { return }
                self.showConfirmView(type: self.viewModel.getBreakConfirmType())
                print("pause from dashboard with pause")
            }else{
                print("I m here tapped from dashboard with pause")
                self.sampleReport(.sampleReport)
            }

        }

        trackingView.signedReportTapped = {
            self.showSignedReportConfirmView()
        }

        trackingView.iMHereTapped = {
            self.sampleReport(.sampleReport)
            print("I m here tapped from dashboard")
        }

        trackingView.absenceTapped = {
            guard UserDefaultsManager.connectionServiceCount > 0 else {
                self.showNoInternetPopup()
                return
            }
            self.showAbsenceConfirmView()
        }

        trackingView.startTrackingTapped = {
            self.showDistanceConfirmView(type: .startTracking, hasLoginTitle: false)
        }

        trackingView.stopTrackingTapped = {
            self.showDistanceConfirmView(type: .stopTracking, hasLoginTitle: false)
        }

        trackingView.additionalButtonTapped = {
            self.refreshView()
        }

        trackingView.multiLoginTapped = {
            self.showMultiReportView(type: .login)
        }

        trackingView.multiLogoutTapped = {
            self.showMultiReportView(type: .logout)
        }

        trackingView.eventsTapped = {
            self.isRevachaAction = true
            if self.viewModel.selectedTask == nil {
                self.showRevachaClientView()
            } else {
                self.showChooseEventView()
            }
        }

        barcodeView.onScanAction = {
            self.showScannerScreen()
        }

        //NFC Scan Action
        barcodeView.onNFCScanAction = {
            self.showNFCPopup()
        }

        workScheduleView.onSelectItem = { [weak self] index in
            guard let note = self?.viewModel.notForScheduleItem(at: index) else { return }
            let alertController = UIAlertController(title: note, message: "", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.modalPresentationStyle = .overCurrentContext
            alertController.modalTransitionStyle = .crossDissolve

            NavigationController.shared?.present(alertController, animated: true, completion: nil)
        }
    }

    @objc func handleReturnFromSecondVC(_ notification: NSNotification) {
        // Perform any action needed here
        if let userInfo = notification.userInfo, let actionTag = userInfo["actionTag"] as? Int {
            print("actionTag", actionTag)
            if actionTag == 1{
                self.performCheckOut()
            }else if actionTag == 2{
                viewModel.bituachLeumiActionType = .serviceExit

                let listView = ViewSource.extendedListView()
                listView.viewModel = ExtendedListViewModel(type: .locationName, models: viewModel.locationNames, parameters: nil)
                listView.modalTransitionStyle = .crossDissolve
                listView.modalPresentationStyle = .overCurrentContext
                listView.delegate = self
                self.present(listView, animated: true, completion: nil)
            }else if actionTag == 3{
                viewModel.bituachLeumiActionType = .serviceEntry

                let listView = ViewSource.extendedListView()
                listView.viewModel = ExtendedListViewModel(type: .locationName, models: viewModel.locationNames, parameters: nil)
                listView.modalTransitionStyle = .crossDissolve
                listView.modalPresentationStyle = .overCurrentContext
                listView.delegate = self
                self.present(listView, animated: true, completion: nil)
            }else if actionTag == 4{
                self.trackingView.callBackForReturnFromService()
            }else if actionTag == 5{
                self.trackingView.callBackForExitFromService()
            }else{
                if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature(){

                    if self.viewModel.shouldShowCheckInConfirmationAlert() {
                        self.viewModel.showConfirmationAlert(delegate: self, isForCheckIn: true)
                    }else {
                        self.performCheckIn()
                    }
                }else if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
                    self.showErrorView(title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
                }else{
                    if self.viewModel.shouldShowCheckInConfirmationAlert() {
                        self.viewModel.showConfirmationAlert(delegate: self, isForCheckIn: true)
                    }else {
                        self.performCheckIn()
                    }
                }
            }
        }else{
            if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature(){

                if self.viewModel.shouldShowCheckInConfirmationAlert() {
                    self.viewModel.showConfirmationAlert(delegate: self, isForCheckIn: true)
                }else {
                    self.performCheckIn()
                }
            }else if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
                self.showErrorView(title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
            }else{
                if self.viewModel.shouldShowCheckInConfirmationAlert() {
                    self.viewModel.showConfirmationAlert(delegate: self, isForCheckIn: true)
                }else {
                    self.performCheckIn()
                }
            }
        }
    }

    private func performCheckIn() {
        self.viewModel.clearSelectedLocationName()
        if UserDefaultsManager.connectionServiceCount > 0 {
            guard self.viewModel.checkLocationValues() else { return }
            self.showLoginConfirmView()
        } else {
            self.showNoInternetPopup()
        }
    }

    private func performCheckOut() {
        self.viewModel.clearSelectedLocationName()
        if UserDefaultsManager.connectionServiceCount > 0 {
            guard self.viewModel.checkLocationValues() else { return }
            self.showLogoutConfirmView()
        } else {
            self.showNoInternetPopup()
        }
    }

    func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAddRideView))
        addRideView.addGestureRecognizer(tap)
    }

    func checkLocationPermission() {
        self.viewModel.checkLocationPermission()
    }

    func showLoginConfirmView() {
        if self.viewModel.shoulShowChooseTaskError() {
            if self.viewModel.isRevacha || self.viewModel.isHolocaust{
                self.showRevachaClientView()
            } else {
                self.showErrorView(title: "421", message: "421".localized)
            }
        } else {
            guard !self.viewModel.shouldShowDistanceMeasurementForAction(type: .loginConfirm) else { return }
            self.showConfirmView(type: .loginConfirm)
        }
    }

    func showLogoutConfirmView() {
        self.viewModel.taskSource = .taskList
        if self.viewModel.shoulShowChooseTaskError() {
            if viewModel.isRevacha || self.viewModel.isHolocaust{
                self.showRevachaClientView()
            } else {
                self.showErrorView(title: "421", message: "421".localized)
            }
        } else {
            guard !self.viewModel.shouldShowDistanceMeasurementForAction(type: .logoutConfirm) else { return }
            self.showConfirmView(type: .logoutConfirm)
        }
    }

    func setLocalized() {
        
        var cordinaterName = "-"
        var projectName = "-"
        var taskName = "-"
        
        if let dict = self.studentReportArr.first, let str = dict.CoordinatorName, str.count > 0{
            cordinaterName = str
        }else{
            cordinaterName = CompaniesDataManager.shared.getEmployeeName() ?? "-"
        }
        
        let projectNameArr = self.studentReportArr.map({$0.ProjectName})
        if projectNameArr.count > 0{
            projectName = projectNameArr.joined(separator: ", ")
        }
        
        let taskNameArr = self.studentReportArr.map({$0.TaskName})
        if taskNameArr.count > 0{
            taskName = taskNameArr.joined(separator: ", ")
        }
        
        let nameStr = String(format: "HELLO".localized, cordinaterName)
        self.lbl_cordinatorName.text = nameStr
        
        let projectNameStr = String(format: "Internship".localized, projectName)
        self.lbl_projectName.text = projectNameStr

        let taskNameStr = String(format: "Subspecialty".localized, taskName)
        self.lbl_taskName.text = taskNameStr
        
        self.selectedDate = Date()

        self.btn_confirm.setTitle("CONFIRMATION_TITLE".localized, for: .normal)
        self.btn_confirm.border(width: 2.0, color: UIColor(named: "Color104876")!.cgColor)
    }
    
    func setStudentReportData() {
        
        self.studentReportArr.removeAll()
        if let data = CompaniesDataManager.shared.getStudentData(for: self.getSelectedDateInString(formate: "yyyy-MM-dd")){
            self.studentReportArr = data
        }
        
        self.studentDataArr.removeAll()
        for item in self.studentReportArr {
            if let arr = item.studentsdata, arr.count > 0 {
                self.studentDataArr.append(contentsOf: arr)
            }
        }
        
        self.tbl_sperad.reloadData()
        
        var cordinaterName = "-"
        var projectName = "-"
        var taskName = "-"
        
        if let dict = self.studentReportArr.first, let str = dict.CoordinatorName, str.count > 0{
            cordinaterName = str
        }else{
            cordinaterName = CompaniesDataManager.shared.getEmployeeName() ?? "-"
        }
        
        let projectNameArr = self.studentReportArr.map({$0.ProjectName})
        if projectNameArr.count > 0{
            projectName = projectNameArr.joined(separator: ", ")
        }
        
        let taskNameArr = self.studentReportArr.map({$0.TaskName})
        if taskNameArr.count > 0{
            taskName = taskNameArr.joined(separator: ", ")
        }
        
        let nameStr = String(format: "HELLO".localized, cordinaterName)
        self.lbl_cordinatorName.text = nameStr
        
        let projectNameStr = String(format: "Internship".localized, projectName)
        self.lbl_projectName.text = projectNameStr

        let taskNameStr = String(format: "Subspecialty".localized, taskName)
        self.lbl_taskName.text = taskNameStr
    }

    func refreshStrings() {
        self.accountInfoView.resetCurrentDate()
        self.accountInfoView.config(viewModel: viewModel.getModelForAccountView())
        self.statisticsView.reloadView()
        self.chooseTaskView.setLocalizedStrings()
        self.selectRevachaClient.setLocalizedStrings()
        self.trackingView.setLocalizedStrings()
        self.selectRevachaClient.reloadView()
        self.showTrackingButton.setTitle("SHOW_TRACK_TITLE".localized, for: .normal)
        self.addRideLabel.text = "ADD_DISTANCE".localized
        self.workScheduleView.reloadInfo()
        self.tbl_sperad.reloadData()
        delay(durationInSeconds: 0.5) {
            let x = self.scrollview_inner.contentSize.width - self.scrollview_inner.bounds.width
            if self.getCurrentLanguage() == "he" || self.getCurrentLanguage() == "ar"{
                self.scrollview_inner.setContentOffset(CGPoint(x: x, y: 0), animated: false)
            }else{
                self.scrollview_inner.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
        }
        
        var cordinaterName = "-"
        var projectName = "-"
        var taskName = "-"
        
        if let dict = self.studentReportArr.first, let str = dict.CoordinatorName, str.count > 0{
            cordinaterName = str
        }else{
            cordinaterName = CompaniesDataManager.shared.getEmployeeName() ?? "-"
        }
        
        let projectNameArr = self.studentReportArr.map({$0.ProjectName})
        if projectNameArr.count > 0{
            projectName = projectNameArr.joined(separator: ", ")
        }
        
        let taskNameArr = self.studentReportArr.map({$0.TaskName})
        if taskNameArr.count > 0{
            taskName = taskNameArr.joined(separator: ", ")
        }
        
        let nameStr = String(format: "HELLO".localized, cordinaterName)
        self.lbl_cordinatorName.text = nameStr
        
        let projectNameStr = String(format: "Internship".localized, projectName)
        self.lbl_projectName.text = projectNameStr

        let taskNameStr = String(format: "Subspecialty".localized, taskName)
        self.lbl_taskName.text = taskNameStr
        
        
        
        self.selectedDate = Date()

        

        self.btn_confirm.setTitle("CONFIRMATION_TITLE".localized, for: .normal)
    }

    func getCurrentLanguage() -> String{
        if let selectedLanguage = UserDefaultsManager.appleLanguagesNew.first, selectedLanguage.count > 0{
            return selectedLanguage
        }else{
            return "en"
        }
    }

    func refreshView() {
        self.setLocalized()
        viewModel.refreshTasksData()
        // account info view
        self.infoViewHeightConstraint.constant = viewModel.getInfoViewHeight()
        self.accountInfoView.config(viewModel: viewModel.getModelForAccountView())

//        self.offlineLabel.isHidden = viewModel.offlineModeLabelHidden

        self.trackingView.configure(model: viewModel.getModelForTrackingView())

//        self.studentReportData = nil
        self.studentReportArr.removeAll()
        
        self.chatButton.isHidden = true
        if let clientGrpId = CompaniesDataManager.shared.getClientGrpId(), clientGrpId == 53 {
            if CompaniesDataManager.shared.isChatActive() {
                self.chatButton.isHidden = false
            }
        }
        

        if let coordinateID = CompaniesDataManager.shared.getCoordinatorID(), coordinateID > 0{
            
            self.studentReportBgView.isHidden = false
            self.dashboardLine.isHidden = true

            self.statisticsView.isHidden = true
            self.taskBarView.isHidden = true
            self.chooseTaskView.isHidden = true
            self.trackingView.isHidden = true
            self.absenceView.isHidden = true
            self.mapPresenterView.isHidden = true
            self.selectRevachaClient.isHidden = true
            self.barcodeView.isHidden = true
            self.workScheduleView.isHidden = true
            self.addRideView.isHidden = true
            self.showTrackingButton.isHidden = true
            self.viewStudentReport.isHidden = false
            self.btn_confirm.isHidden = false
            
            
            self.studentReportArr.removeAll()
            if let arr = CompaniesDataManager.shared.getCurrentCompanyDailyStudentReport(), arr.count > 0, let data = CompaniesDataManager.shared.getStudentData(for: self.getSelectedDateInString(formate: "yyyy-MM-dd")){
                print("selectedDate :", data.count)
                self.studentReportArr = data
            }
            
            self.studentDataArr.removeAll()
            for item in self.studentReportArr {
                if let arr = item.studentsdata, arr.count > 0 {
                    self.studentDataArr.append(contentsOf: arr)
                }
            }
            
            self.tbl_sperad.reloadData()
            self.trackingViewHeightConstraint.constant = 0.0
        }else{

            self.dashboardLine.isHidden = false
            self.studentReportBgView.isHidden = true

            self.viewStudentReport.isHidden = true
            self.btn_confirm.isHidden = true
            // mounthly statistics view
            self.statisticsView.isHidden = viewModel.shouldHideStatisticsView()
            self.statisticsView.reloadView()

            // task bar view
            self.taskBarView.isHidden = viewModel.shouldHideTaskBarView()
            self.taskBarView.reloadView()

            // choose task view
            self.chooseTaskView.isHidden = viewModel.shouldHideChooseTaskView()
            self.chooseTaskViewHeightConstraint.constant = viewModel.getChooseTaskViewHeight()
            self.viewModel.removeLastTask()

            self.chooseTaskView.reloadView()
            self.updateChooseTaskTitle()

            self.trackingView.isHidden = viewModel.shouldHideTrackingView()
            self.trackingViewHeightConstraint.constant = viewModel.getTrackingViewHeight()
            self.trackingView.configure(model: viewModel.getModelForTrackingView())

            // absence view
            self.absenceView.isHidden = viewModel.shouldHideAbsenceView()
            self.absenceView.setLocalizedStrings()

            // map view
            self.mapPresenterView.isHidden = viewModel.shouldHideMapView()

            // show tracking button
            self.showTrackingButton.isHidden = viewModel.shouldHideTrackingButton()
            self.showTrackingButtonCenterAligment.priority = viewModel.hasDistanceMeasurement ? UILayoutPriority(rawValue: 250) : UILayoutPriority(rawValue: 850)

            // add ride view
            self.addRideView.isHidden = viewModel.shouldHideAddRideButton()
            self.addRideLeadingConstraint.priority = viewModel.shouldHideTrackingButton() ? UILayoutPriority(rawValue: 250) : UILayoutPriority(rawValue: 750)

            // distance hour limit
            self.updateMerkavaDistanceSettings()

            //select revacha client view
            self.selectRevachaClient.isHidden = viewModel.shouldHideSelectClientView()
            if self.viewModel.isRevacha{
                if UserDefaultsManager.revachaLastLoginType == 3{
                    self.selectRevachaClient.viewModel.type = .generalTraining
                }else if UserDefaultsManager.revachaLastLoginType == 2{
                    self.selectRevachaClient.viewModel.type = .training
                }else{
                    self.selectRevachaClient.viewModel.type = .treatment
                }
                self.selectRevechaClientHeightConstraint.constant = 190.0
                self.selectRevachaClient.trnsType = UserDefaultsManager.revachaLastLoginType
            }else{
                self.selectRevachaClient.viewModel.type = .officeTreatment
                self.selectRevechaClientHeightConstraint.constant = 190.0
                self.selectRevachaClient.trnsType = 6
            }
            self.selectRevachaClient.disableReportTypeTaskTypeTreantmentType(isDisable: self.trackingView.viewModel.shouldDisableLoginView())
            self.selectRevachaClient.setLocalizedStrings()
            self.selectRevachaClient.reloadView()

            if viewModel.shouldHideBarcodeView(){
                self.barcodeView.isHidden = viewModel.shouldHideBarcodeView()
            }else{
                self.barcodeView.updateList()
                self.barcodeView.isHidden = viewModel.shouldHideBarcodeView()
            }

            self.workScheduleView.isHidden = viewModel.shouldHideWorkScheduleView()
            self.workScheduleView.addViewModel(viewModel.workScheduleViewModel())

            self.viewModel.applyLastTask()
            if self.viewModel.isRevacha {
                switch UserDefaultsManager.revachaLastLoginType {
                case 3:
                    self.trackingView.eventsView.alpha = 0.5
                    self.trackingView.eventsView.isUserInteractionEnabled = false
                    break
                default:
                    self.trackingView.eventsView.isUserInteractionEnabled = true
                    self.trackingView.eventsView.alpha = 1
                }
            }
        }

//        if let data = self.readUserFromBundle(){
//            self.studentReportData = data
//            self.tbl_sperad.reloadData()
//        }
//
//        self.studentReportBgView.isHidden = false
//        self.dashboardLine.isHidden = true
//
//        self.statisticsView.isHidden = true
//        self.taskBarView.isHidden = true
//        self.chooseTaskView.isHidden = true
//        self.trackingView.isHidden = true
//        self.absenceView.isHidden = true
//        self.mapPresenterView.isHidden = true
//        self.selectRevachaClient.isHidden = true
//        self.barcodeView.isHidden = true
//        self.workScheduleView.isHidden = true
//        self.addRideView.isHidden = true
//        self.showTrackingButton.isHidden = true
//        self.viewStudentReport.isHidden = false
//        self.btn_confirm.isHidden = false
////        self.studentReportData = data
//        self.tbl_sperad.reloadData()



        self.openNotificationAction()
        self.checkLocationPermission()
    }

    func checkingDistanceMeasurement() {
        if self.viewModel.hasDistanceMeasurement {
            self.viewModel.checkLastUserDistance()
        }
    }

    func openNotificationAction() {
        if viewModel.hasNotificationAction() {
            if viewModel.shouldShowLoginConfirm() {
                self.showLoginConfirmView()
            }

            if viewModel.shouldShowLogoutConfirm() {
                self.showLogoutConfirmView()
            }

            if viewModel.shouldShowAbsenceConfirm() {
                self.showAbsenceConfirmView()
            }

            if viewModel.shouldShowMyReportsScreen() {
                self.showMyReports()
            }
        }

        viewModel.notificationType = nil
    }

    func showMyReports() {
        let vc = ViewSource.reportManagementScreen()
        vc.viewModel = ReportManagementViewModel(date: Date())
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    @objc func updateAccountInfo() {
        self.accountInfoView.updateMessageButtonBadge()
    }

    @objc func checkOfflineLabelVisibility(_ notification: Notification) {
//        if viewModel.offlineModeLabelHidden{
//            self.offlineLabel.isHidden = true
//        }else{
//            self.offlineLabel.isHidden = false
//        }
    }

    func showConfirmView(type: ConfirmViewType, checkHealth: Bool = true) {
        if type == .logoutConfirm && viewModel.shouldShowSalesAmountView() {
            self.showSalesAmountView()
            return
        }

        if type == .loginConfirm, checkHealth, ReachabilityManager.shared.hasInternetConnection {
            if self.viewModel.checkHealthDisclaimer() {
                self.viewModel.loadDisclaimerData()
                return
            }
        }

        if type == .loginConfirm, viewModel.shouldLoginWithPicture {
            let type: PictureReportType = viewModel.isWaitingForLogout ? .logoutAndLogin : .login
            self.showReportWithPictureView(type: type)
            return
        }

        if type == .logoutConfirm, viewModel.selectedTask == nil, viewModel.shouldLogoutWithPicture {
            self.showReportWithPictureView(type: .logout)
            return
        }
        
//        if type == .logoutSuccess && CompaniesDataManager.shared.hasNFCReportAppAutomatically(){
//            return
//        }
        
        showView(type: type)
        
    }

    func showView(type: ConfirmViewType) {
        let vc = ViewSource.confirmTaskView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        let task = viewModel.getTaskByConfirmType(type)
        let unknownTask = viewModel.getSelectedUnknownTask()
        let absence = viewModel.getAbsenceReport()
        let event = viewModel.selectedEvent
        vc.setViewModel(ConfirmTaskViewModel(confirmType: type, task: task, unknownTask: unknownTask, absence: absence, event: event))
        vc.delegate = self
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showReportWithPictureView(type: PictureReportType) {
        let vc = ViewSource.reportPictureView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ReportPictureViewModel(reportPicture: ReportPictureObj(reportType: type, task: viewModel.selectedTask))

        vc.viewModel.reportSended = { reports in
            self.viewModel.updateDataSuccessPictureReport(reports: reports, type: type.reportActionType)
            self.showConfirmView(type: type.confirmType)
        }

        vc.cancelTappedAction = {
            self.viewModel.cancelPictureReport()
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showSalesAmountView() {
        let vc = ViewSource.salesAmountView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.confirmTap = { sales in
            self.viewModel.sendSalesAmountReport(sales: sales)
        }
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showErrorView(title: String?, message: String?) {
        if (title ?? "").contains("-999") { return }
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: title, message: message)
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showAbsenceConfirmView() {
        let vc = ViewSource.absenceConfirmView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showSignedReportConfirmView() {
        let vc = ViewSource.signedReportConfirmView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showChooseTaskView() {
        let vc = ViewSource.taskListScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
    
    func showChooseTheraphyView() {
        let vc = ViewSource.selectTheraphyScreen()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.didSelectTherapy = { type in
            self.selectRevachaClient.reloadView()
        }
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showChooseEventView() {
        let listView = ViewSource.chooseListView()
        listView.viewModel = ChooseListViewModel(title: "SELECT_AN_EVENT".localized, data: self.viewModel.eventNames)
        listView.modalTransitionStyle = .crossDissolve
        listView.modalPresentationStyle = .overCurrentContext
        listView.delegate = self
        self.present(listView, animated: true, completion: nil)

    }

    func showScannerScreen() {
        let scannerVC = ViewSource.barcodeScannerScreen()
        scannerVC.modalPresentationStyle = .overCurrentContext
        scannerVC.delegate = self
        self.present(scannerVC, animated: true, completion: nil)
    }

    func showRevachaClientView() {
        selectRevachaClient.showClientSelection()
    }

    func showReportPictureView() {
        let vc = ViewSource.reportPictureView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        // vc.delegate = self
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @objc func showAddRideView() {
        let vc = ViewSource.addRideView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = AddRideViewModel()
        vc.addRideTapped = { type, value in
            self.viewModel.sendAddRide(type: type, value: value)
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showDistanceConfirmView(type: DistanceMeasurementType, hasLoginTitle: Bool) {
        let vc = ViewSource.distanceConfirmView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = DistanceConfirmViewModel(type: type, hasLoginTitle: hasLoginTitle)

        vc.confirmAction = {
            self.viewModel.sendDistanceMeasurementBy(type: type)
        }

        vc.closeAction = {
            self.viewModel.sendWaitingReportType()
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    func showTrackingDisclaimerWith(text: String?) {
        let vc = ViewSource.termsScreen()

        vc.viewModel = TermsViewModel(type: .tracking(disclaimer: text))

        vc.confirmTapped = {
            self.viewModel.sendAcceptDisclaimer()
        }

        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    func showHealthDisclaimer(type: HealthDisclaimerType, message: String? = nil) {
        let healthVC = ViewSource.healthDisclaimerView()
        healthVC.modalPresentationStyle = .overCurrentContext
        healthVC.modalTransitionStyle = .crossDissolve

        healthVC.viewModel = HealthDisclaimerViewModel(type: type, message: message)

        healthVC.aproveTapped = {
            self.viewModel.waitingForHealthConfirm = true
            self.viewModel.sendHealthDisclaimer()
        }

        healthVC.rejectTapped = {
            if CompaniesDataManager.shared.mustAcceptHealthDisclaimer() {
                self.showHealthDisclaimer(type: .rejected)
            } else {
                self.viewModel.sendReport(type: .workStart, remark: nil)
                // self.showConfirmView(type: .loginConfirm, checkHealth: false)
            }
        }

        self.present(healthVC, animated: true, completion: nil)
    }

    func showMultiReportView(type: MultiReportType) {
        let vc = ViewSource.multipleLoginView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.viewModel = MultiReportViewModel(type: type)
        vc.delegate = self

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickChat(_ sender: UIButton) {
        let vc = ViewSource.chatScreen()
        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    @IBAction func showTrackingAction(_ sender: Any) {
        self.viewModel.loadTrackingData()
    }

    func updateChooseTaskTitle() {
//        if CompaniesDataManager.shared.hasNFCReportMandatorySelectTaskTaskFeature() {
//            if self.viewModel.getChooseTaskTitle() == "SELECT_TASK".localized {
//                self.chooseTaskView.disbaleChooseTaskView(disable: false)
//            }else{
//                self.chooseTaskView.disbaleChooseTaskView(disable: true)
//            }
//        }
        self.chooseTaskView.selectTaskLabel.text = self.viewModel.getChooseTaskTitle()
        self.selectRevachaClient.selectClientLabel.text = self.viewModel.getChooseTaskTitle()
    }

    func updateRevachaButtonsTitle() {
        self.selectRevachaClient.selectClientLabel.text = self.viewModel.getChooseTaskTitle()
        self.selectRevachaClient.selectEventLabel.text = self.viewModel.getChooseEventTitle()
    }

    func updateTrackingView() {
        self.trackingView.configure(model: viewModel.getModelForTrackingView())
    }

    func updateMerkavaDistanceSettings() {
        self.hoursLimitLabel.text = viewModel.getHoursLimit()
        self.hoursCompletedLabel.text = viewModel.getHoursCompleted()

        if viewModel.shouldEnableAddRideView() {
            self.addRideView.isUserInteractionEnabled = true
            self.addRideView.alpha = 1
        } else {
            self.addRideView.isUserInteractionEnabled = false
            self.addRideView.alpha = 0.75
        }
        updateTrackingView()
    }

}

extension DashboardViewController{
    
    @IBAction func clickPreviousDate(_ sender: UIButton) {
        self.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate)!
        self.setStudentReportData()
    }
    
    @IBAction func clickNextDate(_ sender: UIButton) {
        self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate)!
        self.setStudentReportData()
    }

    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        if self.studentDataArr.count > 0{
//            if let dict = self.studentDataArr.first(where: {$0.scoreRYG!.R! == 0 && $0.scoreRYG!.Y! == 0 && $0.scoreRYG!.G! == 0 && $0.isUpdateRecrod == true}){
//                var error = ErrorObject()
//                error.error_message = "Please_select_traffic_light_score_in_student".localized + " \(dict.studentname ?? "")"
//                NavigationController.shared?.showErrorView(error: error)
//                return
//            }

//            if let dict = self.studentDataArr.first(where: {($0.scoreRYG!.R! == 1 || $0.scoreRYG!.Y! == 1) && $0.isUpdateRecrod == true }){
//                if let str = dict.comment, str.count == 0{
//                    var error = ErrorObject()
//                    error.error_message = "Please_add_notes_in_student".localized + " \(dict.studentname ?? "")"
//                    NavigationController.shared?.showErrorView(error: error)
//                    return
//                }
//            }
            if let dict = self.studentDataArr.first(where: { item in
                let r = item.scoreRYG?.R ?? 0
                let y = item.scoreRYG?.Y ?? 0
                let comment = item.comment?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                return (r == 1 || y == 1) && comment.isEmpty
            }) {
                var error = ErrorObject()
                error.error_message = "Please_add_notes_in_student".localized
                NavigationController.shared?.showErrorView(error: error)
                return
            }
            
            if let dict = self.studentDataArr.first(where: { item in
                let r = item.presenceConfirmation ?? 0
                let transTime: String
                
                if let coordinatorTime = item.trnsInCoordinator, !coordinatorTime.isEmpty {
                    transTime = coordinatorTime
                } else {
                    transTime = item.trnsTime ?? ""
                }
                
                return r == 1 && transTime.isEmpty
            }) {
                var error = ErrorObject()
                error.error_message = "Please_add_report_time_in_student".localized
                NavigationController.shared?.showErrorView(error: error)
                return
            }

            let completionReport = UpdateDailyStudentReportEndpoint(obj: self.studentDataArr)
            completionReport.apiCall {result, error in
                if error?.success ?? false {
                    NavigationController.shared?.showSuccessView(message: "Student_data_submitted_successfully".localized)
                    self.viewModel.loadData()
                } else {
                    if let err = error, let code = err.error_code, code != 334 {
                        NavigationController.shared?.showErrorView(error: error)
                    }
                }
            }
        }else{
            var error = ErrorObject()
            error.error_message = "No_student_report_data".localized
            NavigationController.shared?.showErrorView(error: error)
        }
    }

    @objc func clickEntryTime(sender: UIButton){
        view.endEditing(true)
        let vc = ViewSource.datePickerView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.config(isDate: false, maxDate: nil)
        vc.selectedValue = { value in
            if let dt = value{
                print("dt:", dt)
                self.studentDataArr[sender.tag].isUpdateRecrod = true
                if let currentDateTime = self.studentDataArr[sender.tag].trnsInCoordinator, currentDateTime.count > 0{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    let dateStr = dateFormatter.string(from: dt)
                    let selectedTimeDateArr = dateStr.components(separatedBy: " ")
                    let arr1 = currentDateTime.components(separatedBy: " ")
                    let time = "\(arr1.first ?? self.getSelectedDateInString(formate: "yyyy-MM-dd")) \(selectedTimeDateArr.last!)"
                    print("time:", time)
                    self.studentDataArr[sender.tag].trnsInCoordinator = time
                }else{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dateStr = dateFormatter.string(from: dt)
                    print("dateStr:", dateStr)
                    let arr = dateStr.components(separatedBy: " ")
                    let time = "\(self.getSelectedDateInString(formate: "yyyy-MM-dd")) \(arr.last!)"
                    print("time:", time)
                    self.studentDataArr[sender.tag].trnsTime = time
                }
//                let time = "\(self.getSelectedDateInString(formate: "yyyy-MM-dd")) \(arr.last!)"
//                print("time:", time)
//                self.studentDataArr[sender.tag].trnsTime = time
                self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
            }
        }

        self.present(vc, animated: true, completion: nil)
    }

    @objc func clickYes(sender: UIButton){
        if self.studentDataArr.count > 0{
            self.studentDataArr[sender.tag].presenceConfirmation = 1
            self.studentDataArr[sender.tag].isUpdateRecrod = true
            self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
        }
    }

    @objc func clickNo(sender: UIButton){
        if self.studentDataArr.count > 0{
            self.studentDataArr[sender.tag].presenceConfirmation = 0
            self.studentDataArr[sender.tag].isUpdateRecrod = true
            self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
        }
    }

    @objc func clickRed(sender: UIButton){
        if self.studentDataArr.count > 0{
            let student = self.studentDataArr[sender.tag]
            self.studentDataArr[sender.tag].isUpdateRecrod = true
            if let ryg = student.scoreRYG, let r = ryg.R, r == 0{
                self.studentDataArr[sender.tag].scoreRYG?.R = 1
                self.studentDataArr[sender.tag].scoreRYG?.Y = 0
                self.studentDataArr[sender.tag].scoreRYG?.G = 0
//                self.studentDataArr[sender.tag].comment = ""
                self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
            }

        }
    }

    @objc func clickYellow(sender: UIButton){
        if self.studentDataArr.count > 0{
            let student = self.studentDataArr[sender.tag]
            self.studentDataArr[sender.tag].isUpdateRecrod = true
            if let ryg = student.scoreRYG, let y = ryg.Y, y == 0{
                self.studentDataArr[sender.tag].scoreRYG?.R = 0
                self.studentDataArr[sender.tag].scoreRYG?.Y = 1
                self.studentDataArr[sender.tag].scoreRYG?.G = 0
//                self.studentDataArr[sender.tag].comment = ""
                self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
            }
        }
    }

    @objc func clickGreen(sender: UIButton){
        if self.studentDataArr.count > 0{
            let student = self.studentDataArr[sender.tag]
            self.studentDataArr[sender.tag].isUpdateRecrod = true
            if let ryg = student.scoreRYG, let g = ryg.G, g == 0{
                self.studentDataArr[sender.tag].scoreRYG?.R = 0
                self.studentDataArr[sender.tag].scoreRYG?.Y = 0
                self.studentDataArr[sender.tag].scoreRYG?.G = 1
//                self.studentDataArr[sender.tag].comment = ""
                self.tbl_sperad.reloadRows(at: [IndexPath(row: sender.tag + 1, section: 0)], with: .none)
            }

        }
    }

    
}

//Approved Hours
extension DashboardViewController  {
    func showApproveHour(approvedHours : ApproveHourObj?) {
        if approvedHours != nil{
            let vc = ViewSource.approveHourView()
            vc.approvedHour = approvedHours
            self.modalPresentationCapturesStatusBarAppearance = true
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .overCurrentContext

            self.present(navVC, animated: true)
        }
    }
}

extension DashboardViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.studentDataArr[textField.tag].comment = textField.text
        self.studentDataArr[textField.tag].isUpdateRecrod = true
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.studentDataArr[textField.tag].comment = textField.text
        self.studentDataArr[textField.tag].isUpdateRecrod = true
    }
    
    @objc func textfiledValueChange(_ textField: UITextField) {
        print(textField.text)
        self.studentDataArr[textField.tag].comment = textField.text
        self.studentDataArr[textField.tag].isUpdateRecrod = true
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate{

    func setupTableview(){

        self.tbl_sperad.dataSource = self
        self.tbl_sperad.delegate = self

        let nibCell = UINib(nibName: "SDR_HeaderCell", bundle: nil)
        self.tbl_sperad.register(nibCell, forCellReuseIdentifier: "SDR_HeaderCell")

        let nibCellRTL = UINib(nibName: "SDR_HeaderCellRTL", bundle: nil)
        self.tbl_sperad.register(nibCellRTL, forCellReuseIdentifier: "SDR_HeaderCellRTL")

        let nibCell1 = UINib(nibName: "SDR_DataCell", bundle: nil)
        self.tbl_sperad.register(nibCell1, forCellReuseIdentifier: "SDR_DataCell")

        let nibCell1RTL = UINib(nibName: "SDR_DataCellRTL", bundle: nil)
        self.tbl_sperad.register(nibCell1RTL, forCellReuseIdentifier: "SDR_DataCellRTL")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.studentDataArr.count > 0{
            return self.studentDataArr.count + 1
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if self.getCurrentLanguage() == "he" || self.getCurrentLanguage() == "ar"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SDR_HeaderCellRTL", for: indexPath) as! SDR_HeaderCellRTL
                cell.setTitle()
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SDR_HeaderCell", for: indexPath) as! SDR_HeaderCell
                cell.setTitle()
                return cell
            }
        }else{

            if self.getCurrentLanguage() == "he" || self.getCurrentLanguage() == "ar"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SDR_DataCellRTL", for: indexPath) as! SDR_DataCellRTL
                cell.setString()
                if self.studentDataArr.count > 0{
                    let dict = self.studentDataArr[indexPath.row - 1]

                    cell.lbl_studentName.text = "-"

                    if let str = dict.studentname, str.count > 0{
                        cell.lbl_studentName.text = str
                    }

                    cell.img_yes.image = UIImage(named: "radio_unselect")
                    cell.img_no.image = UIImage(named: "radio_unselect")
                    if let present = dict.presenceConfirmation, present == 1{
                        cell.img_yes.image = UIImage(named: "radio_select")
                    }else{
                        cell.img_no.image = UIImage(named: "radio_select")
                    }

                    cell.img_green.border(width: 0, color: UIColor.clear.cgColor)
                    cell.img_yellow.border(width: 0, color: UIColor.clear.cgColor)
                    cell.img_red.border(width: 0, color: UIColor.clear.cgColor)
                    if let srg = dict.scoreRYG{
                        if let r = srg.R, r == 1{
                            cell.img_red.border(width: 1.5, color: UIColor.black.cgColor)
                        }

                        if let y = srg.Y, y == 1{
                            cell.img_yellow.border(width: 1.5, color: UIColor.black.cgColor)
                        }

                        if let g = srg.G, g == 1{
                            cell.img_green.border(width: 1.5, color: UIColor.black.cgColor)
                        }
                    }

                    cell.txt_notes.text = ""
                    if let str = dict.comment, str.count > 0{
                        cell.txt_notes.text = str
                    }

                    cell.btn_entryTime.setTitle("--:--", for: .normal)
                    if let str = dict.trnsInCoordinator, str.count > 0{
                        let time = str.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss.SSS", to: "HH:mm")
                        cell.btn_entryTime.setTitle(time, for: .normal)
                    }else if let str = dict.trnsTime, str.count > 0{
                        let time = str.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss", to: "HH:mm")
                        cell.btn_entryTime.setTitle(time, for: .normal)
                    }
                }
                
                cell.lbl_number.text = "\(indexPath.row)"

                cell.btn_entryTime.tag = indexPath.row - 1
                cell.btn_entryTime.addTarget(self, action: #selector(self.clickEntryTime), for: .touchUpInside)

                cell.btn_no.tag = indexPath.row - 1
                cell.btn_no.addTarget(self, action: #selector(self.clickNo), for: .touchUpInside)

                cell.btn_yes.tag = indexPath.row - 1
                cell.btn_yes.addTarget(self, action: #selector(self.clickYes), for: .touchUpInside)

                cell.btn_red.tag = indexPath.row - 1
                cell.btn_red.addTarget(self, action: #selector(self.clickRed), for: .touchUpInside)

                cell.btn_yellow.tag = indexPath.row - 1
                cell.btn_yellow.addTarget(self, action: #selector(self.clickYellow), for: .touchUpInside)

                cell.btn_green.tag = indexPath.row - 1
                cell.btn_green.addTarget(self, action: #selector(self.clickGreen), for: .touchUpInside)

                cell.txt_notes.tag = indexPath.row - 1
                cell.txt_notes.delegate = self
                cell.txt_notes.addTarget(self, action: #selector(self.textfiledValueChange(_:)), for: .editingChanged)
                
                let today = Calendar.current.startOfDay(for: Date())
                let selectedDateOnly = Calendar.current.startOfDay(for: self.selectedDate)
                if selectedDateOnly > today {
                    cell.contentView.alpha = 0.5
                    cell.btn_entryTime.isUserInteractionEnabled = false
                    cell.btn_no.isUserInteractionEnabled = false
                    cell.btn_yes.isUserInteractionEnabled = false
                    cell.btn_red.isUserInteractionEnabled = false
                    cell.btn_yellow.isUserInteractionEnabled = false
                    cell.btn_green.isUserInteractionEnabled = false
                    cell.txt_notes.isUserInteractionEnabled = false
                }else{
                    cell.contentView.alpha = 1.0
                    cell.btn_entryTime.isUserInteractionEnabled = true
                    cell.btn_no.isUserInteractionEnabled = true
                    cell.btn_yes.isUserInteractionEnabled = true
                    cell.btn_red.isUserInteractionEnabled = true
                    cell.btn_yellow.isUserInteractionEnabled = true
                    cell.btn_green.isUserInteractionEnabled = true
                    cell.txt_notes.isUserInteractionEnabled = true
                }

                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SDR_DataCell", for: indexPath) as! SDR_DataCell
                cell.setString()
                if self.studentDataArr.count > 0{
                    let dict = self.studentDataArr[indexPath.row - 1]

                    cell.lbl_studentName.text = "-"

                    if let str = dict.studentname, str.count > 0{
                        cell.lbl_studentName.text = str
                    }

                    cell.img_yes.image = UIImage(named: "radio_unselect")
                    cell.img_no.image = UIImage(named: "radio_unselect")
                    if let present = dict.presenceConfirmation, present == 1{
                        cell.img_yes.image = UIImage(named: "radio_select")
                    }else{
                        cell.img_no.image = UIImage(named: "radio_select")
                    }

                    cell.img_green.border(width: 0, color: UIColor.clear.cgColor)
                    cell.img_yellow.border(width: 0, color: UIColor.clear.cgColor)
                    cell.img_red.border(width: 0, color: UIColor.clear.cgColor)
                    if let srg = dict.scoreRYG{
                        if let r = srg.R, r == 1{
                            cell.img_red.border(width: 1.5, color: UIColor.black.cgColor)
                        }

                        if let y = srg.Y, y == 1{
                            cell.img_yellow.border(width: 1.5, color: UIColor.black.cgColor)
                        }

                        if let g = srg.G, g == 1{
                            cell.img_green.border(width: 1.5, color: UIColor.black.cgColor)
                        }
                    }

                    cell.txt_notes.text = ""
                    if let str = dict.comment, str.count > 0{
                        cell.txt_notes.text = str
                    }

                    cell.btn_entryTime.setTitle("--:--", for: .normal)
                    if let str = dict.trnsInCoordinator, str.count > 0{
                        let time = str.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss.SSS", to: "HH:mm")
                        cell.btn_entryTime.setTitle(time, for: .normal)
                    }else if let str = dict.trnsTime, str.count > 0{
                        let time = str.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss", to: "HH:mm")
                        cell.btn_entryTime.setTitle(time, for: .normal)
                    }

                }
                cell.lbl_number.text = "\(indexPath.row)"

                cell.btn_entryTime.tag = indexPath.row - 1
                cell.btn_entryTime.addTarget(self, action: #selector(self.clickEntryTime), for: .touchUpInside)

                cell.btn_no.tag = indexPath.row - 1
                cell.btn_no.addTarget(self, action: #selector(self.clickNo), for: .touchUpInside)

                cell.btn_yes.tag = indexPath.row - 1
                cell.btn_yes.addTarget(self, action: #selector(self.clickYes), for: .touchUpInside)

                cell.btn_red.tag = indexPath.row - 1
                cell.btn_red.addTarget(self, action: #selector(self.clickRed), for: .touchUpInside)

                cell.btn_yellow.tag = indexPath.row - 1
                cell.btn_yellow.addTarget(self, action: #selector(self.clickYellow), for: .touchUpInside)

                cell.btn_green.tag = indexPath.row - 1
                cell.btn_green.addTarget(self, action: #selector(self.clickGreen), for: .touchUpInside)

                cell.txt_notes.tag = indexPath.row - 1
                cell.txt_notes.delegate = self
                cell.txt_notes.addTarget(self, action: #selector(self.textfiledValueChange(_:)), for: .editingChanged)
                
                
                let today = Calendar.current.startOfDay(for: Date())
                let selectedDateOnly = Calendar.current.startOfDay(for: self.selectedDate)
                if selectedDateOnly > today {
                    cell.contentView.alpha = 0.5
                    cell.btn_entryTime.isUserInteractionEnabled = false
                    cell.btn_no.isUserInteractionEnabled = false
                    cell.btn_yes.isUserInteractionEnabled = false
                    cell.btn_red.isUserInteractionEnabled = false
                    cell.btn_yellow.isUserInteractionEnabled = false
                    cell.btn_green.isUserInteractionEnabled = false
                    cell.txt_notes.isUserInteractionEnabled = false
                }else{
                    cell.contentView.alpha = 1.0
                    cell.btn_entryTime.isUserInteractionEnabled = true
                    cell.btn_no.isUserInteractionEnabled = true
                    cell.btn_yes.isUserInteractionEnabled = true
                    cell.btn_red.isUserInteractionEnabled = true
                    cell.btn_yellow.isUserInteractionEnabled = true
                    cell.btn_green.isUserInteractionEnabled = true
                    cell.txt_notes.isUserInteractionEnabled = true
                }

                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 50
        }else{
            return UITableView.automaticDimension
        }
    }
}

extension DashboardViewController: EventsRevachaDelegate {
    func showEvents() {
        selectRevachaClient.viewModel.type = .treatment
        refreshView()
        refreshView()
        refreshStrings()
        self.isRevachaAction = false
    }
}
// MARK: - SideBarViewDelegate
extension DashboardViewController: AccountInfoViewDelegate {
    @objc func showChooseCompanyView() {
        let vc = ViewSource.chooseListView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        let title = "CHOOSE_COMPANY"
        let data = CompaniesDataManager.shared.getAvailableCompanyNames()

        vc.viewModel = ChooseListViewModel(title: title, data: data)

        vc.choosedType = { index, _ in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CompanyIndexChanged"), object: self, userInfo: nil)
            let companies = CompaniesDataManager.shared.getAvailableCompanies()
            if companies.count > index {
                let selectedCompany = companies[index]
                CompaniesDataManager.shared.setCurrentClientId(selectedCompany.clientId)
            }
            self.refreshView()
            self.refreshStrings()
            self.viewModel.loadData()
            print("Formdata = \(CompaniesDataManager.shared.getFormsData())")
            //self.showApproveHour(approvedHours: CompaniesDataManager.shared.getApprovedHours())
            // self.config()
            // self.delegate?.userDidChangeCompany()
        }

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
    func userDidTapImageButton() {
        print("Image button tapped")
        showChooseCompanyView()

    }

    func userDidTapMessagesButton() {
        let vc = ViewSource.notificationScreen()
        NavigationController.shared?.pushViewController(vc, animated: true)

//        let vc = ViewSource.studentDailyReportScreen()
//        if let data = CompaniesDataManager.shared.getCurrentCompanyDailyStudentReport(){
//            vc.studentReportData = data
//        }
//        NavigationController.shared?.pushViewController(vc, animated: true)
    }

    func userDidTapSettingsButton() {
        let vc = ViewSource.sideBarView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = SideBarViewModel(type: .regular)
        vc.delegate = self
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

}
// MARK: - SideBarViewDelegate
extension DashboardViewController: SideBarViewDelegate {
    func userDidTapLanguage() {
        self.viewModel.loadData()
        self.refreshStrings()
        self.tbl_sperad.reloadData()
    }
}
// MARK: - MultiReportViewDelegate
extension DashboardViewController: MultiReportViewDelegate {
    func userDidTapConfirm(_ multiReportObject: MultipleReportObj) {
        viewModel.sendMultipleReport(multipleReport: multiReportObject)
    }
}
// MARK: - TaskConfirmViewDelegate
extension DashboardViewController: TaskConfirmViewDelegate {
    func userDidTapConfirm(_ type: ConfirmActionType, _ task: TaskObj?, _ aditionalButton: AddonButtonObj?, _ remark: String?, _ event: RevachaEventObj?) {
        isRevachaAction = false
        if type == .logout && task != nil && viewModel.shouldLogoutWithPicture {
            showReportWithPictureView(type: .logout)
        } else if  type == .logout && task != nil && (CompaniesDataManager.shared.getAppApplyCommentListOnExit() == 1 || CompaniesDataManager.shared.getAppApplyCommentListOnEntry() == 1  || CompaniesDataManager.shared.getAppReportCompletionNoteExit() == 1 || CompaniesDataManager.shared.getAppReportCompletionNoteEntry() == 1) {
            if remark != nil && remark != ""{
                viewModel.userDidTapConfirm(type: type, task: task, remark: remark, isNFCRead: false)
            } else {
                showView(type: .logoutMustNote)
                let task = viewModel.getTaskByConfirmType(.logoutMustNote)
                let unknownTask = viewModel.getSelectedUnknownTask()
                let absence = viewModel.getAbsenceReport()
                let event = viewModel.selectedEvent
                
                print("task", task)
                print("unknownTask", unknownTask)
                print("absence", absence)
                print("event", event)
                print("getConfirmActionType", "logout")
            }
        } else if  type == .confirm{
            print("confirm")
        }  else {
            if let event = event {
                viewModel.userDidTapConfirm(with: task, event: event, remark: remark)
            } else {
                viewModel.userDidTapConfirm(type: type, task: task, remark: remark, isNFCRead: false)
            }
        }
    }
}
// MARK: - AbsenceConfirmViewDelegate
extension DashboardViewController: AbsenceConfirmViewDelegate {
    func userDidTapAbsenceConfirm(_ type: ConfirmActionType, _ absence: AbsenceObj, _ employee: EmployeeByDepartmentObj?) {
        self.viewModel.setAbsenceReport(report: absence)
        self.viewModel.setAbsenceEmployee(employee: employee)
        self.showConfirmView(type: .absenceConfirm)
    }
}
// MARK: - ChooseTaskDelegate
extension DashboardViewController: ChooseTaskDelegate {
    func userDidSelectTask(_ task: TaskObj?) {
        self.viewModel.setSelectedTask(task: task)
        trackingView.changeSelectedTask(task)

        self.updateChooseTaskTitle()
        self.updateRevachaButtonsTitle()
        self.updateMerkavaDistanceSettings()

        if self.viewModel.isRevacha || self.viewModel.isHolocaust {
            switch isRevachaAction {
            case true :
                self.showChooseEventView()
                break
            case false :
                self.getNumberOfHoursLeftForTask(task)
                break
            }
        } else {
            if !viewModel.isBituachLeumiClient {

                if let formArr = CompaniesDataManager.shared.getFormsData(), formArr.count > 0, let temptask = task{
                    let arr = formArr.filter({$0.taskId == temptask.taskId})
                    if arr.count > 0{
                        let vc = ViewSource.formWebViewScreen()
                        if let url = CompaniesDataManager.shared.getFormsURL(type: 1){
                            vc.url = url
                        }
                        if let formName = CompaniesDataManager.shared.getFormName(type: 1){
                            vc.formName = formName
                        }
                        vc.actionTag = 0
                        vc.formdataArr = arr
                        NavigationController.shared?.pushViewController(vc, animated: true)
                        return
                    }
//                    if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
//                        self.showErrorView(title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
//                        return
//                    }
//                    self.showConfirmView(type: .loginConfirm)
                }else{
                    if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature() {
                        if DashboardViewController.isRecentNFCScan {
                            self.cancelTimer()
                            self.showConfirmView(type: .loginConfirm)
                        }else{
                            self.showErrorView(title: nil, message: "Reporting_without_NFC_is_not_allowed_Please_use_NFC_to_complete_the_report".localized)
                            return
                        }
                    }
                    self.showConfirmView(type: .loginConfirm)
                }
            }else if viewModel.isListOpenedForPatientNotAtHome {
                self.viewModel.patientNotAtHome()
                self.viewModel.isListOpenedForPatientNotAtHome = false
            }else{
                self.showConfirmView(type: .loginConfirm)
            }
        }
    }

    func userShouldSelectProject(forTask withName: String) {
        let listView = ViewSource.extendedListView()
        listView.viewModel = ExtendedListViewModel(type: .project, models: viewModel.projects, parameters: withName)
        listView.modalTransitionStyle = .crossDissolve
        listView.modalPresentationStyle = .overCurrentContext
        listView.delegate = self
        self.present(listView, animated: true, completion: nil)
    }

    func userDidCloseList(_ list: TaskListView) {
        self.viewModel.isListOpenedForPatientNotAtHome = false
    }
}

// MARK: - TaskBarViewDelegate
extension DashboardViewController: TaskBarViewDelegate {
    func userDidTapLocation(_ task: TaskBarItem) {
        if let lat = Double(task.task?.lat ?? ""), let lon = Double(task.task?.lon ?? "") {
            let location = CLLocation(latitude: lat, longitude: lon)

            UIView.animate(withDuration: 0.5, animations: {
                self.infoViewHeightConstraint.constant = 115
                //                self.trackingViewHeightConstraint.constant = 180
                self.statisticsView.isHidden = true
                self.view.layoutIfNeeded()
            }) { (_) in
                self.mapView = MapView(frame: self.mapPresenterView.layer.bounds)
                self.mapView?.delegate = self
                self.mapView?.changeLocation(location: location)
                self.mapView?.gmsMapView.isUserInteractionEnabled = true
                self.mapPresenterView.addSubview(self.mapView!)
                self.mapPresenterView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }

    func userDidTapTask() {
        self.infoViewHeightConstraint.constant = 140
        self.view.layoutIfNeeded()
        viewModel.bituachLeumiMonthStatsHidden = !viewModel.bituachLeumiMonthStatsHidden

        UIView.animate(withDuration: 0.3) {
            self.statisticsView.isHidden = !self.viewModel.needShowMonthStatistics()
            self.mapPresenterView.isHidden = true

            self.mapView?.removeFromSuperview()

            self.view.layoutIfNeeded()
        }
    }
}
// MARK: - MapViewDelegate
extension DashboardViewController: MapViewDelegate {
    func userDidHideMap() {
        self.infoViewHeightConstraint.constant = 140
        //        self.trackingViewHeightConstraint.constant = 220

        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.3) {
            self.statisticsView.isHidden = !self.viewModel.hasMonthStatistics
            self.mapPresenterView.isHidden = true

            self.mapView?.removeFromSuperview()

            self.view.layoutIfNeeded()
        }
    }
}
// MARK: - DashboardViewModelDelegate
extension DashboardViewController: DashboardViewModelDelegate {
    
    func shouldUpdateTimer() {
        self.cancelTimer()
    }
    
    func shouldClearEvent() {
        updateRevachaButtonsTitle()
    }

    func shouldRefreshView() {
        self.refreshView()
    }

    func shouldShowChooseTaskView() {
        self.showChooseTaskView()
    }

    func shouldUpdateTask() {
        self.updateChooseTaskTitle()
        self.updateRevachaButtonsTitle()
        self.updateMerkavaDistanceSettings()
    }

    func shouldShowError(_ error: ErrorObject?) {
        guard error?.error_code != -999 else { return }
        NavigationController.shared?.showErrorView(error: error)
        self.updateChooseTaskTitle()
        self.updateRevachaButtonsTitle()
    }

    func shouldShowError(_ message: String?) {
        guard let message = message else { return }
        self.showErrorView(title: nil, message: message)
        self.updateChooseTaskTitle()
        self.updateRevachaButtonsTitle()
    }
    func shouldShowErrorForNFC(_ message : String?, title: String?){
        guard let message = message else { return }
        self.showErrorView(title: title, message: message)
    }

    func shouldShowTrackingMap() {
        UIView.animate(withDuration: 0.5, animations: {
            self.infoViewHeightConstraint.constant = 115
            //            self.trackingViewHeightConstraint.constant = 180
            self.statisticsView.isHidden = true
            self.view.layoutIfNeeded()
        }) { (_) in
            self.mapView = MapView(frame: self.mapPresenterView.layer.bounds)
            self.mapView?.delegate = self
            self.mapView?.markers(trackReports: self.viewModel.getTrackingReports())
            self.mapView?.gmsMapView.isUserInteractionEnabled = true
            self.mapPresenterView.addSubview(self.mapView!)
            self.mapPresenterView.isHidden = false
            self.view.layoutIfNeeded()
        }
    }

    func shouldShowConfirmView(_ type: ConfirmViewType, _ checkHealth: Bool) {
        self.showConfirmView(type: type, checkHealth: checkHealth)
    }

    func shouldRefreshTrackingView() {
        self.updateTrackingView()
    }

    func shouldShowTrackedDistanceView() {
        self.showDistanceConfirmView(type: .showTracked, hasLoginTitle: false)
    }

    func shouldShowStartTrackingView(_ hasLogin: Bool) {
        self.showDistanceConfirmView(type: .startTracking, hasLoginTitle: hasLogin)
    }

    func shouldShowStopTrackingView() {
        self.showDistanceConfirmView(type: .stopTracking, hasLoginTitle: false)
    }
    func shouldShowTrackDisclaimerWith(text: String?) {
        self.showTrackingDisclaimerWith(text: text)
    }

    func shouldShowHealthDisclaimer(_ type: HealthDisclaimerType, _ message: String?) {
        self.showHealthDisclaimer(type: type, message: message)
    }

    func shouldShowRequestCompletionView(_ viewModel: RequestCompletionViewModel) {
        let vc = ViewSource.requestCompletionScreen()
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        NavigationController.shared?.present(vc, animated: true)
    }
}
// MARK: - ReachabilityObserverDelegate
extension DashboardViewController: ReachabilityObserverDelegate {
    func reachabilityChanged(_ isReachable: Bool) {
        ReachabilityManager.shared.hasInternetConnection = isReachable

        if !isReachable {
            print("No internet connection")
        } else {
            print("Has Internet connection")
//            viewModel.checkSavedRequests(isFromReachability: true)
            viewModel.newFetchOfflineReport(isFromReachability: true)
        }
    }
}

extension DashboardViewController: ChooseListViewDelegate {

    func didSelectItem(at index: Int, title: String) {
        viewModel.selectEvent(at: index)
        updateRevachaButtonsTitle()
        showView(type: .loginConfirm)
    }
}

extension DashboardViewController: BarcodeScannerDelegate {

    func didScan(taskId: String, taskName: String) {
        if let task = viewModel.taskWithId(taskId) {
            didFindTask(task)
        } else {
            let task = TaskObj(taskId: taskId, taskName: taskName, projectId: nil, projectName: nil, remark: nil, hoursLimit: nil, hoursCompleted: nil, distanceSettings: nil, fromTime: nil, toTime: nil)
            didNotFindTask(task)
        }
    }

    private func didFindTask(_ task: TaskObj) {
        viewModel.setSelectedTaskFromBarcode(task: task)

        self.updateChooseTaskTitle()
        self.updateRevachaButtonsTitle()
        self.updateMerkavaDistanceSettings()
    }

    private func didNotFindTask(_ task: TaskObj) {
        let alert = UIAlertController(title: "WARNING".localized, message: "UNKNOWN_TASK_ERROR_MESSAGE".localized, preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "YES".localized, style: .default) { action in
            self.viewModel.setSelectedUnknownTask(task: task)
            self.updateChooseTaskTitle()
            self.updateRevachaButtonsTitle()
            self.updateMerkavaDistanceSettings()
        }
        alert.addAction(yesAction)

        let noAction = UIAlertAction(title: "NO".localized, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(noAction)

        present(alert, animated: true, completion: nil)
    }
}

extension DashboardViewController: ExtendedListViewDelegate {

    func didSelectItem(type: ExtendedListContentType, itemId: Int?, parameters: Any?) {
        if type == .project {
            if let projectId = itemId, let taskName = parameters as? String {
                viewModel.createTask(taskName, forProject: projectId) { [weak self] in
                    self?.updateChooseTaskTitle()
                    self?.updateRevachaButtonsTitle()
                    self?.updateMerkavaDistanceSettings()
                }
            }
        } else if type == .locationName, let locationId = itemId {
            viewModel.selectLocationName(with: locationId)
            if viewModel.bituachLeumiActionType == .serviceEntry {
                self.showConfirmView(type: .loginConfirm)
            } else {
                self.showConfirmView(type: .logoutConfirm)
            }
        }
    }
}

extension DashboardViewController: TrackingViewDelegate {
    func AdditionalButtonAction(_ action: AdditionalButtonsAction) {
        switch action {
        case .exitFromService(let actionType):
            print("exitService", actionType!)
            guard UserDefaultsManager.connectionServiceCount > 0 else {
                showNoInternetPopup()
                return
            }
            if CompaniesDataManager.shared.hasFormsServiceExitFeature(){
                if let arr = CompaniesDataManager.shared.getExitServiceFormCount(), arr.count > 0{
                    let msgStr = String(format: "You_have_to_fill".localized, arguments: [arr.count])
                    let otherAlert = UIAlertController(title: "", message: msgStr, preferredStyle: .alert)
                    let printSomething = UIAlertAction(title: "SHOW_TRAKING_CONFIRM_TITLE".localized, style: .default) { _ in
                        let vc = ViewSource.formWebViewScreen()
                        if let url = CompaniesDataManager.shared.getFormsURL(type: 4){
                            vc.url = url
                        }
                        if let formName = CompaniesDataManager.shared.getFormName(type: 4){
                            vc.formName = formName
                        }
                        vc.mandotoryBeforeReport = CompaniesDataManager.shared.hasFormsMandoryBeforeReportFeature(type: 4)
                        vc.actionTag = 5
                        vc.formdataArr = arr
                        NavigationController.shared?.pushViewController(vc, animated: true)
                    }
                    let cancelBtn = UIAlertAction(title: "cancel".localized, style: .cancel)
                    otherAlert.addAction(printSomething)
                    otherAlert.addAction(cancelBtn)
                    self.present(otherAlert, animated: true)
                }
            }
        case .returnFromService(let actionType):
            print("enter service", actionType!)
            guard UserDefaultsManager.connectionServiceCount > 0 else {
                showNoInternetPopup()
                return
            }
            if CompaniesDataManager.shared.hasFormsServiceEntryFeature(){
                if let arr = CompaniesDataManager.shared.getEnterServiceFormCount(), arr.count > 0{
                    let msgStr = String(format: "You_have_to_fill".localized, arguments: [arr.count])
                    let otherAlert = UIAlertController(title: "", message: msgStr, preferredStyle: .alert)
                    let printSomething = UIAlertAction(title: "SHOW_TRAKING_CONFIRM_TITLE".localized, style: .default) { _ in
                        let vc = ViewSource.formWebViewScreen()
                        if let url = CompaniesDataManager.shared.getFormsURL(type: 3){
                            vc.url = url
                        }
                        if let formName = CompaniesDataManager.shared.getFormName(type: 3){
                            vc.formName = formName
                        }
                        vc.mandotoryBeforeReport = CompaniesDataManager.shared.hasFormsMandoryBeforeReportFeature(type: 3)
                        vc.actionTag = 4
                        vc.formdataArr = arr
                        NavigationController.shared?.pushViewController(vc, animated: true)
                    }
                    let cancelBtn = UIAlertAction(title: "cancel".localized, style: .cancel)
                    otherAlert.addAction(printSomething)
                    otherAlert.addAction(cancelBtn)
                    self.present(otherAlert, animated: true)
                }
            }
        }
    }

    func bituachLeumiMadeAction(_ action: BituachLeumiAdditionalAction) {
        switch action {
        case .absence:
            guard UserDefaultsManager.connectionServiceCount > 0 else {
                showNoInternetPopup()
                return
            }
            showAbsenceConfirmView()
        case .sampleReport(let actionType):
            sampleReport(actionType)
        case .serviceEntry(let actionType):
            serviceEntry(actionType)
        case .serviceExit(let actionType):
            serviceExit(actionType)
        case .patientNotAtHome:
            patientNotAtHome()
        }
    }
}

//Bituach Leumi action methods
private extension DashboardViewController {

    func sampleReport(_ actionType: ReportActionType?) {
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            showNoInternetPopup()
            return
        }
        guard LocationManager.shared.hasPermission() else {
            return
        }

        if viewModel.shoulShowChooseTaskError() {
            self.showErrorView(title: "421", message: "421".localized)
        } else {
            viewModel.sendSampleReport()
        }
    }

    func serviceEntry(_ actionType: ReportActionType?) {
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            showNoInternetPopup()
            return
        }
        if viewModel.shoulShowChooseTaskError() {
            self.showErrorView(title: "421", message: "421".localized)
        } else {
            showLocationNames(actionType)
        }
    }

    func serviceExit(_ actionType: ReportActionType?) {
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            showNoInternetPopup()
            return
        }
        if viewModel.shoulShowChooseTaskError() {
            self.showErrorView(title: "421", message: "421".localized)
        } else {
            showLocationNames(actionType)
        }
    }

    func showLocationNames(_ actionType: ReportActionType?) {

        if actionType == .serviceExit{
//            if CompaniesDataManager.shared.hasFormsServiceExitFeature(){
//                if let arr = CompaniesDataManager.shared.getExitServiceFormCount(), arr.count > 0{
//                    let msgStr = String(format: "You_have_to_fill".localized, arguments: [arr.count])
//                    let otherAlert = UIAlertController(title: "", message: msgStr, preferredStyle: .alert)
//                    let printSomething = UIAlertAction(title: "SHOW_TRAKING_CONFIRM_TITLE".localized, style: .default) { _ in
//                        let vc = ViewSource.formWebViewScreen()
//                        if let url = CompaniesDataManager.shared.getFormsURL(type: 4){
//                            vc.url = url
//                        }
//                        if let formName = CompaniesDataManager.shared.getFormName(type: 4){
//                            vc.formName = formName
//                        }
//                        vc.mandotoryBeforeReport = CompaniesDataManager.shared.hasFormsMandoryBeforeReportFeature(type: 4)
//                        vc.actionTag = 2
//                        vc.formdataArr = arr
//                        NavigationController.shared?.pushViewController(vc, animated: true)
//                    }
//                    let cancelBtn = UIAlertAction(title: "cancel".localized, style: .cancel)
//                    otherAlert.addAction(printSomething)
//                    otherAlert.addAction(cancelBtn)
//                    self.present(otherAlert, animated: true)
//                }
//            }else{
//                viewModel.bituachLeumiActionType = actionType
//
//                let listView = ViewSource.extendedListView()
//                listView.viewModel = ExtendedListViewModel(type: .locationName, models: viewModel.locationNames, parameters: nil)
//                listView.modalTransitionStyle = .crossDissolve
//                listView.modalPresentationStyle = .overCurrentContext
//                listView.delegate = self
//                self.present(listView, animated: true, completion: nil)
//            }
            viewModel.bituachLeumiActionType = actionType

            let listView = ViewSource.extendedListView()
            listView.viewModel = ExtendedListViewModel(type: .locationName, models: viewModel.locationNames, parameters: nil)
            listView.modalTransitionStyle = .crossDissolve
            listView.modalPresentationStyle = .overCurrentContext
            listView.delegate = self
            self.present(listView, animated: true, completion: nil)
        }else if actionType == .serviceEntry{
//            if CompaniesDataManager.shared.hasFormsServiceEntryFeature(){
//                if let arr = CompaniesDataManager.shared.getEnterServiceFormCount(), arr.count > 0{
//                    let msgStr = String(format: "You_have_to_fill".localized, arguments: [arr.count])
//                    let otherAlert = UIAlertController(title: "", message: msgStr, preferredStyle: .alert)
//                    let printSomething = UIAlertAction(title: "SHOW_TRAKING_CONFIRM_TITLE".localized, style: .default) { _ in
//                        let vc = ViewSource.formWebViewScreen()
//                        if let url = CompaniesDataManager.shared.getFormsURL(type: 3){
//                            vc.url = url
//                        }
//                        if let formName = CompaniesDataManager.shared.getFormName(type: 3){
//                            vc.formName = formName
//                        }
//                        vc.mandotoryBeforeReport = CompaniesDataManager.shared.hasFormsMandoryBeforeReportFeature(type: 3)
//                        vc.actionTag = 3
//                        vc.formdataArr = arr
//                        NavigationController.shared?.pushViewController(vc, animated: true)
//                    }
//                    let cancelBtn = UIAlertAction(title: "cancel".localized, style: .cancel)
//                    otherAlert.addAction(printSomething)
//                    otherAlert.addAction(cancelBtn)
//                    self.present(otherAlert, animated: true)
//                }
//            }else{
//                viewModel.bituachLeumiActionType = actionType
//
//                let listView = ViewSource.extendedListView()
//                listView.viewModel = ExtendedListViewModel(type: .locationName, models: viewModel.locationNames, parameters: nil)
//                listView.modalTransitionStyle = .crossDissolve
//                listView.modalPresentationStyle = .overCurrentContext
//                listView.delegate = self
//                self.present(listView, animated: true, completion: nil)
//            }
            viewModel.bituachLeumiActionType = actionType

            let listView = ViewSource.extendedListView()
            listView.viewModel = ExtendedListViewModel(type: .locationName, models: viewModel.locationNames, parameters: nil)
            listView.modalTransitionStyle = .crossDissolve
            listView.modalPresentationStyle = .overCurrentContext
            listView.delegate = self
            self.present(listView, animated: true, completion: nil)
        }
    }

    func patientNotAtHome() {
        if viewModel.shoulShowChooseTaskError() {
            self.viewModel.isListOpenedForPatientNotAtHome = true
            self.showChooseTaskView()
        } else {
            self.viewModel.patientNotAtHome()
            self.viewModel.isListOpenedForPatientNotAtHome = false
        }
    }
}

// MARK: - Get number of hours left for the task -
private extension DashboardViewController {

    func getNumberOfHoursLeftForTask(_ task: TaskObj?) {
        //1. Check if company has the access to get hours left for the task and task is selected
        if CompaniesDataManager.shared.hasGetHoursLeftFeature() && self.viewModel.selectedTask != nil {
            //2. Hit get pending hours api
            if let taskId = task?.taskId {
                self.getNumberOfHoursLeftForTask(with: taskId)
            }
        }
    }

    /**
     Get number of hours left for the selected task
     */
    func getNumberOfHoursLeftForTask(with id: String) {

        self.viewModel.getNumberOfHours(id, completion: { [weak self] hours in
            guard let `self` = self,
                  let hours = hours else {
                return
            }
            let hoursLeft = String(format: "number_of_hours_left_for_patient".localized, hours)
            //3. Show an alert for number of hours left
            self.showAlertWith(text: hoursLeft, hideAutomatically: true)
        })
    }

    func showAlertWith(text: String, hideAutomatically: Bool) {
        let alertController = UIAlertController(title: text, message: "", preferredStyle: .alert)
        if hideAutomatically {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                alertController.dismiss(animated: true)
            })
        }else {
            let settingsAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
            alertController.addAction(settingsAction)
        }
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve

        NavigationController.shared?.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CheckInConfirmationViewDelegate
extension DashboardViewController: CheckInConfirmationViewDelegate {
    func view(_ view: CheckInConfirmationView, didPressOk button: UIButton, isCheckIn: Bool) {
        if isCheckIn {
            self.performCheckIn()
        }else {
            self.performCheckOut()
        }
    }

    func view(_ view: CheckInConfirmationView, didPressCancel button: UIButton) {
        print("cancel confirm")
    }

}

extension DashboardViewController{
    func readUserFromBundle() -> DailyStudentReportsObj? {

        if let url = Bundle.main.url(forResource: "dailyStudentReports", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(DailyStudentReportsObj.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
