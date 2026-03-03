//
//  CompaniesDataManager.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import UIKit
import CoreMIDI

class CompaniesDataManager {

    static let shared = CompaniesDataManager()

    private var companies: [CompanyObj]?

    var currentClientId: Int = -1
    private var currentDate: Date?
    private var dateTimer: Timer?
    private var dateWorkItem: DispatchWorkItem?
    var initialTimerForUpdateUI: Int = 0

    func setCompanies(_ companies: [CompanyObj]?) {
        self.companies = companies
        updateCompaniesInCache()
        self.currentClientId = UserDefaultsManager.clientId ?? -1
        if currentClientId == -1 && (companies ?? []).count > 0 {
            let company = companies![0]
            currentClientId = company.clientId ?? -1
        }
        UserDefaultsManager.empId = getEmployeeId()

        guard CompaniesDataManager.shared.hasAppPermission() else {
            if NavigationController.shared?.getCurrentViewController()?.isKind(of: DashboardViewController.self) ?? false {
                NavigationController.shared?.setRoot(ViewSource.dashboardWithoutAppAccessScreen(), animated: false)
            }
            return
        }
        
        setupCurrentDateIfRequired()
    }
    
    //check NFC
    func isNFC() -> Bool? {
        if let isNFC = currentCompany()?.nfc as? String{
            return true
        }
        return nil
    }
    
    //Approved Hours
    func getApprovedHours() -> ApproveHourObj? {
        if let approvedHours = currentCompany()?.approveHours as? ApproveHourObj{
            return approvedHours
        }
        return nil
    }

    // get employee data
    func getEmployeeName() -> String? {
        return currentCompany()?.employeeName
    }

    func getEmployeeEmail() -> String? {
        return currentCompany()?.employeeEmail
    }

    func getEmployeeId() -> Int? {
        return currentCompany()?.employeeId
    }

    func getClientName() -> String? {
        return currentCompany()?.clientName
    }
    func getClienId() -> Int? {
        return currentCompany()?.clientId
    }
    
    func getApplicationmustbeupdated() -> Int? {
        return currentCompany()?.applicationmustbeupdated
    }

    func getAvailableCompanies() -> [CompanyObj] {
        return companies ?? []
    }
    
    func getCurrentCompanyDailyStudentReport() -> [String: [DailyStudentReportsObj]]? {
//        return currentCompany()?.dailyStudentReports
        if let company = currentCompany(), let studentReport = company.dailyStudentReports {
            return studentReport
        }
        return nil
    }
    
    func getStudentData(for date: String) -> [DailyStudentReportsObj]? {
        
        if let company = currentCompany(), let studentReport = company.dailyStudentReports {
            guard let projects = studentReport[date] else {
                return [] // No data for the given date
            }
            return projects
        }
        return nil
    }
    
    func getCoordinatorID() -> Int? {
        return currentCompany()?.Coordinator
    }
    
    func getAvailableCompanyNames() -> [String] {
        guard let companiesArray = companies else { return [] }

        var companyNames: [String] = []

        for company in companiesArray {
            if company.appPermission == 1 {
                companyNames.append(company.clientName ?? "")
            }
        }

        return companyNames
    }

    func getMonthStatistics() -> [String: MonthObj]? {
        return currentCompany()?.monthlyStats
    }

    func getEmployeeIdForTrackDisclaimer() -> Int? {
        var empId: Int?

        for company in (companies ?? []) {
            if company.showTrackingDisclaimer == 1 {
                empId = company.employeeId
            }
        }

        return empId
    }

    // get tasks data
    func getTodayWorkingTime() -> Int {
        return currentCompany()?.todayWorkingTime ?? 0
    }

    func getActiveBreakTime() -> Int {
        return currentCompany()?.activeBreakTime ?? 0
    }

    func getAvailableTasks() -> [TaskObj?] {
        var tasks = currentCompany()?.tasks ?? []
//        tasks.append(contentsOf: AdditionalTasksManager.savedTasks())
        return tasks
    }
    
    func getTherapyeventTypes() -> [TherapyeventTypesObj?] {
        var tasks = currentCompany()?.therapyevent_types ?? []
        return tasks
    }
    
