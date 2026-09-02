//
//  AdditionalButtonsViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/10/20.
//

import UIKit
import CoreLocation

struct ExtendedListReportModel {
    let type: ConfirmActionType
    let task: TaskObj?
    let actionType: ReportActionType
    let remark: String?
    let event: RevachaEventObj?
}


class AdditionalButtonsViewModel: NSObject {

    weak var delegate: AdditionalButtonsViewModelDelegate?
    var addonButtons: AddonButtonsObj?

    
    private(set) var button1String: String = ""
    private(set) var button2String: String = ""
    private(set) var button3String: String = ""
    private(set) var button4String: String = ""
    private(set) var button5String: String = ""
    private(set) var button6String: String = ""
    private var isSpecialClientDoctor: Bool {
        return CompaniesDataManager.shared.getSpecialClientType() == 1 || CompaniesDataManager.shared.getSpecialClientType() == 2
    }
    
    private var isBituachLeumiClient: Bool {
        return CompaniesDataManager.shared.isBituachLeumi()
    }
    
    private var shouldReportWithTask: Bool {
        return CompaniesDataManager.shared.shouldReportTask()
    }
    
    private var locationNames: [LocationNameObj] {
        return CompaniesDataManager.shared.getLocationMames() ?? []
    }

    var selectedTask: TaskObj?
    
    func shouldRefresh(){
        let additionalButtons = CompaniesDataManager.shared.getAddonButtons()
        
        
        button1String = (additionalButtons?.button_1?.text ?? "").localized
        button2String = (additionalButtons?.button_2?.text ?? "").localized
        button3String = (additionalButtons?.button_3?.text ?? "").localized
        button4String = (additionalButtons?.button_4?.text ?? "").localized
        button5String = (additionalButtons?.button_5?.text ?? "").localized
        button6String = (additionalButtons?.button_6?.text ?? "").localized
    }
    func loadButtons() {
        addonButtons = CompaniesDataManager.shared.getAddonButtons()
    }

    func getButton1Title() -> String? {
        return (addonButtons?.button_1?.text ?? "").localized
    }

    func getButton2Title() -> String? {
        return (addonButtons?.button_2?.text ?? "").localized
    }

    func getButton3Title() -> String? {
        return (addonButtons?.button_3?.text ?? "").localized
    }

    func getButton4Title() -> String? {
        return (addonButtons?.button_4?.text ?? "").localized
    }
    
    func getButton5Title() -> String? {
        return (addonButtons?.button_5?.text ?? "").localized
    }
    
    func getButton6Title() -> String? {
        return (addonButtons?.button_6?.text ?? "").localized
    }

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    func firstButtonTapped() {
        if isSpecialClientDoctor {
            guard let type = addonButtons?.button_1?.action_type else { return }
            sendReport(type: type)
        } else if isBituachLeumiClient {
            if needShowChooseTaskError() {
                self.showErrorView(title: "421", message: "421".localized)
            } else {
                showRegularConfirm(additionalButton: addonButtons?.button_1, confirmType: .loginConfirm)
            }
        } else {
            showConfirmView(aditionalButton: addonButtons?.button_1)
        }
    }

    func secondButtonTapped() {
        if isSpecialClientDoctor {
            guard let type = addonButtons?.button_2?.action_type else { return }
            sendReport(type: type)
        } else if isBituachLeumiClient {
            if needShowChooseTaskError() {
                self.showErrorView(title: "421", message: "421".localized)
            } else {
                showRegularConfirm(additionalButton: addonButtons?.button_2, confirmType: .logoutConfirm)
            }
        } else {
            showConfirmView(aditionalButton: addonButtons?.button_2)
        }
    }

    func thirdButtonTapped() {
        if isSpecialClientDoctor {
            guard let type = addonButtons?.button_3?.action_type else { return }
            sendReport(type: type)
        } else if isBituachLeumiClient {

        } else {
            showConfirmView(aditionalButton: addonButtons?.button_3)
        }
    }

