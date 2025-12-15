//
//  ConfirmTaskViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/21/20.
//

import UIKit

enum ConfirmViewType: Int {
    case loginConfirm
    case loginSuccess
    case logoutConfirm
    case logoutSuccess
    case logoutMustNote
    case breakStartConfirm
    case breakEndConfirm
    case breakSuccess
    case absenceConfirm
    case additionalConfirm
    case additionalSuccess
}

enum ConfirmActionType: Int {
    case login
    case logout
    case logoutAndLogin
    case breakStart
    case breakEnd
    case absenceStart
    case confirm
    case cancel
    case additional
}

class ConfirmTaskViewModel {

    let confirmType: ConfirmViewType
    var task: TaskObj?
    var absence: AbsenceObj?
    var event: RevachaEventObj?
    var unknownTask: TaskObj?

    var additional: AddonButtonObj?

    var remark: String?

    var standardStartTime: Date?
    var standardFinishTime: Date?

    var standardTimeDelay: Int = 0 // minutes

    var isCommentSelected: Bool = false
    var commentType: CommentListViewModel?

    init(confirmType: ConfirmViewType, task: TaskObj? = nil, unknownTask: TaskObj? = nil, absence: AbsenceObj? = nil, additional: AddonButtonObj? = nil, event: RevachaEventObj? = nil) {
        self.confirmType = confirmType
        self.task = task
        self.absence = absence
        self.additional = additional
        self.event = event
        self.unknownTask = unknownTask

        self.standardStartTime = self.getStandardStartTime()
        self.standardFinishTime = self.getStandardFinishTime()

        showCommentListType(type: confirmType)
    }

    func getStandardStartTime() -> Date? {
        let startTimeString = String(CompaniesDataManager.shared.getStandardStartTime().prefix(5))

        return startTimeString.getDateFromTimeString()
    }

    func getStandardFinishTime() -> Date? {
        let finishTimeString = String(CompaniesDataManager.shared.getStandardFinishTime().prefix(5))

        return finishTimeString.getDateFromTimeString()
    }

    func shouldShowStandardTime() -> Bool {
        return CompaniesDataManager.shared.hadStandardWorkTime()
    }

    func getDifferenceFromCurrentTo(_ date: Date?) -> Int? {
        if date != nil {
            return Date().zeroSeconds?.minutes(from: date!)
        } else {
            return nil
        }
    }

    func getIconImage() -> UIImage? {
        switch confirmType {
        case .loginConfirm:
            return UIImage(named: "tracking")
        case .logoutConfirm:
            if CompaniesDataManager.shared.getSpecialClientType() == 6  || CompaniesDataManager.shared.getClientGrpId() == 50 || CompaniesDataManager.shared.getClientGrpId() == 63{
                return UIImage(named: "tracking")
            }
            return task != nil ? UIImage(named: "info") : UIImage(named: "tracking")
        case .logoutMustNote:
            return UIImage(named: "tracking")
        case .loginSuccess, .logoutSuccess, .breakSuccess, .additionalSuccess:
            return UIImage(named: "success")
        case .breakStartConfirm, .breakEndConfirm:
            return UIImage(named: "break")
        case .absenceConfirm:
            return UIImage(named: "absence")
        case .additionalConfirm:
            return UIImage(named: "tracking")
        }
    }

    func getIconBackgroundColor() -> UIColor {
        switch confirmType {

        case .loginConfirm, .breakStartConfirm:
            return #colorLiteral(red: 0.228403002, green: 0.8591639996, blue: 0.5058480501, alpha: 1)
        case .logoutConfirm:
            if CompaniesDataManager.shared.getSpecialClientType() == 6 || CompaniesDataManager.shared.getClientGrpId() == 50 || CompaniesDataManager.shared.getClientGrpId() == 63{
                return  #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 1)
            }
            return task != nil ? #colorLiteral(red: 0.09019607843, green: 0.4352941176, blue: 0.7529411765, alpha: 1) : #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 1)
        case .logoutMustNote:
            return #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 1)
        case .loginSuccess, .logoutSuccess, .breakSuccess, .additionalSuccess:
            return #colorLiteral(red: 0.9215686275, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        case .breakEndConfirm, .absenceConfirm:
            return #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 1)
        case .additionalConfirm:
            return getAdditionalColor()
        }
    }

