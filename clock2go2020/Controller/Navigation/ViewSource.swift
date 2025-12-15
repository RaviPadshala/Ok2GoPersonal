//
//  ViewSource.swift
//  clock2go2020
//
//  Created by Admin on 12/27/19.
//

import UIKit

class ViewSource: NSObject {

    static func chooseLanguageScreen() -> ChooseLanguageViewController {
        return UIStoryboard.getViewController(
            storyboard: "ChooseLanguageViewController",
            identifier: "ChooseLanguageViewController") as! ChooseLanguageViewController
    }

    static func languageListScreen() -> LanguageListViewController {
        return LanguageListViewController(nibName: "LanguageListViewController", bundle: nil)
    }

    static func phoneInputScreen() -> PhoneInputViewController {
        return UIStoryboard.getViewController(
            storyboard: "PhoneInputViewController",
            identifier: "PhoneInputViewController") as! PhoneInputViewController
    }
    
    static func chatScreen() -> ChatViewController {
        return ChatViewController(nibName: "ChatViewController", bundle: nil)
    }

    static func termsScreen() -> TermsViewController {
        return TermsViewController(nibName: "TermsViewController", bundle: nil)
    }

    static func legalInformationScreen() -> LegalInformationViewController {
        return LegalInformationViewController(nibName: "LegalInformationViewController", bundle: nil)
    }

    static func aboutUsScreen() -> AboutUsViewController {
        return AboutUsViewController(nibName: "AboutUsViewController", bundle: nil)
    }

    static func supportScreen() -> SupportViewController {
        return SupportViewController(nibName: "SupportViewController", bundle: nil)
    }

    static func passwordInputScreen() -> PasswordInputViewController {
        return UIStoryboard.getViewController(
            storyboard: "PasswordInputViewController",
            identifier: "PasswordInputViewController") as! PasswordInputViewController
    }

    static func verificationScreen() -> VerificationViewController {
        return UIStoryboard.getViewController(
            storyboard: "VerificationViewController",
            identifier: "VerificationViewController") as! VerificationViewController
    }

    static func dashboardScreen() -> DashboardViewController {
        return UIStoryboard.getViewController(
            storyboard: "DashboardViewController",
            identifier: "DashboardViewController") as! DashboardViewController
    }
    
    static func barcodeScannerScreen() -> BarcodeScannerViewController {
        return UIStoryboard.getViewController(
            storyboard: "BarcodeScannerViewController",
            identifier: "BarcodeScannerViewController") as! BarcodeScannerViewController
    }

    static func taskListScreen() -> TaskListView {
        return TaskListView(nibName: "TaskListView", bundle: nil)
    }
    
    static func selectTheraphyScreen() -> SelectTheraphyTypeView {
        return SelectTheraphyTypeView(nibName: "SelectTheraphyTypeView", bundle: nil)
    }
    
    static func cityListScreen() -> CityListView {
        return CityListView(nibName: "CityListView", bundle: nil)
    }
    
    static func extendedListView() -> ExtendedListView {
        return ExtendedListView(nibName: "ExtendedListView", bundle: nil)
    }

    static func eventsView() -> EventsView {
        return EventsView(nibName: "EventsView", bundle: nil)
    }
    static func commentListScreen() -> CommentListView {
        return CommentListView(nibName: "CommentListView", bundle: nil)
    }

    static func confirmTaskView() -> ConfirmTaskView {
        return ConfirmTaskView(nibName: "ConfirmTaskView", bundle: nil)
    }
    
    static func confirmTaskViewNew() -> ConfirmTaskViewNew {
        return ConfirmTaskViewNew(nibName: "ConfirmTaskViewNew", bundle: nil)
    }
    
    static func distanceView() -> DistanceView {
        return DistanceView(nibName: "DistanceView", bundle: nil)
    }

    static func salesAmountView() -> SalesAmountView {
        return SalesAmountView(nibName: "SalesAmountView", bundle: nil)
    }

