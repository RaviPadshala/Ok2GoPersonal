//
//  ReportPictureViewModel.swift
//  clock2go2020
//
//  Created by Gleb on 06.08.2020.
//

import Foundation
import UIKit

class ReportPictureViewModel {

    var reportPicture: ReportPictureObj

    var reportSended: ((_ reports: [ReportObj?]) -> Void)?

    var isCommentSelected: Bool = false
    var commentType: CommentListViewModel?

    init(reportPicture: ReportPictureObj) {
        self.reportPicture = reportPicture

        setCommentListType(type: reportPicture.reportType)
    }

    func setCommentListType(type: PictureReportType) {
        switch type {
        case .login:
            commentType =  CommentListViewModel(type: .listOnEntry)
            break
        case  .logout:
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

    func getTitleText() -> String {
        return reportPicture.getReportTitle()
    }

    func getAttachedFiles() -> [MediaObj] {
        return reportPicture.attachedFiles
    }

    func addAttachedMedia(media: MediaObj) {
        reportPicture.attachedFiles.append(media)
    }

    func removeAttachedFile(index: Int) {
        reportPicture.attachedFiles.remove(at: index)
    }

    func getModelForItemAt(index: Int) -> AttachedFileCellViewModel {
        return AttachedFileCellViewModel(media: reportPicture.attachedFiles[index], showAttachIcon: false)
    }

    func shouldDisableAttachView() -> Bool {
        return reportPicture.attachedFiles.count == 1
    }

    func getAttachedTableViewHeight() -> CGFloat {
        let filesCount = reportPicture.attachedFiles.count
        let height = filesCount > 2 ? 50 * 2 : 50 * filesCount
        return CGFloat(height)
    }

    func setRemark(remark: String?) {
        self.reportPicture.remark = remark ?? ""
    }

    // api call

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    func sendReport() {
        guard ReachabilityManager.shared.hasInternetConnection else {
            saveReportOffline()
            return
        }

        vc?.view.addSubview(loadingView)

        let report = ReportPictureEndpoint(reportPicture: reportPicture)
        report.apiCall { (result, error) in

            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                self.reportSended?(result?.data ?? [])
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

    func saveReportOffline() {
        OfflineRequestsManager.sharedInstance.save(reportPicture: reportPicture)
        NavigationController.shared?.showSuccessView(message: "OFFLINE_MODE_REPORT_SAVED".localized)
    }

     func mustNoteOnEntry() -> Bool {
         if CompaniesDataManager.shared.getAppReportCompletionNoteEntry() == 1 {
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
}
