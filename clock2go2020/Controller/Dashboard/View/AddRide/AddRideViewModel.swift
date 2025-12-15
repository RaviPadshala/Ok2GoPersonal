//
//  AddRideViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/2/20.
//

import UIKit

class AddRideViewModel {
    private var rideType: RideType?
    private var value: String?

    private var attachedFiles: [MediaObj] = []

    init(rideType: RideType? = nil, value: String? = nil) {
        self.rideType = rideType
        self.value = value
    }

    func setRideType(type: RideType) {
        self.rideType = type
    }

    func setRideType(title: String) {
        self.rideType = RideType.withTitle(title)
    }

    func getRideType() -> RideType? {
        return rideType
    }

    func getRideTypeTitle() -> String {
        return rideType?.title ?? "Choose ride type"
    }

    func setValue(_ value: String?) {
        self.value = value
    }

    func getValueTitle() -> String {
        return value ?? ""
    }

    func getValuePlaceholder() -> String {
        return rideType?.valueTitle ?? "Enter value"
    }

    func getValueImage() -> UIImage? {
        return rideType?.valueImage
    }

    func shouldShowAttachView() -> Bool {
        return rideType?.canAttachFile ?? false
    }

    func getModelForChooseList() -> ChooseListViewModel {
        let title = "Choose ride type"
        let data = RideType.allTitles()

        return ChooseListViewModel(title: title, data: data)
    }

    func shouldDisableConfirmView() -> Bool {
        return rideType == nil || value == nil
    }

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

    func removeAttachedFile(index: Int) {
        attachedFiles.remove(at: index)
    }

    func getAttachedTableViewHeight() -> CGFloat {
        let filesCount = attachedFiles.count
        let height = filesCount > 2 ? 50 * 2 : 50 * filesCount
        return CGFloat(height)
    }

    func shouldDisableAttachView() -> Bool {
        return attachedFiles.count == 5
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
}