    func getAdditionalColor() -> UIColor {
        if  let additionalButtons = CompaniesDataManager.shared.getAddonButtons() {

            let additionalButton1ActionType = additionalButtons.button_1?.action_type
            let additionalButton2ActionType = additionalButtons.button_2?.action_type
            let additionalButton3ActionType = additionalButtons.button_3?.action_type
            let additionalButton4ActionType = additionalButtons.button_4?.action_type

            if additional?.action_type == additionalButton1ActionType || additional?.action_type == additionalButton3ActionType {
                return #colorLiteral(red: 0.2101188302, green: 0.7993369699, blue: 0.4015711546, alpha: 1)
            } else if additional?.action_type == additionalButton2ActionType || additional?.action_type == additionalButton4ActionType {
                return #colorLiteral(red: 0.9756608605, green: 0.3157561719, blue: 0.3174736798, alpha: 1)
            }
        }

        return #colorLiteral(red: 0.9215686275, green: 0.9490196078, blue: 0.968627451, alpha: 1)

    }

    func getTaskNameString() -> String? {
        switch confirmType {
        case .loginConfirm, .loginSuccess, .logoutSuccess, .logoutMustNote:
            if task == nil || event != nil {
                return nil
            } else {
                var taskTitle = [String]()

                if let project = task?.projectName {
                    taskTitle.append(project)
                }

                if let name = task?.taskName {
                    taskTitle.append(name)
                }

                if let task = unknownTask {
                    if task.taskName.count > 0 {
                        taskTitle.append(task.taskName)
                    } else {
                        taskTitle.append("UNKNOWN_TASK".localized)
                    }
                }

                return taskTitle.count > 0 ? taskTitle.joined(separator: ", ") : nil
            }
        case .logoutConfirm, .breakStartConfirm, .breakEndConfirm, .breakSuccess, .absenceConfirm, .additionalConfirm, .additionalSuccess:
            return nil
        }
    }

