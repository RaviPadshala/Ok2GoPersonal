//
//  SignedReportConfirmViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/28/20.
//

import UIKit

class SignedReportConfirmViewModel {
    var attachedFiles: [MediaObj] = []
    var fromDate: Date = Date()
    var toDate: Date = Date()

    func getAttachedFiles() -> [MediaObj] {
        return attachedFiles
    }

    func addAttachedMedia(media: MediaObj) {
        attachedFiles.append(media)
    }

    func addAttachedFile(image: UIImage, fileName: String) {
        if let file = MediaObj(withImage: image, fileName: fileName) {
            attachedFiles.append(file)
        }
    }

    func addAttachedFile(fileUrl: URL) {
        if let file = MediaObj(withFileUrl: fileUrl) {
            attachedFiles.append(file)
        }
    }

    func removeAttachedFile(index: Int) {
        attachedFiles.remove(at: index)
    }

    func getAttachedTableViewHeight() -> CGFloat {
        let filesCount = attachedFiles.count
        let height = filesCount > 2 ? 50 * 2 : 50 * filesCount
        return CGFloat(height)
    }

    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"

        let dateString = formatter.string(from: Date())

        return dateString
    }

    func getFromDateString() -> String {
        return fromDate.toString(format: "dd.MM.yy")
    }

    func getToDateString() -> String {
        return toDate.toString(format: "dd.MM.yy")
    }

    func setFromDate(date: Date) {
        fromDate = date
        if date.days(from: toDate) > 0 {
            toDate = date
        }
    }

    func setToDate(date: Date) {
        toDate = date
    }

    func shouldDisableAttachView() -> Bool {
        return attachedFiles.count == 4
    }

    func shouldDisableConfirmView() -> Bool {
        return (attachedFiles.count == 0)
    }

    func getAttachViewColor() -> UIColor {
        return shouldDisableAttachView() ? #colorLiteral(red: 0.7386835814, green: 0.7387273908, blue: 0.7423955798, alpha: 1) : #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1)
    }

    func getAttachViewImage() -> UIImage? {
        return shouldDisableAttachView() ? UIImage(named: "writing_gray") : UIImage(named: "writing")
    }

    func getModelForItemAt(index: Int) -> AttachedFileCellViewModel {
        return AttachedFileCellViewModel(media: attachedFiles[index])
    }

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    // api
    func sendSignedReport() {
        vc?.view.addSubview(loadingView)

        let fromDateString = fromDate.toString(format: "yyyy-MM-dd")
        let toDateString = toDate.toString(format: "yyyy-MM-dd")

        let signedReportEndpoint = WriteShlomitSignedReportEndpoint(files: attachedFiles, fromDate: fromDateString, toDate: toDateString)
        signedReportEndpoint.apiCall { (error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                NavigationController.shared?.showSuccessView()
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }

}
