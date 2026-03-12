//
//  DashboardViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/23/20.
//
import Contacts

import UIKit
import SystemConfiguration.CaptiveNetwork
import TSLocationManager
import Alamofire

enum TaskSource: Int {
    case taskList = 0
    case barcodeScanner = 1
    case nfc = 2
}

let OfflineModeBecomesActiveNotification = Notification.Name("OfflineModeBecomesActiveNotification")

class DashboardViewModel {
    
    weak var delegate: DashboardViewModelDelegate?
    
    var position : String?
    
    var selectedFromCity: CitylistObj?
    var selectedToCity: CitylistObj?
    var enteredDistance: String?
    
    var lastloginTask: TaskObj?
    var selectedTask: TaskObj?
    var unknownTask: TaskObj?//for tasks, which has not been found in task list
    var selectedEvent: RevachaEventObj?
    var trnsType: Int?
    
    var latNFC : Double?
    var longNFC : Double?
    var tagUID : String?
    
    var absenceReport: AbsenceObj?
    var absenceEmployee: EmployeeByDepartmentObj?
    
    var waitingForConfirmViewType: ConfirmViewType?
    
    var waitingForHealthConfirm: Bool = false
    
    var waitingForLoadData: Bool = false
    
    var trackingReports: [TrackingObj?]?
    var trackingStarted: Bool = false
    
    var notificationType: NotificationTypeEntity?
    
    let tracker = TrackerController()
    
    var remark: String?
    var bituachLeumiMonthStatsHidden: Bool = true
    
    var projects: [GetProjectsObj] {
        var projects: [GetProjectsObj] = []
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        
        for task in tasks {
            let projectIds = projects.map { $0.projectId ?? -1000 }
            guard let projectId = task?.projectId else {
                continue
            }
            if !projectIds.contains(projectId) {
                let project = GetProjectsObj(projectId: projectId, projectCode: "\(projectId)", projectName: task?.projectName)
                projects.append(project)
            }
        }
        
        return projects
    }
    
    var projectsName: [String] {
        return projects.map { $0.projectName ?? "" }
    }
    
    var locationNames: [LocationNameObj] {
        return CompaniesDataManager.shared.getLocationMames() ?? []
    }
    
    var taskSource: TaskSource = .taskList
    
    var exitEnforcementObj: GetExitEnforcementObj?
    let userDefaults = UserDefaults.standard
    
    var offlineModeLabelHidden = true
    var selectedLocationName: LocationNameObj?
    var bituachLeumiActionType: ReportActionType?
    var isListOpenedForPatientNotAtHome: Bool = false
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    
    var isRevacha: Bool {
//        print("CompaniesDataManager.shared.isRevacha()", CompaniesDataManager.shared.isRevacha())
        return CompaniesDataManager.shared.isRevacha()
    }
    
    var isHolocaust: Bool {
//        print("CompaniesDataManager.shared.isHolocaustSurvivors()", CompaniesDataManager.shared.isHolocaustSurvivors())
        return CompaniesDataManager.shared.isHolocaustSurvivors()
    }
    
    var isPaused: Bool {
        return CompaniesDataManager.shared.getLastBreakReport() != nil
    }
    
    var isAbsent: Bool {
        return CompaniesDataManager.shared.isAbsentToday()
    }
    
    var hasMonthStatistics: Bool {
        if isRevacha || isHolocaust {
            return false
        }
        return CompaniesDataManager.shared.getMonthStatistics() != nil
    }
    
    var hasLastReports: Bool {
        return CompaniesDataManager.shared.getLastReports().count != 0
    }
    
    var lastReport: ReportObj? {
        if let report = CompaniesDataManager.shared.getLastReportsWithoutSort().last {
            return report
        }
        return nil
    }
    
    var shouldShowLastReports: Bool {
        return CompaniesDataManager.shared.hasShowReportsFeature()
    }
    
    var hasChooseTask: Bool {
        return CompaniesDataManager.shared.hasChooseTaskFeature()
    }
    
    var hasReports: Bool {
        return CompaniesDataManager.shared.hasReportFeature()
    }
    
    var hasTracking: Bool {
        return CompaniesDataManager.shared.hasTrackingFeature()
    }
    
    var useLastTask: Bool {
        return CompaniesDataManager.shared.shouldUseLastTask()
    }
    
    var shouldReportTask: Bool {
        return CompaniesDataManager.shared.shouldReportTask()
    }
    
    var shouldAskLocation: Bool {
        return CompaniesDataManager.shared.shouldAskLocationPermission() && CompaniesDataManager.shared.hasAppPermission()
    }
    
    var shouldReportLocation: Bool {
        if CompaniesDataManager.shared.shouldReportWithoutPosition(){
            return false
        }else if CompaniesDataManager.shared.mustReportPosition(){
            return true
        }
        return true
    }
    
    var shouldLoginWithPicture: Bool {
        return CompaniesDataManager.shared.shouldReportLoginWithPicture()
    }
    
    var shouldLogoutWithPicture: Bool {
        return CompaniesDataManager.shared.shouldReportLogoutWithPicture()
    }
    
    var hasDistanceMeasurement: Bool {
        return CompaniesDataManager.shared.hasDistanceMeasurementFeature()
    }
    
    var hasTrackingDisclaimer: Bool {
        return CompaniesDataManager.shared.hasTrackingDisclaimer()
    }
    
    var isSpecialCustomerDoctors: Bool {
        let type = CompaniesDataManager.shared.getSpecialClientType()
        return type == 1 || type == 2
    }
    
    var isBituachLeumiClient: Bool {
        return CompaniesDataManager.shared.isBituachLeumi()
    }
    
    var isDistanceMeasurementStarted: Bool = false
    var isDistanceMeasurementStopped: Bool = false
    
    var isWaitingForLogout: Bool = false
    
    var isMapShown: Bool = false
    
    var eventNames: [String] {
        let events = CompaniesDataManager.shared.getEvents() ?? []
        let names = events.map { $0.eventName ?? "" }
        return names
    }
    
    private var alreadyAskedForWifi: Bool = false
    private var requestTimer: Timer?
    private var error502AlreadyShown: Bool = false
    