    static func signedReportConfirmView() -> SignedReportConfirmView {
        return SignedReportConfirmView(nibName: "SignedReportConfirmView", bundle: nil)
    }

    static func errorView() -> ErrorView {
        return ErrorView(nibName: "ErrorView", bundle: nil)
    }

    static func successView() -> SuccessView {
        return SuccessView(nibName: "SuccessView", bundle: nil)
    }

    static func absenceConfirmView() -> AbsenceConfirmView {
        return AbsenceConfirmView(nibName: "AbsenceConfirmView", bundle: nil)
    }

    static func distanceConfirmView() -> DistanceConfirmView {
        return DistanceConfirmView(nibName: "DistanceConfirmView", bundle: nil)
    }

    static func multipleLoginView() -> MultiReportView {
        return MultiReportView(nibName: "MultiReportView", bundle: nil)
    }

    static func multipleSelectEmpsView() -> SelectEmpsView {
        return SelectEmpsView(nibName: "SelectEmpsView", bundle: nil)
    }

    static func personalInfoScreen() -> PersonalInfoViewController {
        return PersonalInfoViewController(nibName: "PersonalInfoViewController", bundle: nil)
    }

    static func sideBarView() -> SideBarView {
        return SideBarView(nibName: "SideBarView", bundle: nil)
    }
    static func createCardView() -> CreateCardViewController {
        return CreateCardViewController(nibName: "CreateCardViewController", bundle: nil)
    }

    static func datePickerView() -> DatePickerView {
        return DatePickerView(nibName: "DatePickerView", bundle: nil)
    }

    static func attachConfirmView() -> AttachConfirmView {
        return AttachConfirmView(nibName: "AttachConfirmView", bundle: nil)
    }

    static func chooseListView() -> ChooseListView {
        return ChooseListView(nibName: "ChooseListView", bundle: nil)
    }

    static func chooseMultipleListView() -> MultipleChooseView {
        return MultipleChooseView(nibName: "MultipleChooseView", bundle: nil)
    }

    static func userProfileScreen() -> UserProfileViewController {
        return UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
    }

    static func notificationScreen() -> NotificationViewController {
        return NotificationViewController(nibName: "NotificationViewController", bundle: nil)
    }

    static func reminderTimeScreen() -> ReminderTimeViewController {
        return ReminderTimeViewController(nibName: "ReminderTimeViewController", bundle: nil)
    }

    static func reminderDaysScreen() -> ReminderDaysViewController {
        return ReminderDaysViewController(nibName: "ReminderDaysViewController", bundle: nil)
    }
    static func formviewScreen() -> FormViewController {
        return FormViewController(nibName: "FormViewController", bundle: nil)
    }
    static func formWebViewScreen() -> FormWebViewController {
        return FormWebViewController(nibName: "FormWebViewController", bundle: nil)
    }
    static func setPasswordManagerScreen() -> SetPasswordManagerViewController {
        return SetPasswordManagerViewController(nibName: "SetPasswordManagerViewController", bundle: nil)
    }

    static func reportManagementScreen() -> ReportManagementViewController {
        return ReportManagementViewController(nibName: "ReportManagementViewController", bundle: nil)
    }

    static func sortingListView() -> SortingListView {
        return SortingListView(nibName: "SortingListView", bundle: nil)
    }

    static func updateReportConfirmView() -> UpdateReportConfirmView {
        return UpdateReportConfirmView(nibName: "UpdateReportConfirmView", bundle: nil)
    }
    
    static func updateHolocustReportConfirmView() -> UpdateHolocustReportConfirmView {
        return UpdateHolocustReportConfirmView(nibName: "UpdateHolocustReportConfirmView", bundle: nil)
    }

    static func mapViewScreen() -> MapViewController {
        return MapViewController(nibName: "MapViewController", bundle: nil)
    }

    static func emailReportView() -> EmailReportView {
        return EmailReportView(nibName: "EmailReportView", bundle: nil)
    }

    static func closeMonthReportView() -> CloseMonthView {
        return CloseMonthView(nibName: "CloseMonthView", bundle: nil)
    }