    func getCityList() -> [CitylistObj?] {
        let cities = currentCompany()?.citylist ?? []
        return cities
    }
    
    func updateTasksForCurrentCompany(_ tasks: [TaskObj]) {
        var companiesList: [CompanyObj] = []
        for company in companies ?? [] {
            if company.clientId == currentClientId {
                var currentCompany = company
                let tasksObject: Tasks = .tasksArray(tasks)
                currentCompany.taskList = tasksObject
                companiesList.append(currentCompany)
                updateCurrentCompany(currentCompany)
            } else {
                companiesList.append(company)
            }
        }
        companies = companiesList
        updateCompaniesInCache()
    }
    
    
    
    func getEvents() -> [RevachaEventObj]? {
        return currentCompany()?.events
    }

    func getLastReports() -> [ReportObj?] {
        if let company = currentCompany(), var arr = company.lastReports, arr.count > 0{
            
            let offlineReportarr = OfflineRequestsManager.sharedInstance.getOfflineReport()
            print(offlineReportarr)
            
            arr.append(contentsOf: offlineReportarr)
            
            arr.sort { $0!.time > $1!.time }
            return arr
        }else{
            var offlineReportarr = OfflineRequestsManager.sharedInstance.getOfflineReport()
            print(offlineReportarr)
            offlineReportarr.sort { $0.time > $1.time }
            return offlineReportarr
        }
//        guard var lastReports = currentCompany()?.lastReports as? [ReportObj] else { return [] }
//        lastReports.sort { $0.time > $1.time }
//        return lastReports
    }
    
    func getLastReportsWithoutSort() -> [ReportObj?] {
        guard var lastReports = currentCompany()?.lastReports as? [ReportObj] else { return [] }
        return lastReports
    }

    func getLastReportsForTaskBar() -> [ReportObj] {
        guard let lastReports = getLastReports() as? [ReportObj] else { return [] }
        let oppositReports = lastReports.sorted { $0.time < $1.time }
        
        var additionalButton1ActionType = ""
        var additionalButton2ActionType = ""
        var additionalButton3ActionType = ""
        var additionalButton4ActionType = ""

        if let additionalButtons = CompaniesDataManager.shared.getAddonButtons() {
            additionalButton1ActionType = additionalButtons.button_1?.action_type?.description ?? ""
            additionalButton2ActionType = additionalButtons.button_2?.action_type?.description ?? ""
            additionalButton3ActionType = additionalButtons.button_3?.action_type?.description ?? ""
            additionalButton4ActionType = additionalButtons.button_4?.action_type?.description ?? ""
        }

        let filtered = oppositReports.filter {($0.actionType?.elementsEqual("1") ?? false)
            || ($0.actionType?.elementsEqual("2") ?? false)
            || ($0.actionType?.elementsEqual("98") ?? false)
            || ($0.actionType?.elementsEqual("99") ?? false)
            || ($0.actionType?.elementsEqual(ReportActionType.serviceEntry.rawValue) ?? false)
            || ($0.actionType?.elementsEqual(ReportActionType.serviceExit.rawValue) ?? false)
            || ($0.actionType?.elementsEqual(additionalButton1ActionType) ?? false)
            || ($0.actionType?.elementsEqual(additionalButton2ActionType) ?? false)
            || ($0.actionType?.elementsEqual(additionalButton3ActionType) ?? false)
            || ($0.actionType?.elementsEqual(additionalButton4ActionType) ?? false)
            || $0.actionType == nil }

        return filtered
    }

    func getLastReportsForTrackingMap() -> [ReportObj] {
        guard let lastReports = getLastReports() as? [ReportObj] else { return [] }

        let filtered = lastReports.filter {($0.actionType?.elementsEqual("1") ?? false)
            || ($0.actionType?.elementsEqual("2") ?? false)
            || ($0.actionType?.elementsEqual("98") ?? false)
            || ($0.actionType?.elementsEqual("99") ?? false) }

        return filtered
    }