    func fourthButtonTapped() {
        if isSpecialClientDoctor {
            guard let type = addonButtons?.button_4?.action_type else { return }
            sendReport(type: type)
        } else {
            showConfirmView(aditionalButton: addonButtons?.button_4)
        }
    }
    
    func fixthButtonTapped() {
        if isSpecialClientDoctor {
            guard let type = addonButtons?.button_5?.action_type else { return }
            sendReport(type: type)
        } else if isBituachLeumiClient {
            if needShowChooseTaskError() {
                self.showErrorView(title: "421", message: "421".localized)
            } else {
                showRegularConfirm(additionalButton: addonButtons?.button_5, confirmType: .logoutConfirm)
            }
        } else {
            showConfirmView(aditionalButton: addonButtons?.button_5)
        }
    }
    
    func sixthButtonTapped() {
        if isSpecialClientDoctor {
            guard let type = addonButtons?.button_6?.action_type else { return }
            sendReport(type: type)
        } else if isBituachLeumiClient {
            if needShowChooseTaskError() {
                self.showErrorView(title: "421", message: "421".localized)
            } else {
                showRegularConfirm(additionalButton: addonButtons?.button_6, confirmType: .logoutConfirm)
            }
        } else {
            showConfirmView(aditionalButton: addonButtons?.button_6)
        }
    }

    func getColorthirdButton() -> UIColor? {
           if isSpecialClientDoctor {
                return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
        }
        return nil
    }

    func getColortFourthButton() -> UIColor? {
       if isSpecialClientDoctor {
                return #colorLiteral(red: 0.9756608605, green: 0.3157561719, blue: 0.3174736798, alpha: 1)
        }
        return nil
    }

    func shouldShowSecondLayer() -> Bool {
        return addonButtons?.button_3 != nil || addonButtons?.button_4 != nil
    }
    
    func shouldShowThirdLayer() -> Bool {
        return addonButtons?.button_5 != nil || addonButtons?.button_6 != nil
    }

    func showConfirmView(aditionalButton: AddonButtonObj?) {
        guard let aditionalButton = aditionalButton else { return }

        let vc = ViewSource.confirmTaskView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.setViewModel(ConfirmTaskViewModel(confirmType: .additionalConfirm, additional: aditionalButton))
        vc.delegate = self

        NavigationController.shared?.present(vc, animated: true, completion: nil)
//        print("additionalButton", aditionalButton)
    }

