//
//  SideBarViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/10/20.
//

import UIKit

enum SideBarType {
    case regular
    case manager
}

class SideBarViewModel: NSObject {

    var type: SideBarType
    let cellHeight: CGFloat = 40

    init(type: SideBarType) {
        self.type = type
    }

    func getNumberOfSections() -> Int {
        return SideBarSection.allCases.count
    }

    func getNumbersOfRowsInSection(section: Int) -> Int {
        let sectionType = SideBarSection(rawValue: section)

        switch sectionType {
            case .Action:
                return ActionRow.allCases.count
            case .Settings:
                return SettingRow.allCases.count
            case .none:
                return 0
        }
    }
    func getModelForCellAt(indexPath: IndexPath) -> SideBarCellViewModel? {
        let sectionType = SideBarSection(rawValue: indexPath.section)

        switch sectionType {
            case .Action:
            let row = ActionRow(rawValue: indexPath.row)
                return SideBarCellViewModel(image: row?.icon, title: row?.title, additionalView: row?.additionalView)
            case .Settings:
                let row = SettingRow(rawValue: indexPath.row)
                return SideBarCellViewModel(image: row?.icon, title: row?.title, additionalView: row?.additionalView)
            case .none:
                return nil
        }
    }

    func getViewControllerForCellAt(indexPath: IndexPath) -> UIViewController? {
        guard let section = SideBarSection(rawValue: indexPath.section) else { return nil }

        switch section {
            case .Action:
                guard let row = ActionRow(rawValue: indexPath.row) else { return nil }
                return row.vc
            case .Settings:
                guard let row = SettingRow(rawValue: indexPath.row) else { return nil }
                return row.vc
        }
    }

    func getHeightOfCellAt(indexPath: IndexPath) -> CGFloat {
        guard let sectionType = SideBarSection(rawValue: indexPath.section) else { return 0 }

        switch sectionType {
        case .Action:
            let row = ActionRow(rawValue: indexPath.row)
            switch row {
            case .regularApp:
                return type == .manager ? cellHeight : 0
            case .managerApp:
                return type == .regular && CompaniesDataManager.shared.hasManagerFeature()  ? cellHeight : 0
            case .weeklySchedule:
                if CompaniesDataManager.shared.isHolocaustSurvivors(){
                    return 0.0
                }
                return CompaniesDataManager.shared.hasWorkScheduleFeature() ? cellHeight : 0.0
            case .forms:
                return CompaniesDataManager.shared.hasFormsFeature() ? cellHeight : 0.0
            case .createCard:
                return 0.0//CompaniesDataManager.shared.hasNFCReportsFeature() ? cellHeight : 0.0
            default:
                return cellHeight
            }
        case .Settings:
            return cellHeight
        }
    }

    func getSelectedBackgroundView() -> UIView {
        let customColorView = UIView()
        customColorView.backgroundColor = UIColor.init().hexStringToUIColor(hex: "#E4EDFA")
        return customColorView
    }

    func getTitleForSection(section: Int) -> String? {
        return SideBarSection.init(rawValue: section)?.titleSection
    }

}