    func getLastLoginLogoutReports() -> [ReportObj] {
        guard let lastReports = getLastReports() as? [ReportObj] else { return [] }
        
        let filtered = lastReports.filter {($0.actionType?.elementsEqual("1") ?? false) || ($0.actionType?.elementsEqual("2") ?? false) || ($0.actionType?.elementsEqual(ReportActionType.serviceEntry.rawValue) ?? false) || ($0.actionType?.elementsEqual(ReportActionType.serviceExit.rawValue) ?? false)}

        return filtered
    }

    func getLastLoginReport() -> ReportObj? {
        let reports = getLastLoginLogoutReports()
        print("getLastLoginReport() currentClientId",self.currentClientId)
        guard let report = reports.first else { return nil }

//        guard report.actionType == "1" || report.actionType == ReportActionType.serviceEntry.rawValue else {
//            return nil
//        }
//
//        return report
        
        if report.actionType == "1" || report.actionType == ReportActionType.serviceEntry.rawValue {
            return report
        }else{
            return nil
        }
    }
    
    func isLastReportLogin() -> Bool {
        guard let report = getLastLoginReport() else {return false}
        print("isLastReportLogin() currentClientId",self.currentClientId)
        if report.actionType == "1" || report.actionType == ReportActionType.serviceEntry.rawValue {
            return true
        }else{
            return false
        }
    }

    func getLastLoginTask() -> TaskObj? {
        guard let report = getLastLoginReport() else { return nil }

        guard let tasks = getAvailableTasks() as? [TaskObj] else { return nil }
        guard let reportTaskName = report.taskName else { return nil }

        let task = tasks.first(where: { $0.taskName.elementsEqual(reportTaskName) })

        return task
    }

    func getLastLoginUnknownTask() -> TaskObj? {
        guard let report = getLastLoginReport() else { return nil }
        let task = TaskObj(taskId: report.taskId ?? "", taskName: report.taskName ?? "", projectId: nil, projectName: nil, remark: nil, hoursLimit: nil, hoursCompleted: nil, distanceSettings: nil, fromTime: nil, toTime: nil)
        return task
    }
    
    func getLastBreakReport() -> ReportObj? {
        guard let lastReports = getLastReports() as? [ReportObj] else { return nil }

        guard let report = lastReports.first else { return nil }

        guard report.actionType == "98" else { return nil }

        return report
    }

    func getLastAbcenseReport() -> ReportObj? {
        guard let lastReports = getLastReports() as? [ReportObj] else { return nil }
        
        if lastReports.count > 0 {
            print("")
        }
        
        guard let report = lastReports.first else { return nil }

        if let actionType = Int(report.actionType ?? "") {
            let absenceTypes = getAbsenceTypes()
            if absenceTypes.contains(actionType) {
                return report
            }
        }

        return nil
    }

    func getAvailableAbsenceTypes() -> [AbsenceTypeEntity] {
        guard let absenceIndexes = currentCompany()?.settings?.absenceTypes else { return [] }

        var absenceTypes: [AbsenceTypeEntity] = []

        for type in absenceIndexes {
            if let absence = AbsenceTypeEntity.withIdentifier(type) {
                absenceTypes.append(absence)
            }
        }

        return absenceTypes
    }

    func getAvailableAbsenceTypeStrings() -> [String] {
        let absenceTypes = getAvailableAbsenceTypes()
        var absenceTypeStrings: [String] = []

        for type in absenceTypes {
            if let absence = AbsenceTypeEntity.withIdentifier(type.idetifier) {
                absenceTypeStrings.append(absence.absenceTitle)
            }
        }

        return absenceTypeStrings
    }

    // Standard Work Time
    func hadStandardWorkTime() -> Bool {
        return currentCompany()?.standards != nil
    }

    func getStandardStartTime() -> String {
        if (currentCompany()?.standards ?? []).count == 0 {
            return ""
        }
        return currentCompany()?.standards?[0]?.startTime ?? ""
    }

    func getStandardFinishTime() -> String {
        if (currentCompany()?.standards ?? []).count == 0 {
            return ""
        }
        return currentCompany()?.standards?[0]?.finishTime ?? ""
    }

    // multi login data - IVR5
    func getDepartments() -> [DepartmentObj] {
        return currentCompany()?.empsByDepartment ?? []
    }