    func showRegularConfirm(additionalButton: AddonButtonObj?, confirmType: ConfirmViewType) {
        guard let additionalButton = additionalButton else { return }

        let vc = ViewSource.confirmTaskView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        let viewModel = ConfirmTaskViewModel(confirmType: confirmType, task: selectedTask, unknownTask: nil, absence: nil, additional: additionalButton, event: nil)
        vc.setViewModel(viewModel)
        vc.delegate = self

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
    
    func showSuccessView() {
        let vc = ViewSource.confirmTaskView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        vc.setViewModel(ConfirmTaskViewModel(confirmType: .additionalSuccess))

        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
    var shouldReportLocation: Bool {
        if CompaniesDataManager.shared.shouldReportWithoutPosition(){
            return false
        }else if CompaniesDataManager.shared.mustReportPosition(){
            return true
        }
        return true
    }
    // api call
    func sendReport(type: Int, remark: String? = nil, actionType: Int? = nil) {
       // guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }

        vc?.view.addSubview(loadingView)
        
        var lat : CLLocationDegrees?
        var lon : CLLocationDegrees?
        
        
        
        if (shouldReportLocation){
            let location = LocationManager.shared.getCurrentLocation()
            let longitude = location?.coordinate.longitude
            let latitude = location?.coordinate.latitude
            lat = latitude
            lon = longitude
        }
        
        let accuracy = 16

        let report = WriteReportEndpoint(type: type, lat: lat, lon: lon, accuracy: accuracy, remark: remark, actionType: actionType)
        report.apiCall { (result, error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                CompaniesDataManager.shared.setReportList(reports: result?.data ?? [])
                self.delegate?.shouldRefreshView()
                self.showSuccessView()
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }
    
    func sendRegularReport(type: ConfirmActionType, task: TaskObj?, actionType: ReportActionType, remark: String?, locationId: Int?) {
        guard !(!ReachabilityManager.shared.hasInternetConnection && (actionType == .workStart || actionType == .workEnd || actionType == .endAndStartWork)) else {
            saveReportOffline(type: actionType, task: task, remark: remark)
            return
        }
        
        //guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        var lat : CLLocationDegrees?
          var lon : CLLocationDegrees?
        if shouldReportLocation{
              let location = LocationManager.shared.getCurrentLocation()
              
              let longitude = location?.coordinate.longitude
              let latitude = location?.coordinate.latitude
              lat = latitude
              lon = longitude
          }else{
              
          }
        
//        let location = LocationManager.shared.getCurrentLocation()
//        let lon = location?.coordinate.longitude
//        let lat = location?.coordinate.latitude
        let accuracy = 16
        
        var extraFields: [String : Any] = [:]
        if let locationId = locationId {
            extraFields["locationName"] = locationId
        }
       

        let reportEndpoint = ReportEndpoint(endpointType: .report, type: actionType, taskId: task?.taskId ?? "", taskName: task?.taskName ?? "", remark: remark, lat: lat, lon: lon, accuracy: accuracy, tagUID: "", extraFields: extraFields)
        reportEndpoint.apiCall { response, error in
            if error?.success ?? false {
                CompaniesDataManager.shared.setReportList(reports: response?.data ?? [])
                self.delegate?.shouldRefreshView()
                self.showSuccessView()
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

    private func saveReportOffline(type: ReportActionType, task: TaskObj?, remark: String?) {
        OfflineRequestsManager.sharedInstance.save(type: type.rawValue, taskId: task?.taskId, taskName: task?.taskName, remark: remark, locationName: nil)
        NavigationController.shared?.showSuccessView(message: "OFFLINE_MODE_REPORT_SAVED".localized)
    }

    private func showErrorView(title: String?, message: String?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: title, message: message)
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
    
    private func showLocationNamesListView(_ model: ExtendedListReportModel) {
        let listView = ViewSource.extendedListView()
        listView.modalPresentationStyle = .overCurrentContext
        listView.modalTransitionStyle = .crossDissolve
        
        let viewModel = ExtendedListViewModel(type: .locationName, models: locationNames, parameters: model)
        listView.viewModel = viewModel
        listView.delegate = self
        NavigationController.shared?.present(listView, animated: true)

    }
    
    private func needShowChooseTaskError() -> Bool {
        return shouldReportWithTask && selectedTask == nil
    }
}

extension AdditionalButtonsViewModel: ExtendedListViewDelegate {
    
    func didSelectItem(type: ExtendedListContentType, itemId: Int?, parameters: Any?) {
        guard let locationId = itemId, let model = parameters as? ExtendedListReportModel else { return }
        sendRegularReport(type: model.type, task: model.task, actionType: model.actionType, remark: model.remark, locationId: locationId)
    }
}

extension AdditionalButtonsViewModel: TaskConfirmViewDelegate {
    func userDidTapConfirm(_ type: ConfirmActionType, _ task: TaskObj?, _ aditionalButton: AddonButtonObj?, _ remark: String?, _ event: RevachaEventObj?) {
        if type == .additional, let actionType = aditionalButton?.action_type {
            sendReport(type: actionType, remark: remark)
        } else if isBituachLeumiClient, let actionType = ReportActionType(rawValue: "\(aditionalButton?.action_type ?? -1)") {
            let model = ExtendedListReportModel(type: type, task: task, actionType: actionType, remark: remark, event: event)
            showLocationNamesListView(model)
        }
    }
}

protocol AdditionalButtonsViewModelDelegate: NSObjectProtocol {
    func shouldRefreshView()
}
