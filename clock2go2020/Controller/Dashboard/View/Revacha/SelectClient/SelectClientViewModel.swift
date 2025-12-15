//
//  SelectClientViewModel.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 14.08.2020.
//

import UIKit

class SelectClientViewModel {
    
    var selectedImage = UIImage(named: "checked_terms")
    var unselectedImage = UIImage(named: "unchecked_terms")
   
    var type: SelectClientType = .treatment
    
    let userDefaults = UserDefaults.standard
        
    var isLastReportLogin: Bool {
      guard let report = CompaniesDataManager.shared.getLastLoginReport() else { return false }
        
        if let task = report.taskName, task != "" {
            return true
        }
        
        return CompaniesDataManager.shared.shouldReportTask() || CompaniesDataManager.shared.mustReportPairs()
    }
    
    
    var needRoundCorners: Bool {
        return !CompaniesDataManager.shared.hasBarcodeReportsFeature()
    }
    
    init() {
        if CompaniesDataManager.shared.isRevacha(){
            self.type = .treatment
        }else{
            self.type = .officeTreatment
        }
    }
    
    func getTrainingImage() -> UIImage? {
        return type == .training ? selectedImage : unselectedImage
    }
    
    func getGroupTrainingImage() -> UIImage? {
        return type == .generalTraining ? selectedImage : unselectedImage
    }
    
    func getTreatmentImage() -> UIImage? {
        return type == .treatment ? selectedImage : unselectedImage
    }
    
    func getOfficeTreatmentImage() -> UIImage? {
        return type == .officeTreatment ? selectedImage : unselectedImage
    }
    
    func getOnSiteTreatmentImage() -> UIImage? {
        return type == .onSiteTreatment ? selectedImage : unselectedImage
    }
    
    func getGroupTreatmentImage() -> UIImage? {
        return type == .groupTreatment ? selectedImage : unselectedImage
    }
    
    func shouldDisableLoginView() -> Bool {
        return !isLastReportLogin || !CompaniesDataManager.shared.hasAppPermission()
    }
    
    func getTheraphyTitle() -> String {
        
        if isLastReportLogin && (DashboardViewModel().selectedTask != nil || DashboardViewModel().lastloginTask != nil || DashboardViewModel().unknownTask != nil){
            
            print("<<<<<< Task selecred >>>>\n")
            
            if DashboardViewModel().selectedTask != nil {
                UserDefaultsManager.holocustLastLoginType = DashboardViewModel().selectedTask!.trnstypeid ?? 1
            }else if DashboardViewModel().lastloginTask != nil {
                UserDefaultsManager.holocustLastLoginType = DashboardViewModel().lastloginTask!.trnstypeid ?? 1
            }else if DashboardViewModel().unknownTask != nil {
                UserDefaultsManager.holocustLastLoginType = DashboardViewModel().unknownTask!.trnstypeid ?? 1
            }
            
            if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
                let arr = CompaniesDataManager.shared.getTherapyeventTypes()
                let filteredUsers = arr.filter({ $0?.TransType == "\(UserDefaultsManager.holocustLastLoginType - 3)" })
                
                if filteredUsers.contains(where: { $0?.TherapyType == "\(UserDefaultsManager.holocustLastTheraphyType)" }) {
                    if UserDefaultsManager.holocustLastTheraphyType == 1 {
                        return "Medical".localized
                    }
                    
                    if UserDefaultsManager.holocustLastTheraphyType == 2 {
                        return "Group".localized
                    }
                    
                    if UserDefaultsManager.holocustLastTheraphyType == 3 {
                        return "Projective".localized
                    }
                    
                    if UserDefaultsManager.holocustLastTheraphyType == 4 {
                        return "Individual".localized
                    }
                    
                }
            }
        }else{
            print("<<<<<< Task selecred not >>>>\n")
        }
        
        
        if UserDefaultsManager.holocustLastTheraphyType == 0 {
            return "Select_Therapy".localized
        }else{
            if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
                let arr = CompaniesDataManager.shared.getTherapyeventTypes()
                let filteredUsers = arr.filter({ $0?.TransType == "\(UserDefaultsManager.holocustLastLoginType - 3)" })
                
                if filteredUsers.contains(where: { $0?.TherapyType == "\(UserDefaultsManager.holocustLastTheraphyType)" }) {
                    if UserDefaultsManager.holocustLastTheraphyType == 1 {
                        return "Medical".localized
                    }
                    
                    if UserDefaultsManager.holocustLastTheraphyType == 2 {
                        return "Group".localized
                    }
                    
                    if UserDefaultsManager.holocustLastTheraphyType == 3 {
                        return "Projective".localized
                    }
                    
                    if UserDefaultsManager.holocustLastTheraphyType == 4 {
                        return "Individual".localized
                    }
                    
                }
            }
        }
        return "Select_Therapy".localized
    }
    
    func getOnlineOptionEnable() -> Bool {
        if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
            let arr = CompaniesDataManager.shared.getTherapyeventTypes()
            let filteredUsers = arr.filter({ $0?.TransType == "2" })
            if filteredUsers.count > 0 {
                return true
            }
        }
        return false
    }
    
    func getOnSiteOptionEnable() -> Bool {
        if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
            let arr = CompaniesDataManager.shared.getTherapyeventTypes()
            let filteredUsers = arr.filter({ $0?.TransType == "1" })
            if filteredUsers.count > 0 {
                return true
            }
        }
        return false
    }
    
    func getOfficeOptionEnable() -> Bool {
        if CompaniesDataManager.shared.getTherapyeventTypes().count > 0{
            let arr = CompaniesDataManager.shared.getTherapyeventTypes()
            let filteredUsers = arr.filter({ $0?.TransType == "3" })
            if filteredUsers.count > 0 {
                return true
            }
        }
        return false
    }
}