    static func editReportView() -> EditReportView {
        return EditReportView(nibName: "EditReportView", bundle: nil)
    }

    static func absenceReportView() -> AbsenceReportView {
        return AbsenceReportView(nibName: "AbsenceReportView", bundle: nil)
    }

    static func addRideView() -> AddRideView {
        return AddRideView(nibName: "AddRideView", bundle: nil)
    }

    static func healthDisclaimerView() -> HealthDisclaimerView {
        return HealthDisclaimerView(nibName: "HealthDisclaimerView", bundle: nil)
    }

    static func dashboardWithoutAppAccessScreen() -> DashboardWithoutAppAccessViewController {
        return UIStoryboard.getViewController(
            storyboard: "DashboardWithoutAppAccessViewController",
            identifier: "DashboardWithoutAppAccessViewController") as! DashboardWithoutAppAccessViewController
    }

    static func guideVideoView() -> GuideVideoView {
        return GuideVideoView(nibName: "GuideVideoView", bundle: nil)
    }

    static func managerScreen() -> ManagerViewController {
        return ManagerViewController(nibName: "ManagerViewController", bundle: nil)
    }

    static func addEmployeeView() -> AddEmployeeView {
        return AddEmployeeView(nibName: "AddEmployeeView", bundle: nil)
    }

    static func reportPictureView() -> ReportPictureView {
        return ReportPictureView(nibName: "ReportPictureView", bundle: nil)
    }

    static func approveDialogView() -> ApproveDialogView {
        return ApproveDialogView(nibName: "ApproveDialogView", bundle: nil)
    }

    static func employeesReportManagementScreen () -> EmployeesReportManagementViewController {
        return EmployeesReportManagementViewController(nibName: "EmployeesReportManagementViewController", bundle: nil)
    }

    static func closeMonthManagementScreen () -> CloseMonthManagementViewController {
        return CloseMonthManagementViewController(nibName: "CloseMonthManagementViewController", bundle: nil)
    }

    static func mothEmpReportsScreen() -> MonthEmpReportsViewController {
        return MonthEmpReportsViewController(nibName: "MothEmpReportsViewController", bundle: nil)
    }

    static func addMgrReportsScreen() -> AddMgrReportViewController {
        return AddMgrReportViewController(nibName: "AddMgrReportViewController", bundle: nil)
    }
    
    static func weeklyScheduleScreen() -> WeeklyScheduleViewController {
        return WeeklyScheduleViewController(nibName: String(describing: WeeklyScheduleViewController.self), bundle: nil)
    }
    
    static func searchTaskScreen() -> SearchTaskView {
        return SearchTaskView(nibName: String(describing: SearchTaskView.self), bundle: nil)
    }
    
    static func requestCompletionScreen() -> RequestCompletionView {
        return RequestCompletionView(nibName: String(describing: RequestCompletionView.self), bundle: nil)
    }
    
    static func checkInConfirmationView() -> CheckInConfirmationView {
        return CheckInConfirmationView(nibName: "CheckInConfirmationView", bundle: nil)
    }
    
    static func confirmationAlertView() -> ConfirmationAlertView {
        return ConfirmationAlertView(nibName: "ConfirmationAlertView", bundle: nil)
    }
    static func approveHourView() -> ApproveHour {
        return ApproveHour(nibName: "ApproveHour", bundle: nil)
    }
    
    static func approveHoursView() -> ApproveHours {
        return ApproveHours(nibName: "ApproveHours", bundle: nil)
    }
    static func approveHourEditView() -> ApproveHourEditScreen {
        return ApproveHourEditScreen(nibName: "ApproveHoursEdit", bundle: nil)
    }
    static func approveHourSuccessView() -> ApproveHourSuccess {
        return ApproveHourSuccess(nibName: "ApproveHourSuccess", bundle: nil)
    }
    
    static func studentDailyReportScreen() -> StudentDailyReportVC {
        return StudentDailyReportVC(nibName: "StudentDailyReportVC", bundle: nil)
    }
}