    // settings
    func hasAppPermission() -> Bool {
        return currentCompany()?.appPermission == 1
    }

    func getAbsenceTypesWithMandatoryPicture() -> [Int] {
        return currentCompany()?.settings?.absenceTypesMustPict ?? []
    }

    func getAbsenceTypes() -> [Int] {
        return currentCompany()?.settings?.absenceTypes ?? []
    }

    func hasChooseTaskFeature() -> Bool {
        return (currentCompany()?.settings?.showTasks ?? 0) == 0 ? false : true
    }

    func shouldUseLastTask() -> Bool {
        return (currentCompany()?.settings?.useLastTask ?? 0) == 0 ? false : true
    }

    func isAbsentToday() -> Bool {
        return currentCompany()?.isAbsentToday == 1
    }
    
   
    
    func shouldReportTask() -> Bool {
        return (currentCompany()?.settings?.mustReportTask ?? 0) == 0 ? false : true
    }

    func hasReportFeature() -> Bool {
        return currentCompany()?.settings?.showReports == 1
    }

    func hasMyReportsFeature() -> Bool {
        if currentCompany()?.settings?.showReports == 1 {
            return true
        }
        return false
    }

    func hasAddTaskFeature() -> Bool {
        
//        if let curCompany = currentCompany(), let settings = curCompany.settings{
//            if let showTask = settings.showTasks, showTask == 1{
//                return true
//            }
//
//            if let showTask = settings.useLastTask, showTask == 1{
//                return true
//            }
//
//            if let showTask = settings.taskOnlySelect, showTask == 1{
//                return false
//            }
//        }
//        return false
        
        return (currentCompany()?.settings?.taskOnlySelect ?? 0) == 1 ? false : true
    }

    func hasShowReportsFeature() -> Bool {
        return (currentCompany()?.settings?.showReports ?? 0) == 1 ? true : false
    }

    func hasTrackingFeature() -> Bool {
        return (currentCompany()?.settings?.showTracking ?? 0) == 0 ? false : true
    }
    
    func hasRequestExitCompletionFeature() -> Bool {
        return (currentCompany()?.settings?.requestExitCompletion ?? 0) == 0 ? false : true
    }
    
    func lastEntryObject() -> LastEntryObj? {
        return currentCompany()?.settings?.lastEntry
    }
    
    func disableRequestExitCompletion() {
        guard var currentCompany = currentCompany() else { return }
        currentCompany.settings?.requestExitCompletion = 0
        currentCompany.settings?.lastEntry = nil
        
        var tempCompanies: [CompanyObj] = []
        for company in companies ?? [] {
            if company.clientId == currentCompany.clientId {
                tempCompanies.append(currentCompany)
            } else {
                tempCompanies.append(company)
            }
        }
        companies = tempCompanies
    }

    func getTrackFrequency() -> Int? {
        return currentCompany()?.settings?.trackFrequency ?? 0
    }

    func shouldAskLocationPermission() -> Bool {
        return (currentCompany()?.settings?.reportWithoutPosition ?? 0) == 0 ? true : false
    }
    
    func shouldReportWithoutPosition()->Bool{

        return (currentCompany()?.settings?.reportWithoutPosition ?? 0) == 1 ? true : false
    }
    func mustReportPosition() -> Bool {
 
        return (currentCompany()?.settings?.mustReportPosition ?? 0) == 1 ? true : false
    }

    func hasDistanceMeasurementFeature() -> Bool {
        return (currentCompany()?.settings?.showDistance ?? 0) == 1 ? true : false
    }

    func hasTrackingDisclaimer() -> Bool {
        for company in companies ?? [] {
            if (company.showTrackingDisclaimer ?? 0) == 1 {
                return true
            }
        }
        return false
    }

    func hasBreakFeature() -> Bool {
        return (currentCompany()?.settings?.showBreaks ?? 0) == 1 ? true : false
    }
    
    func hasImHereFeature() -> Bool {
        return (currentCompany()?.settings?.IamHereButton ?? 0) == 1 ? true : false
    }

