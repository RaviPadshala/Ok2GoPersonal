//
//  DashboardViewController+NFC.swift
//  clock2go2020
//
//  Created by Mac on 14/03/24.
//

import Foundation
import UIKit

extension DashboardViewController{
    func showNFCPopup(){
        viewModel.getTaskByNFCNew(completionNew: { [weak self] (taskId,uId,lat,long)  in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let lat = lat, let long = long {
                    self.viewModel.latNFC = lat
                    self.viewModel.longNFC = long
                    self.viewModel.tagUID = uId
//                    self.viewModel.tagUID = "1361247236"
                    self.didScanByNFCNew()
                } else {
                    self.viewModel.latNFC = nil
                    self.viewModel.longNFC = nil
                    self.viewModel.tagUID = uId
//                    self.viewModel.tagUID = "1361247236"
                    self.didScanByNFCNew()
                    
                }
            }
            
        })
        
    }
    
    
    func didScanByNFC(taskId: String) {
//        let taskTemp = "121212"
//        if let task = viewModel.taskWithId(taskId) {
//            didFindTaskByNFC(task)
//        } else {
//            didNotFindTaskByNFC()
//        }
        self.handleNFCTaskNew()
    }
    
    func showSuccessDialog(){
        let vc = ViewSource.successView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.isStartTimer = true
        vc.viewModel = SuccessViewModel(message: "NFC_scan_successfully".localized)
        vc.confirmTapped = {
//            self.showConfirmTypeDialog()
//            self.startTimer()
        }
        self.startTimer()
        self.present(vc, animated: true, completion: nil)
    }
    
    func showConfirmTypeDialog(){
        let vc = ViewSource.confirmTaskViewNew()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.message = "Please_select_report_type".localized
        vc.tapConfirm = { type in
            print("type >>>>", type)
            //0 = entry , 1 = exit
            if type == 1 {
                self.viewModel.userDidTapConfirm(type: .logout, task: nil, remark: "", isNFCRead: true)
            } else {
                self.viewModel.userDidTapConfirm(type: .login, task: nil, remark: "", isNFCRead: true)
            }
        }
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }
    
    func didScanByNFCNew() {
        print(" CompaniesDataManager.shared.hasNFCReportAppAutomatically()",  CompaniesDataManager.shared.hasNFCReportAppAutomatically())
        
        self.viewModel.GetNFCData { response in
            if let automatic = response.NFCReportAppAutomaticallyTask{
                self.handleNFCTaskNew()
            }else{
                print("Not automatic")
                delay(durationInSeconds: 1.0) {
                    if let withInterval = response.with_interval, withInterval == 1, let interval = response.interval, interval > 0{
                        self.timerSecond = interval
                    }
                    self.showSuccessDialog()
                }
            }
        }
        
        
//        if CompaniesDataManager.shared.hasNFCReportAppAutomatically(){
//            self.handleNFCTaskNew()
//        }else{
//            delay(durationInSeconds: 2.9) {
//                self.showSuccessDialog()
//            }
//        }
    }
    
    private func didFindTaskByNFC(_ task: TaskObj) {
        
        if viewModel.selectedTask?.taskId != task.taskId && viewModel.selectedTask != nil{
            //let message = String(format: "Please_report_exit_before_tag_scanning".localized, viewModel.selectedTask?.taskId ?? "")
            self.showErrorView(title: nil, message: "Please_report_exit_before_tag_scanning".localized)
            return
        }
        handleNFCProcess(task: task)
        
        //        if isAllNFCFeatureActive(){
        //            viewModel.setSelectedTaskFromNFC(task: task)
        //
        //            self.updateChooseTaskTitle()
        //            self.updateRevachaButtonsTitle()
        //            self.updateMerkavaDistanceSettings()
        //            if  CompaniesDataManager.shared.isLastReportLogin() {
        //                self.viewModel.userDidTapConfirm(type: .logout, task: task, remark: "")
        //            }else{
        //                self.viewModel.userDidTapConfirm(type: .login, task: task, remark: "")
        //            }
        //        }else if CompaniesDataManager.shared.hasNFCReportAppAutomaticallyTaskFeature(){
        //            viewModel.setSelectedTaskFromNFC(task: task)
        //
        //            self.updateChooseTaskTitle()
        //            self.updateRevachaButtonsTitle()
        //            self.updateMerkavaDistanceSettings()
        //            if  CompaniesDataManager.shared.isLastReportLogin() {
        //                self.viewModel.userDidTapConfirm(type: .logout, task: task, remark: "")
        //            }else{
        //                self.viewModel.userDidTapConfirm(type: .login, task: task, remark: "")
        //            }
        //        }
        //        else if CompaniesDataManager.shared.hasNFCReportMandatorySelectTaskTaskFeature(){
        //            viewModel.setSelectedTaskFromNFC(task: task)
        //
        //            self.updateChooseTaskTitle()
        //            self.updateRevachaButtonsTitle()
        //            self.updateMerkavaDistanceSettings()
        //
        //        }else {
        //            viewModel.setSelectedTaskFromNFC(task: task)
        //
        //            self.updateChooseTaskTitle()
        //            self.updateRevachaButtonsTitle()
        //            self.updateMerkavaDistanceSettings()
        //           // self.shouldRefreshView()
        //        }
        
        
    }
    
    func handleNFCTask(task: TaskObj) {
        viewModel.setSelectedTaskFromNFC(task: task)
        updateUI()
        
        if CompaniesDataManager.shared.isLastReportLogin() {
            viewModel.userDidTapConfirm(type: .logout, task: task, remark: "", isNFCRead: true)
        } else {
            viewModel.userDidTapConfirm(type: .login, task: task, remark: "", isNFCRead: true)
        }
    }
    
    func handleNFCTaskNew(){
        if CompaniesDataManager.shared.isLastReportLogin() {
            viewModel.userDidTapConfirm(type: .logout, task: nil, remark: "", isNFCRead: true)
        } else {
            viewModel.userDidTapConfirm(type: .login, task: nil, remark: "", isNFCRead: true)
        }
    }
    
    func updateUI() {
        self.updateChooseTaskTitle()
        self.updateRevachaButtonsTitle()
        self.updateMerkavaDistanceSettings()
    }
    
    func handleNFCProcess(task: TaskObj) {
//        handleNFCTask(task: task)
        if isAllNFCFeatureActive(){
            handleNFCTask(task: task)
        }
        //          else if CompaniesDataManager.shared.hasNFCReportMandatorySelectTaskTaskFeature() {
        //            viewModel.setSelectedTaskFromNFC(task: task)
        //            updateUI()
        //        }
        else {
            viewModel.setSelectedTaskFromNFC(task: task)
            updateUI()
            // Optionally handle other actions if needed, e.g., self.shouldRefreshView()
        }
    }
    
    private func isAllNFCFeatureActive()-> Bool{
        if CompaniesDataManager.shared.hasNFCReportMandatoryThroughNFCScanFeature(){
            return true
        }
        return false
    }
    
    private func didNotFindTaskByNFC() {
        self.showErrorView(title: nil, message: "You_are_not_authorized_to_report_on_this_task_please_contact_the_person_in_charge_in_your_organization".localized)
        
    }
}
