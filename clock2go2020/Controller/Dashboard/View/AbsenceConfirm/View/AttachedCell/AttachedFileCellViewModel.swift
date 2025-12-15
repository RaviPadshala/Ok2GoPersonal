//
//  AttachedFileCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/3/20.
//

import UIKit

class AttachedFileCellViewModel {

    var media: MediaObj
    var isRemovable: Bool
    var showAttachIcon: Bool

    init(media: MediaObj, isRemovable: Bool = true, showAttachIcon: Bool = true) {
        self.media = media
        self.isRemovable = isRemovable
        self.showAttachIcon = showAttachIcon
    }

    func getFileName() -> String {
        return media.filename
    }

    func shouldShowRemoveButton() -> Bool {
        return isRemovable
    }

    func shouldShowAttachIcon() -> Bool {
        return showAttachIcon
    }

}