    func hasAbsenceFeature() -> Bool {
        return (currentCompany()?.settings?.showAbsences ?? 0) == 1 ? true : false
    }

    func hasMultiReportFeature() -> Bool {
        return currentCompany()?.settings?.reportOthersEmps == 1
    }

    func hasCloseMonthFeature() -> Bool {
        return currentCompany()?.settings?.closeMonth == 1
    }

    func mustReportPairs() -> Bool {
        return currentCompany()?.settings?.mustReportPairs == 1
    }

    func hasReportCompletionFeature() -> Bool {
        return currentCompany()?.settings?.reportCompletion == 1
    }
    func hasReportAddFeature() -> Bool {
          return currentCompany()?.settings?.ReportCompletionAdd == 1
    }
    func hasReportEditFeature() -> Bool {
        return currentCompany()?.settings?.ReportCompletionEdit == 1
    }
    func hasReportDeleteFeature() -> Bool {
         return currentCompany()?.settings?.ReportCompletionDelete == 1
    }
    
    func shouldCompleteMonth() -> Bool {
        return currentCompany()?.settings?.closeMonthNeedComplete == 1
    }
    
    func hasBarcodeReportsFeature() -> Bool {
     
        return currentCompany()?.settings?.barcodeReports == 1
    }
    //NFC Feature
    func hasNFCReportsFeature() -> Bool {
        return  currentCompany()?.settings?.NFCReportAppButton == 1
//        if let com = currentCompany(), let str = com.nfc, str.count > 0{
//            return true
//        }
//        return false
    }
    
    func hasNFCReportAppAutomatically() -> Bool {
        return currentCompany()?.NFCReportAppAutomatically == 1
    }
    
//    func hasNFCReportMandatorySelectTaskTaskFeature() -> Bool {
//        return  currentCompany()?.settings?.NFCReportAppWithTask == 1
//    }
    
    func hasNFCReportMandatoryThroughNFCScanFeature() -> Bool {
//        return currentCompany()?.settings?.NFCReportAppTaskMundatory == 1
        return currentCompany()?.nfcMandatory == 1
    }
    
//    func hasNFCLocationVerificationFeature() -> Bool {
//        return  currentCompany()?.settings?.NFCLocationVerificationAppButton == 1
//    }

    func hasCreateClientTaskFeature() -> Bool {
        return currentCompany()?.settings?.allowCreateProjectTask == 1
    }

    func hasWorkScheduleFeature() -> Bool {
        return currentCompany()?.settings?.workSchedule == 1
    }
    
    // TravelReportFromApprovedTable
    func shouldTravelReportEnable() -> Bool {
        return currentCompany()?.settings?.TravelReportFromApprovedTable == 1
    }
    
    // ManualTravelReport
    func shouldManualTravelReportEnable() -> Bool {
        return currentCompany()?.settings?.ManualTravelReport == 1
    }
    
    // report with picture
    func shouldReportLoginWithPicture() -> Bool {
        return currentCompany()?.settings?.mustPictureOnEntry == 1
    }

    func shouldReportLogoutWithPicture() -> Bool {
        return currentCompany()?.settings?.mustPictureOnExit == 1
    }

    func getReportWithPictureText() -> String {
        return currentCompany()?.settings?.mustPictureText ?? ""
    }

    // health disclaimer
    func shouldShowHealthDisclaimer() -> Bool {
        return currentCompany()?.settings?.showHealthDisclaimer == 1
    }

    func mustAcceptHealthDisclaimer() -> Bool {
        return currentCompany()?.settings?.mustHealthDisclaimer == 1
    }
    
    func isChatActive() -> Bool {
        return currentCompany()?.settings?.chatboot == 1
    }
    
    func getChatURL() -> String? {
        return currentCompany()?.settings?.chatbooturl
    }

    // special clients
    func getClientGrpId() -> Int? {
        return currentCompany()?.clientGrpId
    }

    func getSpecialClientType() -> Int? {
        return currentCompany()?.specialRules
    }
    
    func getAddonButtons() -> AddonButtonsObj? {
        return currentCompany()?.addonButtons
    }
    
    func getLocationMames() -> [LocationNameObj]? {
        return currentCompany()?.locationNames
    }
    