    init() {
        waitingForLoadData = true
        clearSelectedEvent()
        CompaniesDataManager.shared.getFromCache()
        NotificationCenter.default.addObserver(self, selector: #selector(offlineModeBecomesActive(_:)), name: OfflineModeBecomesActiveNotification, object: nil)
    }
    
    init(lastloginTask: TaskObj? = nil, selectedTask: TaskObj? = nil) {
        self.lastloginTask = lastloginTask
        self.selectedTask = selectedTask
        clearSelectedEvent()
        CompaniesDataManager.shared.getFromCache()
        NotificationCenter.default.addObserver(self, selector: #selector(offlineModeBecomesActive(_:)), name: OfflineModeBecomesActiveNotification, object: nil)
    }
    
    @objc private func offlineModeBecomesActive(_ notification: Notification?) {
        if let error = notification?.object as? ErrorObject {
            if !error502AlreadyShown {
                error502AlreadyShown = true
                delegate?.shouldShowError(error)
            }
        }
        
        loadingView.removeFromSuperview()
        waitingForLoadData = false
        requestTimer?.invalidate()
        requestTimer = nil
        
        offlineModeLabelHidden = false
        CompaniesDataManager.shared.getFromCache()
        delegate?.shouldRefreshView()
    }
    
    func refreshTasksData() {
        let taskIds = CompaniesDataManager.shared.getAvailableTasks().map { $0?.taskId }
        if !taskIds.contains(obj: selectedTask?.taskId) && !taskIds.contains(obj: lastloginTask?.taskId) && !taskIds.contains(obj: unknownTask?.taskId) {
            selectedTask = nil
            lastloginTask = nil
            unknownTask = nil
            selectedEvent = nil
        }
    }
    
    // ui methods
    func needShowMonthStatistics() -> Bool {
        if isBituachLeumiClient || isRevacha || isHolocaust {
            return !bituachLeumiMonthStatsHidden
        }
        return hasMonthStatistics
    }
    
    func shouldHideStatisticsView() -> Bool {
        return isRevacha || isHolocaust ||  isAbsent || !hasMonthStatistics || isMapShown || isSpecialCustomerDoctors || !hasReports || !shouldHideWorkScheduleView()
    }
    
    func shouldHideTaskBarView() -> Bool {
        return isAbsent || !hasLastReports
    }
    
    func shouldHideChooseTaskView() -> Bool {
//        return isRevacha || (isAbsent || !hasChooseTask)
        if isRevacha || isHolocaust{
            return true
        }else if (isAbsent || !hasChooseTask){
            return (isAbsent || !hasChooseTask)
        }
        return false
    }
    
    func shouldHideSelectClientView() -> Bool {
        if isRevacha || isHolocaust || isAbsent{
            return false
        }
        return true
    }
    
    func shouldHideBarcodeView() -> Bool {
        return !(CompaniesDataManager.shared.hasBarcodeReportsFeature()  || CompaniesDataManager.shared.hasNFCReportsFeature()) || isAbsent
    }
    
    func getChooseTaskViewHeight() -> CGFloat {
        return shouldHideTaskBarView() ? 120 : 70
    }
    
    func shouldHideTrackingView() -> Bool {
        return isAbsent
    }
    
    func shouldHideAbsenceView() -> Bool {
        return !isAbsent
    }
    
    func shouldHideMapView() -> Bool {
        return !isMapShown
    }
    
    func shouldHideTrackingButton() -> Bool {
        return !hasTracking || isAbsent
    }
    
    func shouldHideAddRideButton() -> Bool {
        return !hasDistanceMeasurement || isAbsent
    }
    
    func getInfoViewHeight() -> CGFloat {
        return isMapShown ? 115 : 140
    }
    
    func getTrackingViewHeight() -> CGFloat {
        
        if isBituachLeumiClient {
            return 265.0
        }
        if isRevacha || isHolocaust {
            return 265.0
        }
        var addonButtonsHeight: CGFloat = 0.0
        if CompaniesDataManager.shared.getAddonButtons() != nil {
            addonButtonsHeight = 135.0
        }
        var imHereButtonheight = 0.0
        if  CompaniesDataManager.shared.hasBreakFeature() && CompaniesDataManager.shared.hasAbsenceFeature() && CompaniesDataManager.shared.hasImHereFeature() {
            imHereButtonheight = 50.0
        }
        
        return imHereButtonheight + ( isMapShown ? 55 + addonButtonsHeight : 175 + addonButtonsHeight)
    }
    
    func getModelForAccountView() -> AccountInfoViewModel {
        return AccountInfoViewModel(type: .allInfo)
    }
    
    func shoulShowChooseTaskError() -> Bool {
        if isHolocaust{
            if (trnsType == 4 || trnsType == 5 || trnsType == 6 || UserDefaultsManager.holocustLastLoginType == 4 || UserDefaultsManager.holocustLastLoginType == 5 || UserDefaultsManager.holocustLastLoginType == 6) && selectedTask == nil && unknownTask == nil{
                return true
            }
            return false
        }else if isRevacha {
            if (trnsType == 1 || trnsType == 2 || UserDefaultsManager.revachaLastLoginType == 1  || UserDefaultsManager.revachaLastLoginType == 2) && selectedTask == nil && unknownTask == nil {
                return true
            }
            return false
        }
        return shouldReportTask && ((selectedTask == nil) && (unknownTask == nil) && (lastloginTask == nil))
    }
    
//    func hasSelectedClient() -> Bool {
//        print("Need check")
//        return (isRevacha || isHolocaust) && (trnsType == 1 || trnsType == 2 || UserDefaultsManager.revachaLastLoginType == 1  || UserDefaultsManager.revachaLastLoginType == 2) && (selectedTask != nil || unknownTask != nil)
//    }
    
    // distance measurement
    func getModelForTrackingView() -> TrackingViewModel {
        return TrackingViewModel(isTrackingStarted: isDistanceMeasurementStarted, distanceSettings: selectedTask?.distanceSettings)
    }
    
    func updateDistanceMeasurementState(type: DistanceMeasurementType) {
        switch type {
        case .startTracking:
            DistanceMeasurementManager.shared.start()
            isDistanceMeasurementStarted = true
        case .stopTracking:
            DistanceMeasurementManager.shared.stop()
            isDistanceMeasurementStarted = false
        case .showTracked:
            return
        }
    }
    
    func sendDistanceMeasurementBy(type: DistanceMeasurementType) {
        switch type {
        case .startTracking:
            sendDistance(type: type, distance: nil)
        case .stopTracking:
            let distance = DistanceMeasurementManager.shared.getDistanceInMeters()
            sendDistance(type: type, distance: distance)
        case .showTracked:
            return
        }
    }
    
    func showStartDistanceMeasurementByReportType(type: ReportActionType) {
        guard hasDistanceMeasurement, !isDistanceMeasurementStarted, !isDistanceMeasurementStopped else {
            isDistanceMeasurementStopped = false
            return
        }
        switch type {
        case .workStart:
            self.delegate?.shouldShowStartTrackingView(true)
        case .workEnd:
            self.delegate?.shouldShowStartTrackingView(false)
        default:
            break
        }
    }
    
    func shouldShowDistanceMeasurementForAction(type: ConfirmViewType) -> Bool {
        guard isDistanceMeasurementStarted else { return false }
        
        self.setWaitingForReportType(type: type)
        return true
    }
    
    func setWaitingForReportType(type: ConfirmViewType) {
        self.waitingForConfirmViewType = type
        self.isDistanceMeasurementStopped = true
        self.delegate?.shouldShowStopTrackingView()
    }
    
    func sendWaitingReportType() {
        guard let type = waitingForConfirmViewType else { return }
        
        self.delegate?.shouldShowConfirmView(type, false)
        waitingForConfirmViewType = nil
    }
    
    // distance - merkava
    func getHoursLimit() -> String {
        guard CompaniesDataManager.shared.getSpecialClientType() == 3783, let hours = selectedTask?.hoursLimit?.description else { return "" }
        return"מסגרת שעות" + " " + hours
    }
    
    func getHoursCompleted() -> String {
        guard CompaniesDataManager.shared.getSpecialClientType() == 3783, let hours = selectedTask?.hoursCompleted?.description else { return "" }
        return "שעות בפועל" + " " + hours
    }
    
    func shouldEnableAddRideView() -> Bool {
        guard CompaniesDataManager.shared.getSpecialClientType() == 3783 else { return true }
        return selectedTask?.distanceSettings?.shouldEnableAddRideView ?? false
    }
    
    // location
    func checkLocationPermission() {
        if shouldAskLocation && !LocationManager.shared.hasPermission() {
            LocationManager.shared.requestLocationPermissions()
        }
    }
    
    func checkLocationValues() -> Bool {
        if shouldReportLocation {
            if shouldAskLocation && !LocationManager.shared.hasPermission() {
                LocationManager.shared.requestLocationPermissions()
                return false
            }
//            else if LocationManager.shared.getCurrentLocation() == nil {
//                delegate?.shouldShowError("420".localized)
//                return false
//            }
            
//            if !ReachabilityManager.shared.isWiFiConnection() && LocationManager.shared.getCurrentLocation()?.horizontalAccuracy ?? 0 >= 2000 {
//                let alertController = UIAlertController(title: "Insufficient satellite reception was found.\nOpen the Wifi connection and try again".localized, message: "", preferredStyle: .alert)
//                let settingsAction = UIAlertAction(title: "SETTINGS".localized, style: .default) { (_) -> Void in
//                    guard let settingsUrl = URL(string: "App-Prefs:root=WIFI") else {
//                        return
//                    }
//                    if UIApplication.shared.canOpenURL(settingsUrl) {
//                        UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
//                    }
//                }
//                let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil)
//                alertController.addAction(cancelAction)
//                alertController.addAction(settingsAction)
//                alertController.modalPresentationStyle = .overCurrentContext
//                alertController.modalTransitionStyle = .crossDissolve
//                
//                NavigationController.shared?.present(alertController, animated: true, completion: nil)
//            }
        }
        return true
    }
    
    func checkWifiConnection() {
        guard !alreadyAskedForWifi && UserDefaultsManager.connectionServiceCount > 0 else { return }
        alreadyAskedForWifi = true
        //        if !ReachabilityManager.shared.isWiFiConnection() {
        if !ReachabilityManager.shared.hasInternetConnection {
            let alertController = UIAlertController(title: "TURN_ON_WIFI_TITLE".localized, message: "TURN_ON_WIFI_IF_IN_BILDING".localized, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "SETTINGS".localized, style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: "App-Prefs:root=WIFI") else {
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
    }
    
    // notifications methods
    func setNotification(notification: PushNotification) {
        if let type = notification.notificationType {
            self.notificationType = NotificationTypeEntity(rawValue: type)
        }
    }
    
    func hasNotificationAction() -> Bool {
        if notificationType == nil {
            return false
        } else {
            return notificationType!.hasAction()
        }
    }
    
    func shouldShowLoginConfirm() -> Bool {
        return notificationType?.shouldLogin() ?? false
    }
    
    func shouldShowLogoutConfirm() -> Bool {
        return notificationType?.shouldLogout() ?? false
    }
    
    func shouldShowAbsenceConfirm() -> Bool {
        return notificationType?.shouldAbsence() ?? false
    }
    
    func shouldShowMyReportsScreen() -> Bool {
        return notificationType?.shouldOpenReports() ?? false
    }
    
    // health disclaimer
    func checkHealthDisclaimer() -> Bool {
        return CompaniesDataManager.shared.shouldShowHealthDisclaimer()
    }
    
    // special customer - mercava
    func getHoursLimitString() -> String {
        if CompaniesDataManager.shared.getSpecialClientType() == 3783 {
            return selectedTask?.hoursLimit?.description ?? ""
        }
        
        return ""
    }
    
    func getHoursCompletedString() -> String {
        if CompaniesDataManager.shared.getSpecialClientType() == 3783 {
            return selectedTask?.hoursCompleted?.description ?? ""
        }
        return ""
    }
    
    // task methods
    
    func setLastTask(task: TaskObj? ) {
        lastloginTask = task
        unknownTask = nil
    }
    
    func applyLastTask() {
        if let task = CompaniesDataManager.shared.getLastLoginTask() {
            lastloginTask = task
            unknownTask = nil
        } else {
            lastloginTask = nil
            unknownTask = CompaniesDataManager.shared.getLastLoginUnknownTask()
        }
    }
    
    func setLastTask() {
        lastloginTask = selectedTask
        unknownTask = nil
    }
    
    func setSelectedTask(task: TaskObj?) {
        selectedTask = task
        unknownTask = nil
        taskSource = .taskList
    }
    
    func setSelectedTaskFromBarcode(task: TaskObj?) {
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        guard let selectedTask = tasks.filter({ $0?.taskId == task?.taskId }).first else {
            self.selectedTask = nil
            self.unknownTask = task
            return
        }
        self.selectedTask = selectedTask
        self.unknownTask = nil
        taskSource = .barcodeScanner
    }
    
    func setSelectedTaskFromNFC(task: TaskObj?) {
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        guard let selectedTask = tasks.filter({ $0?.taskId == task?.taskId }).first else {
            self.selectedTask = nil
            self.unknownTask = task
            return
        }
        self.selectedTask = selectedTask
        self.unknownTask = nil
        
        taskSource = .nfc
    }
    
    func setSelectedUnknownTask(task: TaskObj?) {
        unknownTask = task
        selectedTask = nil
        taskSource = .barcodeScanner
    }
    
    func setSelectedUnknownTaskFromNFC(task: TaskObj?) {
        unknownTask = task
        selectedTask = nil
        taskSource = .nfc
    }
    
    func hasTask(with id: String) -> Bool {
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        return tasks.filter { $0?.taskId == id }.first != nil
    }
    
    func taskWithId(_ taskId: String) -> TaskObj? {
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        print(tasks)
        return tasks.filter { $0?.taskId == taskId }.first ?? nil
    }
    
    func removeLastTask() {
        lastloginTask = nil
    }
    
    func removeSelectedTask() {
        selectedTask = nil
        unknownTask = nil
    }
    
    func updateLastTask(isLogin: Bool) -> TaskObj? {
        var task = selectedTask
        
        if isLogin {
            setLastTask()
        } else {
            task = lastloginTask
            removeLastTask()
        }
        
        return task
    }
    
    func getTaskByConfirmType(_ type: ConfirmViewType) -> TaskObj? {
        switch type {
        case .loginConfirm, .loginSuccess:
            return selectedTask
        case .logoutConfirm, .logoutSuccess:
            return selectedTask
        case .logoutMustNote:
            return selectedTask
        default:
            return nil
        }
    }
    
    func getSelectedUnknownTask() -> TaskObj? {
        return unknownTask
    }
    
    func getTaskByActionType(_ type: ReportActionType) -> TaskObj? {
        switch type {
        case .workStart, .endAndStartWork, .serviceEntry, .sampleReport:
            return selectedTask
        case .workEnd, .serviceExit:
            return selectedTask
        default:
            return nil
        }
    }
    
    func setTaskByActionType(_ type: ReportActionType, task: TaskObj?) {
        switch type {
        case .workStart, .endAndStartWork, .serviceEntry:
            selectedTask = task
        case .workEnd, .serviceExit:
            selectedTask = task
        default:
            break
        }
    }
    
    func getConfirmTypeByActionType(_ type: ReportActionType) -> ConfirmViewType? {
        switch type {
        case .workStart, .serviceEntry:
            return .loginSuccess
        case .workEnd, .serviceExit:
            return .logoutSuccess
        case .endAndStartWork:
            return .loginSuccess
        default:
            return nil
        }
    }
    
    func shouldShowSalesAmountView() -> Bool {
        return CompaniesDataManager.shared.getSpecialClientType() == 3314
    }
    
    
    // NFC
    
    func getTaskByNFCNew(completionNew: @escaping(String?,String?,Double?,Double?)-> ()){
        NFCUtility.performAction(.readTaskByNFC){ task in
            let taskId =  try? task.get().name
            let uId =  try? task.get().UID
            let lat =  try? task.get().lat
            let long = try? task.get().long
            completionNew(taskId,uId,lat,long)
        }
    }
    
    func getChooseTaskTitle() -> (String) {
        //print("USE LAST TASK \(useLastTask)")
        if selectedTask == nil, lastloginTask == nil, unknownTask == nil {
            if useLastTask {
                if getLastTask() != nil {
                    selectedTask = getLastTask()
                } else {
                    do {
                        let lastTask = try userDefaults.getObject(forKey: "userLastTask", castTo: TaskObj.self)
                        print(lastTask)
                        
                        let taskArr = CompaniesDataManager.shared.getAvailableTasks()
                        print("taskArr", taskArr)
                        
                        if let dict = taskArr.first(where: {$0?.taskId == lastTask.taskId}){
                            selectedTask = dict
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else {
                selectedTask = getLastLoginTask()
            }
        }
        
        if let task = CompaniesDataManager.shared.getLastLoginUnknownTask(){
            print("task", CompaniesDataManager.shared.getLastLoginUnknownTask())
            return task.taskName
        }else{
            var title = selectedTask != nil ? selectedTask?.taskName : lastloginTask?.taskName
            
            if let task = unknownTask {
                if task.taskName.count > 0 {
                    title = task.taskName
                } else {
                    title = "UNKNOWN_TASK".localized
                }
            }
            let finalStr = title != nil ? title! : getTaskTitlePlacehplder()
            return finalStr
        }
        
        
    }
    
    func getTaskTitlePlacehplder() -> String {
        if isRevacha || isHolocaust {
            return "SELECT_CLIENT".localized
        }
        return "SELECT_TASK".localized
    }
    
    func getLastTask() -> TaskObj? {
        let reports = CompaniesDataManager.shared.getLastLoginLogoutReports()
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        
        if let taskId = reports.last?.taskId, let task = tasks.first(where: {$0?.taskId == taskId}) {
            do {
                try userDefaults.setObject(task, forKey: "userLastTask")
            } catch {
                print(error.localizedDescription)
            }
            return task
        }
        
        return nil
    }
    
    func getLastLoginTask() -> TaskObj? {
        
        let report = CompaniesDataManager.shared.getLastLoginReport()
        let tasks = CompaniesDataManager.shared.getAvailableTasks()
        
        if let taskId = report?.taskId, let task = tasks.first(where: {$0?.taskId == taskId}) {
            return task
        }
        return nil
    }
    
    func getBreakConfirmType() -> ConfirmViewType {
        return isPaused ? .breakEndConfirm : .breakStartConfirm
    }
    
    func resetBreakTime(type: ReportActionType) {
        switch type {
        case .breakEnd:
            CompaniesDataManager.shared.setActiveBreakTime(0)
        default:
            break
        }
    }
    
    func setAbsenceReport(report: AbsenceObj? = nil) {
        self.absenceReport = report
    }
    
    func getAbsenceReport() -> AbsenceObj? {
        return self.absenceReport
    }
    
    func setAbsenceEmployee(employee: EmployeeByDepartmentObj? = nil) {
        self.absenceEmployee = employee
    }
    
    func getTrackingReports() -> [TrackingObj?] {
        return trackingReports ?? []
    }
    
    func updateTrackingStatus(type: ReportActionType) {
        switch type {
        case .startTracking:
            trackingStarted = true
        case .endTracking:
            trackingStarted = false
        default:
            break
        }
        sendGeolocationReports()
    }
    
    func userDidTapConfirm(type: ConfirmActionType, task: TaskObj?, remark: String?, isNFCRead: Bool) {
        switch type {
        case .login:
            if isWaitingForLogout {
                setTaskByActionType(.endAndStartWork, task: task)
                sendReport(type: .endAndStartWork, remark: remark)
            } else {
                if bituachLeumiActionType != nil {
                    setTaskByActionType(.serviceEntry, task: task)
                    sendReport(type: .serviceEntry, remark: remark)
                } else {
                    setTaskByActionType(.workStart, task: task)
                    sendReport(type: .workStart, remark: remark)
                }
            }
        case .logout:
            if bituachLeumiActionType != nil {
                setTaskByActionType(.serviceExit, task: task)
                sendReport(type: .serviceExit, remark: remark)
            } else {
                setTaskByActionType(.workEnd, task: task)
                sendReport(type: .workEnd, remark: remark)
            }
            removeLastTask()
            removeSelectedTask()
        case .logoutAndLogin:
            delegate?.shouldShowChooseTaskView()
            isWaitingForLogout = true
        case .breakStart, .breakEnd:
            let reportType: ReportActionType = isPaused ? .breakEnd : .breakStart
            sendReport(type: reportType, remark: remark)
        case .absenceStart:
            sendReport(endpointType: .reportAbsence, type: .dayOff, remark: remark)
        case .cancel:
            if isWaitingForLogout {
                isWaitingForLogout = false
                removeSelectedTask()
                selectedEvent = nil
                delegate?.shouldRefreshView()
            }
            clearSelectedEvent()
            trnsType = 1
            self.delegate?.shouldClearEvent()
        case .confirm, .additional:
            break
        }
    }
    
    func userDidTapConfirm(with task: TaskObj?, event: RevachaEventObj, remark: String?) {
        sendReport(type: .workStart, remark: remark)
    }
    
    func shouldShowConfirm(type: ReportActionType) {
        guard !hasDistanceMeasurement, let confirmType = getConfirmTypeByActionType(type) else { return }
        self.delegate?.shouldShowConfirmView(confirmType, false)
    }
    
    func shouldShowRequestCompletionPopup(_ lastReport: ReportObj) {
        if let lastEntry = CompaniesDataManager.shared.lastEntryObject() {
            let viewModel = RequestCompletionViewModel(lastEntry, lastReport: lastReport)
            delegate?.shouldShowRequestCompletionView(viewModel)
        }
    }
    
    // milti report
    func updateMultiReportData(multipleReport: MultipleReportObj) {
        guard multipleReport.employees.count > 0, !(multipleReport.employees.count == 1 && multipleReport.employees[0] == CompaniesDataManager.shared.getEmployeeId()) else { return }
        
        switch multipleReport.type {
        case .logout:
            UserDefaultsManager.multiLoginTask = nil
            UserDefaultsManager.multiLoginEmps = nil
        case .login:
            UserDefaultsManager.multiLoginTask = multipleReport.task?.taskId
            UserDefaultsManager.multiLoginEmps = multipleReport.employees
        }
    }
    
    
    
    
    func showConfirmViewFor(multipleReport: MultipleReportObj) {
        if multipleReport.type == .login {
            self.delegate?.shouldShowConfirmView(.loginSuccess, false)
        }
        
        if multipleReport.type == .logout {
            self.delegate?.shouldShowConfirmView(.logoutSuccess, false)
        }
    }
    
    /*func updateData() {
     guard let lastDate = UserDefaultsManager.getCompaniesRequestDate else {
     loadData()
     return
     }
     
     let prevDay = Calendar.current.component(.day, from: lastDate)
     let newDay = Calendar.current.component(.day, from: Date())
     
     if prevDay != newDay {
     loadData()
     }
     }*/
    
    func updateDataSuccessPictureReport(reports: [ReportObj?], type: ReportActionType) {
        CompaniesDataManager.shared.setReportList(reports: reports)
        self.delegate?.shouldRefreshView()
        self.resetBreakTime(type: type)
        self.sendTrackingReportByReportType(type: type)
        self.showStartDistanceMeasurementByReportType(type: type)
    }
    
    func cancelPictureReport() {
        if isWaitingForLogout {
            isWaitingForLogout = false
            removeSelectedTask()
            delegate?.shouldRefreshView()
        }
    }
    
    // api calls
    func loadData(isFromReachability: Bool = false) {
        guard ReachabilityManager.shared.hasInternetConnection else {
            CompaniesDataManager.shared.getFromCache()
            self.delegate?.shouldRefreshView()
            return
        }
        
        vc?.view.addSubview(loadingView)
        
        let company = GetCompaniesEndpoint()
        company.apiCall { [weak self] (result, error) in
            self?.waitingForLoadData = false
            self?.requestTimer?.invalidate()
            self?.requestTimer = nil
            
            if error?.success ?? false {
                CompaniesDataManager.shared.setCompanies(result?.data)
                
                if self?.hasTrackingDisclaimer ?? false && !isFromReachability {
                    self?.getDiscalimer()
                }
                self?.offlineModeLabelHidden = true
                
                self?.delegate?.shouldRefreshView()
                UserDefaultsManager.getCompaniesRequestDate = Date()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadData"), object: nil)
            } else {
                let savedCompanies = UserDefaultsManager.companiesObj
                let savedUdid = UserDefaultsManager.udid
                if((error?.error_code == 401 || error?.error_code == 500) && savedCompanies != nil && savedUdid != nil)  {
                    self?.offlineModeBecomesActive(nil)
                } else {
                    self?.delegate?.shouldShowError(error)
                }
            }
        }
        
        requestTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { [weak self] timer in
            self?.requestTimer?.invalidate()
            self?.requestTimer = nil
            company.apiManager.cancelSession()
            self?.offlineModeLabelHidden = false
            CompaniesDataManager.shared.getFromCache()
            self?.delegate?.shouldRefreshView()
        })
        
        self.loadingView.removeFromSuperview()
    }
    
    func sendAcceptDisclaimer() {
        guard let empId = CompaniesDataManager.shared.getEmployeeIdForTrackDisclaimer() else { return }
        vc?.view.addSubview(loadingView)
        
        let acceptEndpoint = AcceptTrackDisclaimerEndpoint(empId: empId)
        acceptEndpoint.apiCall { result in
            self.loadingView.removeFromSuperview()
            
            if result?.success ?? false {
                self.loadData()
            } else {
                self.delegate?.shouldShowError(result)
            }
        }
    }
    
    func loadTrackingData() {
        vc?.view.addSubview(loadingView)
        
        let tracking = GetTrackingEndpoint()
        tracking.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                self.trackingReports = result?.data
                self.delegate?.shouldShowTrackingMap()
            } else {
                self.delegate?.shouldShowError(error)
            }
        }
    }
    
    func enableOfflineMode() {
        offlineModeLabelHidden = false
    }
    
    func saveReportOffline(type: ReportActionType, task: TaskObj?) {
        if let selectedtsk = task{
            OfflineRequestsManager.sharedInstance.save(type: type.rawValue, taskId: selectedtsk.taskId, taskName: selectedtsk.taskName, remark: selectedTask?.remark, locationName: selectedLocationName?.locationId)
        }else{
            OfflineRequestsManager.sharedInstance.save(type: type.rawValue, taskId: nil, taskName: nil, remark: selectedTask?.remark, locationName: selectedLocationName?.locationId)
        }
        
        NavigationController.shared?.showSuccessView(message: "OFFLINE_MODE_REPORT_SAVED".localized)
        self.delegate?.shouldRefreshView()
//        self.checkSavedRequests(isFromReachability: true)
    }
    
    func newSaveOfflineReport(report: ReportEndpoint?){
        if let rep = report, var params = rep.convertToDictionary(){
            if var offlineData = UserDefaultsManager.sampleDictArray, offlineData.count > 0 {
                params["timestamp"] = Int64(Date().timeIntervalSince1970)
                offlineData.append(params)
                UserDefaultsManager.sampleDictArray = offlineData
            }else{
                params["timestamp"] = Int64(Date().timeIntervalSince1970)
                UserDefaultsManager.sampleDictArray = [params]
            }
            NavigationController.shared?.showSuccessView(message: "offline_report_message".localized)
            self.delegate?.shouldRefreshView()
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String,handler : @escaping(String)-> Void) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                print(addressString)
                handler(addressString)
                
            }
        })
        
    }
    
    
    func sendReport(endpointType: EndpointItemType = .report, type: ReportActionType, remark: String?) {
        let task = self.getTaskByActionType(type)
        vc?.view.addSubview(loadingView)
        print("UserDefaultsManager.connectionServiceCount", UserDefaultsManager.connectionServiceCount)
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            self.showNoInternetPopup()
            self.loadingView.removeFromSuperview()
            return
        }
        
        if endpointType != .reportAbsence{
            self.absenceReport = nil
        }
                
        vc?.view.addSubview(loadingView)
        
        var lat : CLLocationDegrees?
        var lon : CLLocationDegrees?
        if shouldReportLocation{
            let location = LocationManager.shared.getCurrentLocation()
            
            let longitude = location?.coordinate.longitude
            let latitude = location?.coordinate.latitude
            lat = latitude
            lon = longitude
        }
        
        
        
        let accuracy = 16
        
        
        let taskId: String? = task?.taskId ?? self.unknownTask?.taskId
        
        let taskName: String? = task?.taskName ?? self.unknownTask?.taskName
        let remark = task?.remark ?? self.absenceReport?.remark ?? remark
        
        let absenceType: AbsenceTypeEntity? = self.absenceReport?.type
        let fromDate: String? = self.absenceReport?.fromDate.toString(format: "yyyy-MM-dd")
        let toDate: String? = self.absenceReport?.toDate.toString(format: "yyyy-MM-dd")
        var emps: [Int]?
        if let employeeId =  self.absenceEmployee?.empId, absenceType != nil {
            emps = [employeeId]
        }
        
        
        
        let position = self.position
        
        let files = self.absenceReport?.attachedFiles ?? []
        var  report:ReportEndpoint? = nil
        var extraFields: [String : Any] = [:]
        if !self.isRevacha{
            extraFields["taskSource"] = self.taskSource.rawValue
        }
        extraFields["locationName"] = selectedLocationName?.locationId
        
        if self.isRevacha || self.isHolocaust {
            if isRevacha{
                extraFields["trnsType"] = UserDefaultsManager.revachaLastLoginType
                extraFields["EventType"] = "0"
            }else{
                extraFields["trnsType"] = UserDefaultsManager.holocustLastLoginType - 3
                extraFields["TherapyType"] = UserDefaultsManager.holocustLastTheraphyType
            }
            if let event = self.selectedEvent {
                extraFields["EventType"] = Int(event.eventType ?? "0")
            }
            report = ReportEndpoint(endpointType: endpointType, type: type, absenceType: absenceType, files: files, taskId: taskId, taskName: taskName, remark:  remark, fromDate: fromDate, toDate: toDate, lat: lat, lon: lon, accuracy: accuracy, tagUID: self.tagUID, empIds: emps, extraFields: extraFields, fromCity: self.selectedFromCity, toCity: self.selectedToCity, distance: self.enteredDistance)
            
        } else {
            report = ReportEndpoint(endpointType: endpointType, type: type, absenceType: absenceType, files: files, taskId: taskId, taskName: taskName, remark: remark, fromDate: fromDate, toDate: toDate, lat: lat, lon: lon, accuracy: accuracy, tagUID: self.tagUID, empIds: emps, extraFields: extraFields, fromCity: self.selectedFromCity, toCity: self.selectedToCity, distance: self.enteredDistance)
        }
        
        if !ReachabilityManager.shared.hasInternetConnection &&
            (type == .workStart ||
             type == .workEnd ||
             type == .endAndStartWork ||
             type == .serviceEntry ||
             type == .serviceExit) {
            
            self.newSaveOfflineReport(report: report)
            self.sendTrackingReportByReportType(type: type)
            self.loadingView.removeFromSuperview()
            return
        }
        
        
        
        var isReportSent = Bool()
        report?.apiCall { (result, error) in
            self.selectedToCity = nil
            self.selectedFromCity = nil
            self.enteredDistance = ""
            
            self.selectedEvent = nil
            DashboardViewController.isRecentNFCScan = false
            self.delegate?.shouldUpdateTimer()
            if error?.success ?? false {
                self.latNFC = nil
                self.longNFC = nil
                isReportSent = true
                
                CompaniesDataManager.shared.setReportList(reports: result?.data ?? [])
                
                if type == .workEnd{
                    if self.isRevacha{
                        UserDefaultsManager.revachaLastLoginType = 1
                    }else if self.isHolocaust{
                        UserDefaultsManager.holocustLastLoginType = 6
                        UserDefaultsManager.holocustLastTheraphyType = 1
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTrsType"), object: nil)
                }
                
                self.resetBreakTime(type: type)
                self.sendTrackingReportByReportType(type: type)
                self.showStartDistanceMeasurementByReportType(type: type)
                if self.waitingForHealthConfirm {
                    self.waitingForHealthConfirm = false
                    self.delegate?.shouldShowHealthDisclaimer(.accepted, nil)
                } else {
                    if let lastReport = result?.data.last, let lastEntry = CompaniesDataManager.shared.lastEntryObject(), CompaniesDataManager.shared.hasRequestExitCompletionFeature() {
                        if let lastReport = lastReport {
                            if lastReport.actionType == "1" || lastReport.actionType == "303" {
                                self.shouldShowRequestCompletionPopup(lastReport)
                            }
                        } else if (lastReport?.actionType == "304" || lastReport?.actionType == "2") && lastReport?.taskId == lastEntry.taskId {
                            CompaniesDataManager.shared.disableRequestExitCompletion()
                            self.shouldShowConfirm(type: type)
                        } else {
                            self.shouldShowConfirm(type: type)
                        }
                    } else {
                        self.shouldShowConfirm(type: type)
                    }
                }
                if type == .dayOff && endpointType == .reportAbsence {
                    NavigationController.shared?.showSuccessView(message: "report_has_been_received_successfully".localized)
                    self.loadData()
                } else {
                    self.delegate?.shouldRefreshView()
                    self.loadingView.removeFromSuperview()
                }
            } else {
                isReportSent = true
                self.latNFC = nil
                self.longNFC = nil
                self.loadingView.removeFromSuperview()
                switch error?.error_code ?? 01 {
                case 401, 500 ... 600, 1001, 2102, 01, 625:
                    self.newSaveOfflineReport(report: report)
                    self.sendTrackingReportByReportType(type: type)
//                    NavigationController.shared?.showSuccessView(message: "offline_report_message".localized)
                    print("success")
                    break
                case 1701:
                    if type == .workStart {
                        UserDefaultsManager.isLogin = false
                    }
                    else  if type == .workEnd {
                        UserDefaultsManager.isLogin = true
                    }
                    
                    self.delegate?.shouldShowErrorForNFC("error_1701".localized, title: "\(error!.error_code ?? 1701)")
                    print("failure 1701")
                case 1700:
                    if type == .workStart {
                        UserDefaultsManager.isLogin = false
                    }
                    else  if type == .workEnd {
                        UserDefaultsManager.isLogin = true
                    }
                    
                    self.delegate?.shouldShowErrorForNFC("error_1700".localized, title: "\(error!.error_code ?? 1700)")
                    print("failure 1700")
                default:
                    if type == .workStart {
                        UserDefaultsManager.isLogin = false
                    }
                    else  if type == .workEnd {
                        UserDefaultsManager.isLogin = true
                    }
                    
                    self.delegate?.shouldShowError(error)
                    print("failure")
                }
            }
        }
        
        if !isReportSent{
            requestTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: false, block: { [weak self] timer in
                if !isReportSent{
                    self?.requestTimer?.invalidate()
                    self?.requestTimer = nil
                    report?.apiManager.cancelSession()
                    self?.newSaveOfflineReport(report: report)
                    self?.sendTrackingReportByReportType(type: type)
//                    NavigationController.shared?.showSuccessView(message: "offline_report_message".localized)
                    return
                }
            })
        }
        
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
    
    func sendSampleReport() {
        //guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        vc?.view.addSubview(loadingView)
        
        let location = LocationManager.shared.getCurrentLocation()
        let lon = location?.coordinate.longitude
        let lat = location?.coordinate.latitude
        let accuracy = 16
        
        let task = getTaskByActionType(.sampleReport)
        let taskId: String? = task?.taskId ?? unknownTask?.taskId
        let taskName: String? = task?.taskName ?? unknownTask?.taskName
        let remark = task?.remark ?? absenceReport?.remark
        
        let endpoint = SampleReportEndpoint(type: .sampleReport, taskId: taskId, taskName: taskName, remark: remark, lat: lat, lon: lon, accuracy: accuracy)
        endpoint.apiCall { [weak self] (response, error) in
            self?.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                if let info = response?.data {
                    self?.showSampleInfoAlert(info)
                }
            } else {
                self?.delegate?.shouldShowError(error)
            }
        }
    }
    
    func showSampleInfoAlert(_ info: SampleReportObj) {
        let alertController = UIAlertController(title: info.polygon, message: info.address, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "SHOW_TRAKING_CONFIRM_TITLE".localized, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve
        
        NavigationController.shared?.present(alertController, animated: true, completion: nil)
    }
    
    
    func sendMultipleReport(multipleReport: MultipleReportObj) {
        //  guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        vc?.view.addSubview(loadingView)
        var lat : CLLocationDegrees?
        var lon : CLLocationDegrees?
        if shouldReportLocation{
            let location = LocationManager.shared.getCurrentLocation()
            
            let longitude = location?.coordinate.longitude
            let latitude = location?.coordinate.latitude
            lat = latitude
            lon = longitude
        }
        
        let accuracy = 16
        
        let report = ReportEndpoint(type: multipleReport.type.reportType, taskId: multipleReport.task?.taskId, remark: multipleReport.remark, lat: lat, lon: lon, accuracy: accuracy, tagUID: "", empIds: multipleReport.employees)
        report.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                CompaniesDataManager.shared.setReportList(reports: result?.data ?? [])
                self.delegate?.shouldRefreshView()
                self.updateMultiReportData(multipleReport: multipleReport)
                self.showConfirmViewFor(multipleReport: multipleReport)
            } else {
                self.delegate?.shouldShowError(error)
            }
        }
    }
    
