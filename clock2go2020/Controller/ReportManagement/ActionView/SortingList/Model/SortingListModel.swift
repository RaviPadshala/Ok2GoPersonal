//
//  SortingListModel.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/19/20.
//

import UIKit

enum SortingListType {
    case filter
    case month
    case mgrFilter
    case shlomitMonth
    case revacha
    case holocust
    case revachaClient
    case revachaEvent
    case holocustTherapy
    case holocustEvent
    
    var numberOfRows: Int {
        switch self {
        case .filter:
            return SortingBy.allCases.count
        case .month:
            StatisticsViewModel.shared.refreshData()
            return StatisticsViewModel.shared.monthKeys?.count ?? 6
        case .mgrFilter:
            return SortingStatusMonth.allCases.count
        case .shlomitMonth:
            StatisticsViewModel.shared.refreshData()
            return StatisticsViewModel.shared.monthKeys?.count ?? 12
        case .revacha, .holocust:
            return 3
        case .holocustTherapy:
            return 4
        case .revachaClient:
            return TaskListViewModel().taskListItems.count
        case .revachaEvent:
            return CompaniesDataManager.shared.getEvents()?.count ?? 0
        case .holocustEvent:
            return TaskListViewModel().taskListItems.count
        }
    }
    
    var image: UIImage? {
        switch self {
        case .filter:
            return UIImage(named: "funnel")
        case .month:
            return UIImage(named: "calendar18")
        case .mgrFilter:
            return UIImage(named: "funnel")
        case .shlomitMonth:
            return UIImage(named: "calendar18")
        case .revacha, .revachaClient, .revachaEvent, .holocust, .holocustTherapy, .holocustEvent:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .filter:
            return "VIEW_BY_TITLE".localized
        case .month:
            return "בחר חודש"
        case .mgrFilter:
            return "VIEW_BY_TITLE".localized
        case .shlomitMonth:
            return "בחר חודש"
        case .revacha, .holocust:
            return "TRNS_TYPE".localized
        case .revachaClient:
            return "CLIENT".localized
        case .revachaEvent:
            return "EVENTS".localized
        case .holocustTherapy:
            return "Select_Therapy".localized
        case .holocustEvent:
            return "SELECT_CLIENT".localized
        }
    }
    
    var shouldShowHeader: Bool {
        switch self {
        case .filter, .mgrFilter, .revacha, .revachaClient, .revachaEvent, .holocustTherapy, .holocustEvent:
            return true
        case .month, .shlomitMonth, .holocust:
            return false
        }
    }
    
    func getCellTitleByIndex(index: Int) -> String {
        switch self {
        case .filter:
            return SortingBy.init(rawValue: index)?.title ?? ""
        case .month:
            return getMonthStringAt(index: index)
        case .mgrFilter:
            return SortingStatusMonth.init(rawValue: index)?.title ?? ""
        case .shlomitMonth:
            return getMonthStringAt(index: index)
        case .revacha:
            return RevachaTrnsType.init(rawValue: index)?.title ?? ""
        case .holocust:
            return HolocustTrnsType.init(rawValue: index)?.title ?? ""
        case .holocustTherapy:
            return HolocustTherapyTrnsType.init(rawValue: index)?.title ?? ""
        case .revachaClient:
            return TaskListViewModel().taskListItems[index].task.taskName
        case .revachaEvent:
            return CompaniesDataManager.shared.getEvents()?[index].eventName ?? ""
        case .holocustEvent:
            return TaskListViewModel().taskListItems[index].task.taskName
        }
    }
    
    func getMonthStringAt(index: Int) -> String {
        let monthIndex = getMonthIndexAt(index: index)
        return Calendar.getMonthLocalizedStringFor(index: monthIndex)
    }
    
    func getMonthIndexAt(index: Int) -> Int {
        let date = Calendar.current.date(byAdding: .month, value: -index, to: Date()) ?? Date()
        let month = Calendar.current.component(.month, from: date) - 1
        return month
    }
    
    func getCellHeightByIndex(index: Int) -> CGFloat {
        switch self {
        case .filter:
            return SortingBy.init(rawValue: index)?.cellHeight ?? 30
        case .mgrFilter:
            return SortingStatusMonth.init(rawValue: index)?.cellHeight ?? 30
        case .month, .shlomitMonth, .revacha, .revachaClient, .revachaEvent, .holocust, .holocustTherapy, .holocustEvent:
            return 30
        }
    }
    
}

enum SortingBy: Int, CaseIterable {
    
    case missings
    case absences
    case breaks
    case standards
    case noReport
    case allReports
    
    var title: String {
        switch self {
        case .missings:
            return "MISSING_TITLE".localized
        case .absences:
            return "ABSENCE_TITLE".localized
        case .breaks:
            return "BREAKS_TITLE".localized
        case .standards:
            return "STANDARDS_TITLE".localized
        case .noReport:
            return "NOREPORT_TITLE".localized
        case .allReports:
            return "SHOW_ALL_TITLE".localized
        }
    }
    
    var type: Int {
        switch self {
        case .missings:
            return 5
        case .absences:
            return 3
        case .breaks:
            return 6
        case .standards:
            return 4
        case .noReport:
            return 7
        case .allReports:
            return 1
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .standards:
            return CompaniesDataManager.shared.hadStandardWorkTime() ? 30 : 0
        default:
            return 30
        }
    }
    
    static func withTitle(_ title: String) -> SortingBy? {
        return self.allCases.first { $0.title == title }
    }
}

enum RevachaTrnsType: Int, CaseIterable {
    case treatment
    case training
    case generalTraining
    
    var title: String {
        switch self {
        case .treatment:
            return "TREATMENT".localized
        case .training:
            return "EVENT_TRAINING".localized
        case .generalTraining:
            return "GENERAL_TRAINING".localized
        }
    }
}

enum HolocustTrnsType: Int, CaseIterable {
    case office
    case onSite
    case online
    
    var title: String {
        switch self {
        case .office:
            return "Clinic_treatment".localized
        case .onSite:
            return "On_site_treatment".localized
        case .online:
            return "Online".localized
        }
    }
}

enum HolocustTherapyTrnsType: Int, CaseIterable {
    case Medical
    case Group
    case Projective
    case Individual
    
    
    var title: String {
        switch self {
        case .Medical:
            return "Medical".localized
        case .Group:
            return "Group".localized
        case .Projective:
            return "Projective".localized
        case .Individual:
            return "Individual".localized
        }
    }
}

enum SortingStatusMonth: Int, CaseIterable {
    case openMonth
    case closedMonth
    case approveMonth
    case showAll
    
    var title: String {
        switch self {
        case .openMonth:
            return "OPEN_MONTH_STATUS".localized
        case .closedMonth:
            return "CLOSE_MONTH_STATUS".localized
        case .approveMonth:
            return "APPROVE_MONTH_STATUS".localized
        case .showAll:
            return "ALL_MONTH_STATUS".localized
        }
    }
    
    var type: Int? {
        switch self {
        case .openMonth:
            return 1
        case .closedMonth:
            return 2
        case .approveMonth:
            return 3
        case .showAll:
            return nil
            
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        default:
            return 30
        }
    }
    
    static func withTitle(_ title: String) -> SortingStatusMonth? {
        return self.allCases.first { $0.title == title }
    }
}