    func getFormsData() -> [FormData]? {
        let filteredArray = currentCompany()?.formsdata
        return filteredArray
    }
    
    func hasFormsFeature() -> Bool {
        //return true
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return false
        }
        return formsData.contains { $0.conditions?.showInMyForms == 1 }
    }
    
    func getEnterFormCount() -> [FormData]? {
        //return true
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return nil
        }
        let enterFormData = CompaniesDataManager.shared.getFormsData()?.filter({$0.conditions!.showInAllReports!.enter! == "1"})
        return enterFormData
    }
    
    func getExitFormCount() -> [FormData]? {
        //return true
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return nil
        }
        let enterFormData = CompaniesDataManager.shared.getFormsData()?.filter({$0.conditions!.showInAllReports!.exit! == "1"})
        return enterFormData
    }

    func getEnterServiceFormCount() -> [FormData]? {
        //return true
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return nil
        }
        let enterFormData = CompaniesDataManager.shared.getFormsData()?.filter({$0.conditions!.showInAllReports!.enterService! == "1"})
        return enterFormData
    }
    
    func getExitServiceFormCount() -> [FormData]? {
        //return true
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return nil
        }
        let enterFormData = CompaniesDataManager.shared.getFormsData()?.filter({$0.conditions!.showInAllReports!.exitService! == "1"})
        return enterFormData
    }
    
    func hasFormsEnterFeature() -> Bool {
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return false
        }
        
//        if let dict = formsData.first, let conditions = dict.conditions, let showInAllReports = conditions.showInAllReports, let enter = showInAllReports.enter{
//            if enter == "1"{
//                return true
//            }else{
//                return false
//            }
//        }else{
//            return false
//        }
        
        return formsData.contains { $0.conditions?.showInAllReports?.enter == "1" }
    }
    
    func hasFormsExitFeature() -> Bool {
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return false
        }
        
//        if let dict = formsData.first, let conditions = dict.conditions, let showInAllReports = conditions.showInAllReports, let exit = showInAllReports.exit{
//            if exit == "1"{
//                return true
//            }else{
//                return false
//            }
//        }else{
//            return false
//        }
        
        return formsData.contains { $0.conditions?.showInAllReports?.exit == "1" }
    }
    
    func hasFormsServiceExitFeature() -> Bool {
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return false
        }
        
//        if let dict = formsData.first, let conditions = dict.conditions, let showInAllReports = conditions.showInAllReports, let exitService = showInAllReports.exitService{
//            if exitService == "1"{
//                return true
//            }else{
//                return false
//            }
//        }else{
//            return false
//        }
        
        return formsData.contains { $0.conditions?.showInAllReports?.exitService == "1" }
    }
    
    func hasFormsServiceEntryFeature() -> Bool {
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return false
        }
        
//        if let dict = formsData.first, let conditions = dict.conditions, let showInAllReports = conditions.showInAllReports, let enterService = showInAllReports.enterService{
//            if enterService == "1"{
//                return true
//            }else{
//                return false
//            }
//        }else{
//            return false
//        }
        
        return formsData.contains { $0.conditions?.showInAllReports?.enterService == "1" }
    }
    
    func getFormsURL(type:Int?) -> String? {
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return nil
        }
        
//        if let dict = formsData.first, let url = dict.url, url.count > 0{
//            return url
//        }else{
//            return nil
//        }
        
        switch type {
        case  1 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.enter == "1"
                    }?
                    .url
        case  2 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.exit == "1"
                    }?
                    .url
        case  3 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.enterService == "1"
                    }?
                    .url
        case  4 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.exitService == "1"
                    }?
                    .url
        case .none:
            return nil
        case .some(_):
            return nil
        }
       
       
    }
    
    func getFormName(type: Int?) -> String?{
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return nil
        }
        
