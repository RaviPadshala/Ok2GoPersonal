//
//  AbsenceReportModel.swift
//  clock2go2020
//
//  Created by MacBookPro on 3/30/20.
//

import Foundation
import UIKit

class AbsenceReportViewModel {
    private var absenceId: Int?
    private var type: String?
    private var date: String?
    private var medias: [MediaObj]?
    var reportId: Int?
    var empId: Int?

    weak var delegate: AbsenceReportViewModelDelegate?

    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }

    init(absenceId: Int?, type: String, date: String) {
        self.absenceId = absenceId
        self.medias = nil
        self.type = type
        self.date = date

        self.getAbsencePictures()
    }

    // Mgr init
    init(reportId: Int?, empId: Int) {
        self.reportId = reportId
        self.empId = empId
    }

    func getModelForFileCellAt(index: Int) -> AttachedFileCellViewModel? {
        guard let media = medias?[index] else { return nil }
        return AttachedFileCellViewModel(media: media, isRemovable: false)
    }

    func getImageModelForCellAt(index: Int) -> ImageViewModel? {
        guard let media = medias?[index] else { return nil }
        return ImageViewModel(image: media.image)
    }

    func getType() -> String {
        guard let absenceId = Int(type ?? ""), let absenceType = AbsenceTypeEntity.withIdentifier(absenceId) else { return "" }

        return absenceType.absenceTitle
    }

    func getDate() -> String {
        return date?.changeDateFormat(from: "yyyy-MM-dd HH:mm:ss", to: "dd.MM.yy") ?? ""
    }

    func getNumberOfFiles() -> Int {
        return medias?.count ?? 0
    }

    func getTableViewHeight() -> CGFloat {
        return getNumberOfFiles() > 2 ? CGFloat(50.0 * 2.0) : CGFloat(getNumberOfFiles() * 50)
    }

    func isMgrStatus() -> Bool {
        if empId == 0 {
            return true
        } else {
            return false
        }
    }

    func setFiles(pictures: [AbsencePictureObj]?) {
        guard let files = pictures else { return }

        var mediaFiles: [MediaObj] = []

        for picture in files {
            if let filename = picture.filename, let imageString = picture.content, let index = imageString.range(of: ",")?.lowerBound {
                var imageDataString = imageString.replacingOccurrences(of: String(imageString[..<index]), with: "")
                imageDataString = imageDataString.replacingOccurrences(of: ",", with: "")

                if let image = imageDataString.toImage(), let mediaObj = MediaObj(withImage: image, fileName: filename) {
                    mediaFiles.append(mediaObj)
                }
            }
        }

        medias = mediaFiles

        delegate?.didLoadData()
    }

    // api call
    func getAbsencePictures() {
        guard let date = date, let type = Int(type ?? "") else { return }

        vc?.view.addSubview(loadingView)

        let getAbsencePics = GetAbsencePicturesEndpoint(date: date, type: type)
        getAbsencePics.apiCall { pictures, error in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                self.setFiles(pictures: pictures)
            } else {
                self.delegate?.didReceiveError(error)
            }
        }
    }

    func deleteAbsence() {
        vc?.view.addSubview(loadingView)

        let deleteReport = DeleteEmpReportEndpoint(reportId: absenceId)
        deleteReport.apiCall { result, error in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                self.delegate?.didRemoveAbsence(result)
            } else {
                self.delegate?.didReceiveError(error)
            }
        }
    }

    // Api call management
    func SetMgrAbsense(status: Int) {
        vc?.view.addSubview(loadingView)
        let setStatusAbsense = SetAbsenceStatusEndpoint(empId: String(empId ?? 0), reportId: reportId, status: status)
        setStatusAbsense.apiCall { (error) in
            self.loadingView.removeFromSuperview()

            if error?.success ?? false {
                NavigationController.shared?.showErrorView(error: error)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
            }
        }
    }
}

protocol AbsenceReportViewModelDelegate: NSObjectProtocol {
    func didLoadData()
    func didRemoveAbsence(_ empReports: [String: EmpDayReportsObj]?)
    func didReceiveError(_ error: ErrorObject?)
}
