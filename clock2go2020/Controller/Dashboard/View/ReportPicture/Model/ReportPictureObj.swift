//
//  ReportPictureObj.swift
//  clock2go2020
//
//  Created by Gleb on 06.08.2020.
//

import UIKit

enum PictureReportType: String {
    case login = "1"
    case logout = "2"
    case logoutAndLogin = "901"

    var confirmType: ConfirmViewType {
        switch self {
            case .login:
                return .loginSuccess
            case .logout:
                return .logoutSuccess
            case .logoutAndLogin:
                return .loginSuccess
        }
    }

    var reportActionType: ReportActionType {
        switch self {
            case .login:
                return .workStart
            case .logout:
                return .workEnd
            case .logoutAndLogin:
                return .endAndStartWork
        }
    }
}

class ReportPictureObj {
    var reportType: PictureReportType
    var attachedFiles: [MediaObj]
    var remark: String?
    var task: TaskObj?

    init(reportType: PictureReportType = .login, attachedFiles: [MediaObj] = [], remark: String? = nil, task: TaskObj? = nil) {
        self.reportType = reportType
        self.attachedFiles = attachedFiles
        self.remark = remark
        self.task = task

    }

    func getReportTitle() -> String {
        let mustPictureText = CompaniesDataManager.shared.getReportWithPictureText()

        var title = ""

        switch reportType {
            case .login, .logoutAndLogin:
                if let taskTitle = getTaskTitle() {
                    title = "PICTURE_REPORT_TASK_LOGIN".localized + taskTitle + " "
                } else {
                    title = "PICTURE_REPORT_LOGIN".localized
                }
                title += mustPictureText
            case .logout:
                title = "PICTURE_REPORT_LOGOUT".localized + mustPictureText
        }

        return title
    }

    func getTaskTitle() -> String? {
        if task == nil {
            return nil
        } else {
            var taskTitle = [String]()

            if let project = task?.projectName {
                taskTitle.append(project)
            }

            if let name = task?.taskName {
                taskTitle.append(name)
            }

            return taskTitle.count > 0 ? taskTitle.joined(separator: "/") : nil
        }
    }

    func getBackgroundColor() -> UIColor? {
        switch reportType {
            case .login, .logoutAndLogin:
                return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
            case .logout:
                return #colorLiteral(red: 0.9756608605, green: 0.3157561719, blue: 0.3174736798, alpha: 1)
        }
    }
}