//        if let dict = formsData.first, let name = dict.formName, name.count > 0{
//            return name
//        }else{
//            return nil
//        }
        
        switch type{
        case  1 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.enter == "1"
                    }?
                    .formName
        case  2 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.exit == "1"
                    }?
                    .formName
        case  3 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.enterService == "1"
                    }?
                    .formName
        case  4 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.exitService == "1"
                    }?
                    .formName
        case .none:
            return nil
        case .some(_):
            return nil
        }
    }
    
    func hasFormsMandoryBeforeReportFeature(type : Int?) -> Bool {
//        return false
        
        guard let formsData = getFormsData(), !formsData.isEmpty else {
            return false
        }
        
//        if let dict = formsData.first, let conditions = dict.conditions, let mandatoryBeforeReport = conditions.mandatoryBeforeReport{
//            if mandatoryBeforeReport == 1{
//                return true
//            }else{
//                return false
//            }
//        }else{
//            return false
//        }
        
        
        switch type {
        case  1 :
            return formsData.first { form in
                        form.conditions?.showInAllReports?.enter == "1"
                    }?.conditions?.mandatoryBeforeReport == 1
        case  2 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.exit == "1"
                    }?
                .conditions?.mandatoryBeforeReport == 1
        case  3 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.enterService == "1"
                    }?
                .conditions?.mandatoryBeforeReport == 1
        case  4 :
            return formsData
                    .first { form in
                        form.conditions?.showInAllReports?.exitService == "1"
                    }?
                .conditions?.mandatoryBeforeReport == 1
        case .none:
            return false
        case .some(_):
            return false
        }
        
    }
    

    func hasManagerFeature() -> Bool {
        return (currentCompany()?.settings?.managerApp ?? 0) == 1 ? true : false
    }
    
    func hasTaskSearchFeature() -> Bool {
        return (currentCompany()?.settings?.allowTaskSearch ?? 0) == 1
    }
    
    func hasGetHoursLeftFeature() -> Bool {
        return (currentCompany()?.settings?.showLeftHours ?? 0) == 1
    }

    // MARK: - update data
    func setTaskList(tasks: [TaskObj?]) {
        var currentCompany = currentCompany()
        let tasksObject: Tasks = .tasksArray(tasks)
        currentCompany?.taskList = tasksObject
        updateCurrentCompany(currentCompany)

        updateCompaniesInCache()
    }

    func setReportList(reports: [ReportObj?]) {
        var currentCompany = currentCompany()
        currentCompany?.lastReports = reports
        updateCurrentCompany(currentCompany)
        
        updateCompaniesInCache()
    }
    
    func setTestReportList() {
        var currentCompany = currentCompany()
        currentCompany?.isAbsentToday = 1
        updateCurrentCompany(currentCompany)
    }

    func setCurrentClientId(_ clientId: Int?) {
        currentClientId = clientId ?? -1
        UserDefaultsManager.clientId = currentClientId
        UserDefaultsManager.empId = getEmployeeId()
    }

    func setEmploeeEmail(_ email: String) {
        var currentCompany = currentCompany()
        currentCompany?.employeeEmail = email
        updateCurrentCompany(currentCompany)

        updateCompaniesInCache()
    }

    func setTodayWorkingTime(_ time: Int) {
        var currentCompany = currentCompany()
        currentCompany?.todayWorkingTime = time
        updateCurrentCompany(currentCompany)
        
        updateCompaniesInCache()
    }

    func setActiveBreakTime(_ time: Int) {
        var currentCompany = currentCompany()
        currentCompany?.activeBreakTime = time
        updateCurrentCompany(currentCompany)

        updateCompaniesInCache()
    }

    // MARK: - cache companies
    func updateCompaniesInCache() {
        UserDefaultsManager.companiesObj = companies
    }

    func getFromCache() {
        setCompanies(UserDefaultsManager.companiesObj)
    }

    func getEmployer() -> EmployerObj? {
        return  currentCompany()?.employer
    }

    func hasExitEnforcementFeature() -> Bool {
        if currentCompany()?.settings?.exitEnforcement == 1 {
        return true
    }
    return false
    }

    func getAppReportCompletionNoteEntry() -> Int? {
        return currentCompany()?.settings?.appReportCompletionNoteEntry
    }

    func getAppReportCompletionNoteExit() -> Int? {
        return currentCompany()?.settings?.appReportCompletionNoteExit
    }

    func getAppApplyCommentListOnExit() -> Int? {
        return currentCompany()?.settings?.appApplyCommentListOnExit
    }

    func getAppApplyCommentListOnEntry() -> Int? {
        return currentCompany()?.settings?.appApplyCommentListOnEntry
    }

    func getAppCommentListOnExit() -> [Int]? {
        return currentCompany()?.settings?.appCommentListOnExit
    }
    func getAppCommentListOnEntry() -> [Int]? {
        return currentCompany()?.settings?.appCommentListOnEntry
    }

    func getCompletionOnlyToday() -> Int? {
        return currentCompany()?.settings?.completionOnlyToday
    }
    
    func getReportCompletionNote() -> Int? {
        return currentCompany()?.settings?.reportCompletionNote
    }
    
    func getWorkScheduleItems() -> [WorkScheduleObj] {
        return currentCompany()?.dailyWorkSchedule ?? []
    }
    
    func showPatientNotAtHome() -> Bool {
        return currentCompany()?.settings?.appPatientNotAtHome ?? 0 == 1
    }
}