    func getTitleString() -> NSAttributedString {
        switch confirmType {
        case .loginConfirm:
            return self.getLoginTitle()
        case .logoutConfirm:
            return self.getLogoutTitle()
        case .logoutMustNote:
            return NSAttributedString(string: "LOGOUT_WITHOUT_TASK_TITLE".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])//"LOGOUT_WITHOUT_TASK_TITLE".localized
        case .loginSuccess:
            return NSAttributedString(string: "LOGIN_SUCCESS_TITLE".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])//"LOGIN_SUCCESS_TITLE".localized
        case .logoutSuccess:
            return NSAttributedString(string: "LOGOUT_SUCCESS_TITLE".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])//"LOGOUT_SUCCESS_TITLE".localized
        case .breakStartConfirm:
            return NSAttributedString(string: "TAKE_BREAK_TITLE".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])//"TAKE_BREAK_TITLE".localized
        case .breakEndConfirm:
            return NSAttributedString(string: "END_BREAK_TITLE".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])//"END_BREAK_TITLE".localized
        case .breakSuccess:
            return NSAttributedString(string: "BREAK_SUCCESS_TITLE".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])//"BREAK_SUCCESS_TITLE".localized
        case .absenceConfirm:
            return self.getAbsenceTitle()
        case .additionalConfirm:
            return NSAttributedString(string: "ADDITIONAL_BUTTON_MAKE_ACTION".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])//"ADDITIONAL_BUTTON_MAKE_ACTION".localized + (additional?.text ?? "") + "?"
        case .additionalSuccess:
            return NSAttributedString(string: "LOGIN_SUCCESS_TITLE".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])//"LOGIN_SUCCESS_TITLE".localized
        }
    }

    func getLoginTitle() -> NSAttributedString {
        if shouldShowStandardTime(), let diff = getDifferenceFromCurrentTo(standardStartTime), diff != 0, abs(diff) > standardTimeDelay {
            let titleString = diff < 0 ? "LOGIN_BEFORE_STANDARD_TIME".localized : "LOGIN_AFTER_STANDARD_TIME".localized
            return NSAttributedString(string: titleString, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
        } else {
            if let event = event, let task = task {
                let finalString = NSMutableAttributedString(string: "Do you want to report an entry with task".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
                var attributedString = NSAttributedString(string: task.taskName, attributes: [NSAttributedString.Key.font : UIFont.appBold(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
                finalString.append(attributedString)
                attributedString = NSAttributedString(string: "and event".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
                finalString.append(attributedString)
                attributedString = NSAttributedString(string: event.eventName ?? "", attributes: [NSAttributedString.Key.font : UIFont.appBold(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
                finalString.append(attributedString)
                attributedString = NSAttributedString(string: "?", attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
                finalString.append(attributedString)

                return finalString
            } else {
                let titleString = (task != nil || unknownTask != nil) ? "LOGIN_WITH_TASK_TITLE".localized : "LOGIN_WITHOUT_TASK_TITLE".localized
                return NSAttributedString(string: titleString, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
            }
        }
    }

    func getLogoutTitle() -> NSAttributedString {
        if shouldShowStandardTime(), let diff = getDifferenceFromCurrentTo(standardFinishTime), diff != 0, abs(diff) > standardTimeDelay {
            let titleString = diff < 0 ? "LOGOUT_BEFORE_STANDARD_TIME".localized : "LOGOUT_AFTER_STANDARD_TIME".localized
            return NSAttributedString(string: titleString, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
        } else {
            if CompaniesDataManager.shared.getSpecialClientType() == 6 || CompaniesDataManager.shared.getClientGrpId() == 50 || CompaniesDataManager.shared.getClientGrpId() == 63{
                return NSAttributedString(string: "LOGOUT_WITHOUT_TASK_TITLE".localized, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
            }
            let titleString = (task != nil || unknownTask != nil) ? "LOGOUT_WITH_TASK_TITLE".localized : "LOGOUT_WITHOUT_TASK_TITLE".localized
            return NSAttributedString(string: titleString, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
        }
    }

    func getAbsenceTitle() -> NSAttributedString {
        if let report = absence {
            let toDate = report.toDate
            let fromDate = report.fromDate
            let absenceType = report.type
            let days = String(toDate.days(from: fromDate) + 1)
            let titleString = String(format: "ABSENCE_CONFIRM_TITLE".localized, absenceType!.absenceTitle, fromDate.toString(format: "dd.MM.yy"), toDate.toString(format: "dd.MM.yy"), days)
            return NSAttributedString(string: titleString, attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
        } else {
            return NSAttributedString(string: "", attributes: [NSAttributedString.Key.font : UIFont.appRegular(18), NSAttributedString.Key.foregroundColor : UIColor.appBlue()])
        }
    }

    func getConfirmActionType() -> ConfirmActionType {
        switch confirmType {
        case .loginConfirm:
            return .login
        case .logoutConfirm, .logoutMustNote:
            return .logout
        case .breakStartConfirm:
            return .breakStart
        case .breakEndConfirm:
            return .breakEnd
        case .loginSuccess, .logoutSuccess, .breakSuccess, .additionalSuccess:
            return .confirm
        case .absenceConfirm:
            return .absenceStart
        case .additionalConfirm:
            return .additional

        }
    }

    func shouldShowCommentField() -> Bool {
        switch confirmType {

        case .loginConfirm, .breakStartConfirm, .breakEndConfirm, .absenceConfirm, .additionalConfirm:
            return true
        case .logoutConfirm:
            if CompaniesDataManager.shared.getSpecialClientType() == 6 || CompaniesDataManager.shared.getClientGrpId() == 50 || CompaniesDataManager.shared.getClientGrpId() == 63{
                return  true
            }
            return task != nil ? false : true
        case .logoutMustNote:
            return true
        case .loginSuccess, .logoutSuccess, .breakSuccess, .additionalSuccess:
            return false

        }
    }

    func shouldShowCancelView() -> Bool {
        switch confirmType {

        case .loginConfirm, .breakStartConfirm, .breakEndConfirm, .absenceConfirm, .additionalConfirm:
            return true
        case .logoutConfirm:
            if CompaniesDataManager.shared.getSpecialClientType() == 6 || CompaniesDataManager.shared.getClientGrpId() == 50 || CompaniesDataManager.shared.getClientGrpId() == 63{
                return  true
            }
            return task != nil ? false : true
        case .logoutMustNote:
            return true
        case .loginSuccess, .logoutSuccess, .breakSuccess, .additionalSuccess:
            return false
        }
    }

    func shouldShowAdditionalLogoutOptions() -> Bool {
        switch confirmType {

        case .loginConfirm, .loginSuccess, .logoutSuccess, .breakStartConfirm, .breakEndConfirm, .breakSuccess, .absenceConfirm, .additionalConfirm, .additionalSuccess, .logoutMustNote:
            return false
        case .logoutConfirm:
            if CompaniesDataManager.shared.getSpecialClientType() == 6 || CompaniesDataManager.shared.getClientGrpId() == 50 || CompaniesDataManager.shared.getClientGrpId() == 63{
                return  false
            }
            return task != nil ? true : false
        }
    }

    func shouldShowCloseImage() -> Bool {
        switch confirmType {

        case .logoutConfirm, .logoutMustNote:
            if CompaniesDataManager.shared.getSpecialClientType() == 6 || CompaniesDataManager.shared.getClientGrpId() == 50 || CompaniesDataManager.shared.getClientGrpId() == 63{
                return  true
            }
            return task != nil ? true : false
        default:
            return false

        }
    }

    func setRemaark(_ remark: String?) {
        if task != nil || CompaniesDataManager.shared.getAppApplyCommentListOnExit() == 1 || CompaniesDataManager.shared.getAppApplyCommentListOnEntry() == 1  || CompaniesDataManager.shared.getAppReportCompletionNoteExit() == 1 || CompaniesDataManager.shared.getAppReportCompletionNoteEntry() == 1 {
            task?.remark = remark
        }

        if absence != nil {
            absence?.remark = remark
        }

        self.remark = remark
    }

    func mustNoteOnEntry() -> Bool {
        if CompaniesDataManager.shared.getAppReportCompletionNoteEntry() == 1 || Int(event?.eventType ?? "0") == -1 {
            return true
        }
        return false
    }
    func mustSelectCommentOnEntry() -> Bool {
        if CompaniesDataManager.shared.getAppReportCompletionNoteEntry() == 1 &&  CompaniesDataManager.shared.getAppApplyCommentListOnEntry() == 1 {
            return true
        }
        return false
    }

    func mustNoteOnExit() -> Bool {
        if  CompaniesDataManager.shared.getAppReportCompletionNoteExit() == 1 {
            return true
        }
        return false
    }

    func mustSelectCommentOnExit() -> Bool {
        if CompaniesDataManager.shared.getAppReportCompletionNoteExit() == 1 &&  CompaniesDataManager.shared.getAppApplyCommentListOnExit() == 1 {
            return true
        }
        return false
    }

    func showCommentListType(type: ConfirmViewType) {
        switch type {
        case .loginConfirm:
            commentType =  CommentListViewModel(type: .listOnEntry)
            break
        case  .logoutConfirm:
            commentType =  CommentListViewModel(type: .listOnExit)
            break
        default :
            break
        }
    }

    func commentListType() -> CommentListViewModel? {
        return commentType
    }

    func isCommentSelected(select: Bool) {
        self.isCommentSelected = select
    }

}
