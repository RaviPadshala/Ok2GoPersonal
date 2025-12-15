//
//  SettingsObj.swift
//  clock2go2020
//
//  Created by Admin on 1/29/20.
//

import UIKit

struct SettingsObj: Codable {
    var showTasks: Int?                 /// tasks feature active
    var useLastTask: Int?               /// use last task by default or empty task
    var mustReportTask: Int?            /// the user must report with task
    var taskOnlySelect: Int?            /// the user must select task in list and cannot add a new one

    var showStandards: Int?             /// show standards hours
    var standardTimeout: Int?           /// timeout for standard

    var reportWithoutPosition: Int?     /// GPS position is not sent in report
    var mustReportPosition: Int?        /// the user cannot report without position

    var showAbsences: Int?              /// absence feature active
    var absenceTypes: [Int]?            /// available absence types
    var absencePicture: Int?            /// can send picture with absence report
    var absenceTypesMustPict: [Int]?    /// a picture must be sent with these absences

    var showTracking: Int?              /// tracking feature is active
    var trackFrequency: Int?            /// tracking frequency (in minutes)
    var showDistance: Int?              /// distance measurement is active
    var showTravels: Int?               /// travels feature active

    var showReports: Int?               /// show last reports and daily stats
    var reportCompletion: Int?
    var ReportCompletionAdd : Int?
    var ReportCompletionEdit: Int?          /// report Edit feature active
    var ReportCompletionDelete: Int?          /// report delete feature active
    var reportCompletionNote: Int?      /// report completion need remark

    var closeMonth: Int?                /// the user can close month
    var closeMonthNeedConfirm: Int?     /// the user can close month only if all reports are confirmed
    var closeMonthNeedComplete: Int?    /// the user can close month only if no report are missing

    var showBreaks: Int?                /// breaks feature
    var breakTime: Int?                 /// break time in minutes

    var IamHereButton: Int?
    
    var mustReportPairs: Int?           /// the user must report exit before a new entrance
    var mustReportInPolygon: Int?       /// the user must report in a polygon

    var managerApp: Int?                /// manager app - need authentication
    var reportOthersEmps: Int?          /// the user can report for another employee

    var showForms: Int?                 /// form feature active

    var NFCReportAppButton : Int?           /// to activate nfc feature
//    var NFCReportAppAutomaticallyTask : Int? // To activate automatic report through NFC
//    var NFCReportAppWithTask : Int?         // to activate mandatory report with task through NFC
//    var NFCReportAppTaskMundatory : Int?    // To activate user can not make report without nfc scan
//    var NFCLocationVerificationAppButton : Int? // to activate report verification location button for NFC
    
    var barcodeReports: Int?            /// barcode scanning feature
    var mustReportBarcode: Int?         /// the user must report with barcode - not in use

    var pictureReports: Int?            /// picture (in report) feature active - not in use
    var mustReportPicture: Int?         /// the user must report with picture - not in use

    var faceRecognitionReport: Int?     /// face recognition feature active - not in use
    var mustReportFaceRecognition: Int? /// the user must report with face recognition  - not in use

    var showHealthDisclaimer: Int?      /// health disclaimer feature active
    var mustHealthDisclaimer: Int?      /// health disclaimer is mandatory to report

    var mustPictureOnEntry: Int?        /// need to report entry with picture
    var mustPictureOnExit: Int?         /// need to report exit with picture
    var mustPictureText: String?        /// string for report picture feature

    var exitEnforcement: Int?          /// ned to  tracking polygon

    var appReportCompletionNoteEntry: Int? /// for all users - must complete a note on entry
    var appReportCompletionNoteExit: Int? /// for all users - must complete a note on exit

    var appApplyCommentListOnExit: Int?  /// when equals to 1 use the comment list instead of regular comment.
    var appApplyCommentListOnEntry: Int?

    var appCommentListOnExit: [Int]? /// the comment list to be displayed when appApplyCommentListOnExit is set
    var appCommentListOnEntry: [Int]?

    var completionOnlyToday: Int?   /// report completion allowed only for today
    var allowCreateProjectTask: Int? ///allow to create task to an existing project on a client level
    var workSchedule: Int? ///
    var allowTaskSearch: Int?///
    var showLeftHours: Int?
    var requestExitCompletion: Int?
    var lastEntry: LastEntryObj?
    var appPatientNotAtHome: Int?
    
    var ManualTravelReport: Int?
    var TravelReportFromApprovedTable: Int?
    
    var chatboot: Int?
    var chatbooturl: String?
    
    enum CodingKeys: String, CodingKey {
        case showTasks
        case useLastTask
        case mustReportTask
        case taskOnlySelect
        case showStandards
        case standardTimeout
        case reportWithoutPosition
        case mustReportPosition
        case showAbsences
        case absenceTypes
        case absencePicture
        case absenceTypesMustPict
        case IamHereButton
        case showTracking
        case trackFrequency
        case showDistance
        case showTravels
        case showReports
        case reportCompletion
        case ReportCompletionAdd
        case ReportCompletionEdit
        case ReportCompletionDelete
        case reportCompletionNote
        case closeMonth
        case closeMonthNeedConfirm
        case closeMonthNeedComplete
        case showBreaks
        case breakTime
        case mustReportPairs
        case mustReportInPolygon
        case managerApp
        case reportOthersEmps
        case showForms
        case NFCReportAppButton
//        case NFCReportAppAutomaticallyTask
//        case NFCReportAppWithTask
//        case NFCReportAppTaskMundatory
//        case NFCLocationVerificationAppButton
        case barcodeReports
        case mustReportBarcode
        case pictureReports
        case mustReportPicture
        case faceRecognitionReport
        case mustReportFaceRecognition
        case showHealthDisclaimer
        case mustHealthDisclaimer
        case mustPictureOnEntry
        case mustPictureOnExit
        case mustPictureText
        case exitEnforcement
        case appReportCompletionNoteEntry
        case appReportCompletionNoteExit
        case appApplyCommentListOnExit
        case appApplyCommentListOnEntry
        case appCommentListOnExit
        case appCommentListOnEntry
        case completionOnlyToday
        case allowCreateProjectTask
        case workSchedule
        case allowTaskSearch
        case showLeftHours
        case requestExitCompletion = "RequestExitCompletion"
        case lastEntry = "LastEntry"
        case appPatientNotAtHome = "AppPatientNotAtHome"
        case ManualTravelReport
        case TravelReportFromApprovedTable
        case chatboot
        case chatbooturl
    }
}

struct LastEntryObj: Codable {
    let date: String
    let time: String
    let taskId: String?
}