extension CompaniesDataManager {
    
    func isRevacha() -> Bool {
        return currentCompany()?.clientGrpId == 50
    }
    
    func isHolocaustSurvivors() -> Bool {
        return currentCompany()?.clientGrpId == 63
    }

    func isBituachLeumi() -> Bool {
        return currentCompany()?.specialRules == 53
    }
}

private extension CompaniesDataManager {
    
    func currentCompany() -> CompanyObj? {
//        print("currentClientId", currentClientId)
        return (companies ?? []).filter { $0.clientId == currentClientId }.first
    }
    
    func updateCurrentCompany(_ company: CompanyObj?) {
        guard let currentCompany = company else { return }
        var updatedCompanies: [CompanyObj] = [currentCompany]
        for cachaeCompany in companies ?? [] {
            if cachaeCompany.clientId != currentCompany.clientId {
                updatedCompanies.append(cachaeCompany)
            }
        }
        companies = updatedCompanies
    }
}

// MARK: - Current Date
extension CompaniesDataManager {
    
    func getCurrentDate() -> Date? {
        return self.currentDate
    }
    
    private func setupCurrentDateIfRequired() {
        if let dateString = self.currentCompany()?.datenow,
           let date = dateString.getDateFromStringWithFormat("yyyy-MM-dd HH:mm:ss") {
            self.currentDate = date
            
            if let secondsFromBackend = Int(dateString.suffix(2)) {
                let secondsInMinutes = 60
                let pendingSeconds = secondsInMinutes - secondsFromBackend
                
                if pendingSeconds < secondsInMinutes && pendingSeconds > 0 {
                    //Setup timer for pending seconds to complete a minute
                    self.dateWorkItem?.cancel()
                    self.dateWorkItem = DispatchWorkItem(block: { [weak self] in
                        self?.updateCurrentDate()
                        //Start a timer for update time every minute
                        self?.startDateTimer()
                    })
                    self.initialTimerForUpdateUI = pendingSeconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(pendingSeconds), execute: self.dateWorkItem!)
                }else {
                    self.startDateTimer()
                }
            }
        }
    }
    
    private func startDateTimer() {
        dateTimer?.invalidate()
        dateTimer = nil
        dateTimer = Timer.scheduledTimer(withTimeInterval: (1*60), repeats: true) { [weak self] timer in
            self?.updateCurrentDate()
        }
    }
    
    private func updateCurrentDate() {
        if let date = self.currentDate,
           let updatedDate = Calendar.current.date(byAdding: .minute, value: 1, to: date) {
            self.currentDate = updatedDate
            self.updateDateForCurrentCompany()
        }
    }
    
    private func updateDateForCurrentCompany() {
        var companiesList: [CompanyObj] = []
        for company in companies ?? [] {
            if company.clientId == currentClientId {
                var currentCompany = company
                currentCompany.datenow = self.currentDate?.toString(format: "yyyy-MM-dd HH:mm:ss")
                companiesList.append(currentCompany)
                updateCurrentCompany(currentCompany)
            } else {
                companiesList.append(company)
            }
        }
        companies = companiesList
        updateCompaniesInCache()
    }
}
