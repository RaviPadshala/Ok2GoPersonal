//
//  EndpointItemType.swift
//  clock2go2020
//
//  Created by Admin on 1/28/20.
//

import Alamofire

// MARK: - EndPointType
protocol EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    
}

// MARK: - EndPointItem
enum EndpointItemType: String {
    
    // MARK: User actions
    case register               = "register"
    case verifyCode             = "verify_code"
    case getCompanies           = "get_companies"
    case write                  = "write"
    case report                 = "write_report"
    case pictureReport          = "write_picture_report"
    case reportAbsence          = "write_absence"
    case reportTracking         = "write_tracking"
    case writeShlomitReport     = "write_shlomit_signed_report"
    case getTracking            = "get_tracking"
    case addTask                = "add_task"
    case addProjectTask         = "add_project_task"
    case updateInfo             = "update_info"
    case getEmpReports          = "get_emp_reports"
    case getEmpMonthlyStat      = "get_emp_monthly_stats"
    case updateEmpRep           = "update_emp_report"
    case deleteEmpRep           = "delete_emp_report"
    case closeMonth             = "close_month"
    case sendEmail              = "send_email"
    case getAbsencePics         = "get_absence_pictures"
    case deleteAbsencePic       = "delete_absence_picture"
    case addRide                = "add_ride"
    case writeDistance          = "write_distance"
    case acceptTrackDisclaimer  = "accept_track_disclaimer"
    case showHealthDisclaimer   = "show_health_disclaimer"
    case acceptHealthDisclaimer = "accept_health_disclaimer"
    case getExitEnforcement     = "get_exit_enforcement"
    case checkTaskGeolocation   = "check_task_geolocation"
    case getRevachaEventTypes   = "get_revacha_event_types"
    case getPatientLeftHours    = "get_patient_left_hours"
    case getDisclaimer          = "get_disclaimer"
    case patientNotAtHome       = "patient_notathome"
    case setStudentAction       = "set_student_data"
    case getNFC                 = "get_nfc"
    
    // MARK: Manager actions
    case managerAppLogin        = "manager_app_login"
    case getDailyStats          = "get_daily_stats"
    case getDailyStatsDetails   = "get_daily_stats_details"
    case getMonthStats          = "get_monthly_stats"
    case getMonthStatsDetails   = "get_monthly_stats_details"
    case getDepartments         = "get_departments"
    case getEmployees           = "get_employees"
    case getEmployee            = "get_employee"
    case addEmployee            = "add_employee"
    case updateEmployee         = "update_employee"
    case getTasks               = "get_tasks"
    case addCompTask            = "add_comp_task"
    case updateTask             = "update_task"
    case getProjects            = "get_projects"
    case addProject             = "add_project"
    case updateProject          = "update_project"
    case getMgrReports          = "get_mgr_reports"
    case addMgrReport           = "add_mgr_report"
    case updateMgrReports       = "update_mgr_report"
    case deleteMgrReport        = "delete_mgr_report"
    case setReportStatus        = "set_report_status"
    case getMonthSummary        = "get_month_summary"
    case setMonthStatus         = "set_month_status"
    case getAmutaSignedReport   = "get_amuta_signed_report"
    case getPolygons            = "get_polygons"
    case getGeolocations        = "get_geolocations"
    case getDistances           = "get_distances"
    case setAbsenceStatus       = "set_absence_status"
    case getMgrEmpReports       = "get_mgr_emp_reports"
    case sendMgrEmail           = "send_mgr_email"
    case setAppStatus           = "app_status"
    case echoAction             = "echo"
    case getWorkSchedule        = "get_work_schedule"
    case searchTask             = "search_task"
    
    // Approved Hours
    case sentHoursApproved = "sent_hours_approved"
}

// MARK: - Extensions
extension EndpointItemType: EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String {
        switch APIManager.networkEnviroment {
        case .production:    return "https://clock2go2020.com/app2020/v1/"
        case .test:          return "https://clock2go2020.com/app2020/test/"
        case .timeout:       return "http://example.com:81"
        case .revacha:       return "https://clock2go2020.com/app2020/reva/"
        case .production_v2: return "https://clock2go2020.com/app2020/v2/"
        case .vtest:         return "https://clock2go2020.com/app2020/vtest/"
        case .verotest:         return "https://clock2go2020.com/app2020/verotest/"
        case .production_v3: return "https://clock2go2020.com/app2020/v3/"
        case .production_v3_01: return "https://clock2go2020.com/app2020/v3_01/"
        case .production_v3_25: return "https://clock2go2020.com/app2020/v3_25/"
        case .production_v3_25_03: return "https://clock2go2020.com/app2020/v3_25_03/"
        case .production_V3_25_04: return "https://clock2go2020.com/app2020/v3_25_04/"
        case .production_app_01_25_10: return "https://clock2go2020.com/app2020/app_01_25_10/"
        case .production_app_01_25_11: return "https://clock2go2020.com/app2020/app_01_25_11/"
        case .production_app_01_25_12: return "https://clock2go2020.com/app2020/app_01_25_12/"
        case .production_app_01_25_14: return "https://clock2go2020.com/app2020/app_01_25_14/"
        case .production_app_01_25_15: return "https://clock2go2020.com/app2020/app_01_25_15/"
        case .production_app_01_25_16: return "https://clock2go2020.com/app2020/app_01_25_16/"
        case .sandbox :      return "https://clock2go2020.com/app2020/sandboxtest/"
        }
    }
    
    var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .reportAbsence, .pictureReport:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
}