    func sendSalesAmountReport(sales: String) {
        guard let salesAmount = Double(sales) else { return }
        
        vc?.view.addSubview(loadingView)
        
        let type: ReportActionType = .workEnd
        let taskId: String? = selectedTask?.taskId
        let location = LocationManager.shared.getCurrentLocation()
        let lon = location?.coordinate.longitude
        let lat = location?.coordinate.latitude
        let accuracy = 16
        
        let extraFields = ["bisum_amount": salesAmount]
        
        let report = ReportEndpoint(type: type, taskId: taskId, lat: lat, lon: lon, accuracy: accuracy,tagUID: "", extraFields: extraFields)
        report.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                CompaniesDataManager.shared.setReportList(reports: result?.data ?? [])
                self.delegate?.shouldRefreshView()
                self.resetBreakTime(type: type)
                self.sendTrackingReportByReportType(type: type)
                self.showStartDistanceMeasurementByReportType(type: type)
                self.shouldShowConfirm(type: type)
                
                
            } else {
                // self.removeSelectedTask()
                self.delegate?.shouldShowError(error)
            }
        }
    }
    
    func sendTrackingReportByReportType(type: ReportActionType) {
        switch type {
        case .workStart, .serviceEntry:
            if hasTracking {
                sendTrackingReport(type: .startTracking)
            }
        case .workEnd, .serviceExit:
            if hasTracking {
                sendTrackingReport(type: .endTracking)
            }
        default:
            break
        }
    }
    
    func sendTrackingReport(type: ReportActionType = .trackGeolocation) {
        updateTrackingStatus(type: type)
        
//        guard !(!ReachabilityManager.shared.hasInternetConnection && (type == .startTracking   ||
//                                                                      type == .endTracking      ||
//                                                                      type == .trackGeolocation ||
//                                                                      type == .endAndStartWork  ||
//                                                                      type == .workEnd          ||
//                                                                      type == .workStart )) else {
//            
//            OfflineRequestsManager.sharedInstance.save(type: type.rawValue)
//            NavigationController.shared?.showSuccessView(message: "OFFLINE_MODE_REPORT_SAVED".localized)
//            
//            return
//        }
        
        let endpointType: EndpointItemType = .reportTracking
        let location = LocationManager.shared.getCurrentLocation()
        let lon = location?.coordinate.longitude ?? 0
        let lat = location?.coordinate.latitude ?? 0
        let accuracy = 16
        
        let report = ReportEndpoint(endpointType: endpointType, type: type, lat: lat, lon: lon, accuracy: accuracy, tagUID: "")
        report.apiCall { (_, error) in
            if error?.success ?? false {
                print("sendTrackingReport: success")
            } else {
                switch error?.error_code ?? 01 {
                case 500 ... 600, 1001, 2102, 01, 401:
//                    OfflineRequestsManager.sharedInstance.save(type: type.rawValue)
//                    NavigationController.shared?.showSuccessView(message: "OFFLINE_MODE_REPORT_SAVED".localized)
                    break
                default:
                    print("sendTrackingReport: faile")
                }
                
            }
        }
    }
    
    func sendGeolocationReports() {
        if trackingStarted, let frequency = CompaniesDataManager.shared.getTrackFrequency() {
            tracker.initLocationTracking(every: Double(frequency))
            
        } else {
            trackingStarted = false
            tracker.stopLocationTracking()
        }
    }
    
    // distance measurement
    func sendDistance(type: DistanceMeasurementType, distance: Double?) {
        
        guard !(!ReachabilityManager.shared.hasInternetConnection && (type == .startTracking || type == .stopTracking )) else {
            
            OfflineRequestsManager.sharedInstance.save(type: type.rawValue, distance: distance, accuracy: 16)
            NavigationController.shared?.showSuccessView(message: "OFFLINE_MODE_REPORT_SAVED".localized)
            
            self.updateDistanceMeasurementState(type: type)
            self.delegate?.shouldRefreshTrackingView()
            
            if type == .stopTracking {
                self.delegate?.shouldShowTrackedDistanceView()
            }
            return
        }
        
        // guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        vc?.view.addSubview(loadingView)
        
        let location = LocationManager.shared.getCurrentLocation()
        let lon = location?.coordinate.longitude
        let lat = location?.coordinate.latitude
        let accuracy = 16
        
        let distanceEndpoint = WriteDistanceEndpoint(type: type.rawValue, distance: distance, lat: lat, lon: lon, accuracy: accuracy)
        distanceEndpoint.apiCall { (result) in
            self.loadingView.removeFromSuperview()
            
            if result?.success ?? false {
                
                self.updateDistanceMeasurementState(type: type)
                self.delegate?.shouldRefreshTrackingView()
                if type == .stopTracking {
                    self.delegate?.shouldShowTrackedDistanceView()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UserDefaultsManager.lastUserDistance = 0
                    TSLocationManager.sharedInstance()?.destroyLocations()
                    TSLocationManager.sharedInstance()?.setOdometer(0, request: TSCurrentPositionRequest())
                }
                
            } else {
                if result == nil || result?.error_code == 500 || result?.error_code == 401 {
                    OfflineRequestsManager.sharedInstance.save(type: type.rawValue, distance: distance, accuracy: 16)
                    NavigationController.shared?.showSuccessView(message: "OFFLINE_MODE_REPORT_SAVED".localized)
                } else {
                    self.delegate?.shouldShowError(result)
                }
            }
        }
    }
    
    func sendAddRide(type: RideType, value: String) {
        guard let valueDouble = Double(value) else { return }
        vc?.view.addSubview(loadingView)
        
        guard type.rawValue == 1 else { return }
        
        let addRideEndpoint = AddRideEndpoint(type: type.rawValue, param: valueDouble)
        addRideEndpoint.apiCall {(result) in
            self.loadingView.removeFromSuperview()
            
            if !(result?.success ?? false) {
                self.delegate?.shouldShowError(result)
            }
        }
    }
    
    // health disclaimer api
    func loadDisclaimerData() {
        vc?.view.addSubview(loadingView)
        
        let health = ShowHealthDisclaimerEndpoint()
        health.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                if result?.show ?? false {
                    self.delegate?.shouldShowHealthDisclaimer(.disclaimer, result?.disclaimer)
                } else {
                    self.delegate?.shouldShowConfirmView(.loginConfirm, false)
                }
            } else {
                if error?.error_code == nil {
                    if result?.show ?? false {
                        self.delegate?.shouldShowHealthDisclaimer(.disclaimer, result?.disclaimer)
                    } else {
                        self.delegate?.shouldShowConfirmView(.loginConfirm, false)
                    }
                }
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }
    
    func sendHealthDisclaimer() {
        vc?.view.addSubview(loadingView)
        
        let acceptHealthDisclaimer = AcceptHealthDisclaimerEndpoint()
        acceptHealthDisclaimer.apiCall { (_, error) in
            self.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                // self.delegate?.showHealthDisclaimer(.accepted, nil)
                self.sendReport(type: .workStart, remark: "")
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }
    
    // Offline mode
    func startDataLoading(completion: @escaping ()-> ()) {
        if LocationManager.shared.isLocationEnabled() && UserDefaultsManager.connectionServiceCount > 0 {
            let request = EchoEndpoint()
            request.apiCall { [weak self] result, error in
                self?.requestTimer?.invalidate()
                self?.requestTimer = nil
                
                if error?.error_code == -999 {
                    self?.offlineModeLabelHidden = false
                    CompaniesDataManager.shared.getFromCache()
                    self?.delegate?.shouldRefreshView()
                    completion()
                } else {
//                    self?.checkSavedRequests()
                    completion()
                }
            }
            
            requestTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { [weak self] timer in
                self?.requestTimer?.invalidate()
                self?.requestTimer = nil
//                request.apiManager.cancelSession()
            })
        } else {
            offlineModeLabelHidden = false
            CompaniesDataManager.shared.getFromCache()
            delegate?.shouldRefreshView()
            completion()
        }
    }
    
    func checkSavedRequests(isFromReachability: Bool = false) {
        let requests = OfflineRequestsManager.sharedInstance.fetch(Request.self)
        
        guard requests.count > 0 else {
            
            if waitingForLoadData {
                
                self.loadData(isFromReachability: isFromReachability)
                
            }
            self.loadingView.removeFromSuperview()
            return
        }
        
        if let request = requests.first {
            self.vc?.view.addSubview(self.loadingView)
            let endpoint = OfflineRequestEndpoint(offlineRequest: request)
            endpoint.apiCall { (_, error) in
                if error?.success ?? false || error == nil {
                    self.waitingForLoadData = true
                    OfflineRequestsManager.sharedInstance.delete(request)
                    self.checkSavedRequests(isFromReachability: isFromReachability)
                } else {
                    NavigationController.shared?.showErrorView(error: error)
                    
                    self.loadData()
                    
                    self.loadingView.removeFromSuperview()
                }
            }
        }
    }
    
    func newFetchOfflineReport(isFromReachability: Bool = false){
        if var offlineData = UserDefaultsManager.sampleDictArray, offlineData.count > 0 {
//            print(offlineData)
            
            if offlineData.count > 0{
                if let dict = offlineData.first, let action = dict["action"] as? String, action.count > 0 {
                    let endpoint = NewOfflineRequestEndpoint(action: action)
                    print(endpoint.endpointType)
                    print(dict)
                    
                    endpoint.offlineReportApiCall(dict) { (_, error) in
                        if error?.success ?? false || error == nil {
                            self.waitingForLoadData = true
                            offlineData.removeFirst()
                            UserDefaultsManager.sampleDictArray = offlineData
                            self.newFetchOfflineReport(isFromReachability: isFromReachability)
                        } else {
                            NavigationController.shared?.showErrorView(error: error)
                            
                            self.loadData()
                            
                            self.loadingView.removeFromSuperview()
                        }
                    }
                }
            }else{
                if waitingForLoadData {
                    self.loadData(isFromReachability: isFromReachability)
                }
                self.loadingView.removeFromSuperview()
                return
            }
        }else{
            if waitingForLoadData {
                self.loadData(isFromReachability: isFromReachability)
            }
            self.loadingView.removeFromSuperview()
            return
        }
    }
    
    func checkAppVersion() {
        AppStoreUpdate.shared.showAppStoreVersionUpdateAlert(isForceUpdate: false)
    }
    
    func checkLastUserDistance() {
        print("\n\n\n\n\n\n\n\n\n\n \( String(describing: UserDefaultsManager.lastUserDistance)) \n\n\n\n\n\n\n\n\n\n\n")
        guard let distance = UserDefaultsManager.lastUserDistance else {return}
        if  distance != 0 {
            
            print("UserDefaultsManager.lastUserDistance \(String(describing: UserDefaultsManager.lastUserDistance))")
            let vc = ViewSource.distanceConfirmView()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            
            vc.viewModel = DistanceConfirmViewModel(type: .stopTracking, hasLoginTitle: false)
            
            vc.confirmAction = {
                self.sendDistanceMeasurementBy(type: .stopTracking)
            }
            
            vc.closeAction = {
                self.sendWaitingReportType()
            }
            NavigationController.shared?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func saveAppStatusRequestOffline(for request: AppStatusEndpoint) {
        OfflineRequestsManager.sharedInstance.save(type: request.endpointType.rawValue, appVersion: request.appVersion, hasLocationPermission: request.hasGPSPermission, locationEnabled: request.gpsEnabled, batteryLevel: request.batterySaving, isFlightMode: request.flightMode)
    }
    
    func sendAppStatusInfo() {
        guard UserDefaultsManager.udid != nil, UserDefaultsManager.phoneNumber != nil else { return }
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        let hasLocationPermission = LocationManager.shared.hasPermission()
        let locationServicesEnabled = LocationManager.shared.isLocationEnabled()
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        let isFlightMode = ReachabilityManager.shared.checkFlightMode()
        
        let endpoint = AppStatusEndpoint(appVersion: appVersion, hasGPSPermission: hasLocationPermission, gpsEnabled: locationServicesEnabled, batterySaving: Int(batteryLevel * 100), flightMode: isFlightMode)
        
        guard ReachabilityManager.shared.isOnline else {
            saveAppStatusRequestOffline(for: endpoint)
            return
        }
        
        endpoint.apiCall { response, error in }
    }
    
    func createTask(_ taskName: String, forProject projectId: Int, completion: @escaping (() -> ())) {
        vc?.view.addSubview(loadingView)
        let createTaskEndpoint = AddProjectTaskEndpoint(taskName: taskName, projectId: "\(projectId)")
        createTaskEndpoint.apiCall { response, error in
            if let tasks = response?.data {
                var finalTasks: [TaskObj] = []
                for task in tasks {
                    if let task = task {
                        finalTasks.append(task)
                    }
                }
                CompaniesDataManager.shared.updateTasksForCurrentCompany(finalTasks)
                
                if let addedTask = finalTasks.filter({ $0.taskId == taskName }).first {
                    self.setSelectedTask(task: addedTask)
                }
            }
            self.loadingView.removeFromSuperview()
            completion()
        }
    }
    
    func GetNFCData(handler: @escaping (_ response: CheckNFCObj) -> Void){
        
        guard UserDefaultsManager.connectionServiceCount > 0 else {
            self.showNoInternetPopup()
            return
        }
        
        vc?.view.addSubview(loadingView)
        var  checkNFC:CheckNFCEndPoint? = nil
        checkNFC = CheckNFCEndPoint(tagUID: self.tagUID)
        
        checkNFC?.apiCall { (result, error) in
            if error?.success ?? false {
                self.loadingView.removeFromSuperview()
                if let res = result, let data = res.data {
                    if let active = data.active, active == 1 {
                        handler(data)
                    }else{
                        self.delegate?.shouldShowErrorForNFC("Scaned_NFC_is_not_active".localized, title: "ERROR".localized)
                    }
                }else{
                    self.delegate?.shouldShowErrorForNFC("NFC_not_exist".localized, title: "ERROR".localized)
                }
            } else {
                self.loadingView.removeFromSuperview()
                if let errorObj = error {
                    if errorObj.error_code == 1703 {
                        self.delegate?.shouldShowErrorForNFC("error_1703_message".localized, title: "ERROR".localized)
                        return
                    }else if errorObj.error_code == 1704 {
                        self.delegate?.shouldShowErrorForNFC("error_1704_message".localized, title: "ERROR".localized)
                        return
                    }
                }
                self.delegate?.shouldShowError(error)
            }
        }
    }
}

//Revacha events
extension DashboardViewModel {
    
    func selectEvent(at index: Int) {
        guard let events = CompaniesDataManager.shared.getEvents(), events.count > index else { return }
        selectedEvent = events[index]
        do {
            try userDefaults.setObject(selectedEvent, forKey: "userSelectedEvent")
        } catch {}
    }
    
    func clearSelectedEvent() {
        selectedEvent = nil
        userDefaults.removeObject(forKey: "userSelectedEvent")
    }
    
    func getChooseEventTitle() -> String {
        var event: RevachaEventObj?
        do {
            try event = userDefaults.getObject(forKey: "userSelectedEvent", castTo: RevachaEventObj.self)
            return event?.eventName ?? "SELECT_AN_EVENT".localized
        } catch {
            return "SELECT_AN_EVENT".localized
        }
    }
}

//Benuach leumi & Revaha functionality
extension DashboardViewModel {
    
    func shouldHideWorkScheduleView() -> Bool {
        if isHolocaust{
            return true
        }
        return !CompaniesDataManager.shared.hasWorkScheduleFeature() || isAbsent
    }
    
    func workScheduleViewModel() -> DayWorkScheduleViewModel {
        return DayWorkScheduleViewModel(CompaniesDataManager.shared.getWorkScheduleItems())
    }
    
    func notForScheduleItem(at index: Int) -> String? {
        let items = CompaniesDataManager.shared.getWorkScheduleItems()
        if items.count > index {
            return items[index].note
        }
        return nil
    }
    
    func selectLocationName(with id: Int) {
        selectedLocationName = locationNames.filter { $0.locationId == id }.first
    }
    
    func clearSelectedLocationName() {
        selectedLocationName = nil
        bituachLeumiActionType = nil
    }
}

// MARK: - Get number of hours left for a task -
extension DashboardViewModel {
    func getNumberOfHours(_ taskId: String, completion: @escaping ((String?) -> ())) {
        self.vc?.view.addSubview(loadingView)
        let hoursLeftForTaskEndpoint = GetHoursLeftForTaskEndpoint(patientId: taskId)
        hoursLeftForTaskEndpoint.apiCall { [weak self] response, error in
            self?.loadingView.removeFromSuperview()
            if let hours = response?.data {
                completion(hours)
            }else {
                completion(nil)
            }
        }
    }
}

// MARK: - Get disclaimer -
extension DashboardViewModel {
    
    ///Get disclaimer text from backend
    func getDiscalimer() {
        self.vc?.view.addSubview(loadingView)
        let languageCode = AppUtility.getCurrentLanguageCode()
        let getDisclaimerEndpoint = GetDisclaimerEndpoint(disclaimerType: .trackingDisclaimer, language: languageCode)
        
        getDisclaimerEndpoint.apiCall { [weak self] response, error in
            self?.loadingView.removeFromSuperview()
            self?.delegate?.shouldShowTrackDisclaimerWith(text: response?.data)
        }
    }
}

protocol DashboardViewModelDelegate: NSObjectProtocol {
    func shouldRefreshView()
    func shouldRefreshTrackingView()
    func shouldShowTrackedDistanceView()
    func shouldShowStartTrackingView(_ hasLogin: Bool)
    func shouldShowStopTrackingView()
    func shouldShowConfirmView(_ type: ConfirmViewType, _ checkHealth: Bool)
    func shouldShowChooseTaskView()
    func shouldShowTrackingMap()
    func shouldShowTrackDisclaimerWith(text: String?)
    func shouldShowError(_ error: ErrorObject?)
    func shouldShowError(_ message: String?)
    func shouldShowHealthDisclaimer(_ type: HealthDisclaimerType, _ message: String?)
    func shouldClearEvent()
    func shouldShowRequestCompletionView(_ viewModel: RequestCompletionViewModel)
    func shouldShowErrorForNFC(_ message : String?, title: String?)
    func shouldUpdateTask()
    func shouldUpdateTimer()
    
}

// MARK: - CheckIn Confirmation
extension DashboardViewModel {
    
    func shouldShowCheckInConfirmationAlert() -> Bool {
        // Step 1: Get last report from lastreport array
        if let lastReport = self.lastReport,
           lastReport.isInProgress {
            return true
        }
        return false
    }
    
    func shouldShowCheckOutConfirmationAlert() -> Bool {
        // Step 1: Get last report from lastreport array
        if let lastReport = self.lastReport,
           lastReport.isCompleted {
            return true
        }
        return false
    }
    
    func showConfirmationAlert(delegate: CheckInConfirmationViewDelegate, isForCheckIn: Bool) {
        
        let vc = ViewSource.checkInConfirmationView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        let time = self.lastReport?.time ?? "00:00"
        
        vc.setupView(delegate: delegate, isForCheckIn: isForCheckIn, time: time)
        
        
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
}

// MARK: - Patient not at home api call
extension DashboardViewModel {
    func patientNotAtHome() {
        vc?.view.addSubview(loadingView)
        
        let location = LocationManager.shared.getCurrentLocation()
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        let taskId: String? = selectedTask?.taskId
        
        let patientNotAtHome = PatientNotAtHomeEndpoint(latitude: latitude, longitude: longitude, taskID: taskId)
        
        patientNotAtHome.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()
            
            if error?.success ?? false {
                let alert = AppUtility.getAlertWith(title: nil, message: "reportReceivedSuccessfully".localized)
                NavigationController.shared?.present(alert, animated: true, completion: nil)
            } else {
                self.delegate?.shouldShowError(error)
            }
        }
    }
}
