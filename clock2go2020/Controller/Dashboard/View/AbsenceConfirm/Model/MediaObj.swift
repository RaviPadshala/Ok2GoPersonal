//
//  MediaObj.swift
//  clock2go2020
//
//  Created by Admin on 2/8/20.
//

import UIKit

let supportedTypes = [ "jpg", "png" ]

let UNSUPPORTED_TYPE = "unsupported"

struct MediaObj {
    let filename: String
    let data: Data
    let mimeType: String
    let image: UIImage?

    init?(withImage image: UIImage, fileName: String) {
        self.image = image
        self.mimeType = "image/jpg"
        self.filename = fileName// .components(separatedBy: ".").first! + ".jpg"

        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        self.data = data
    }

    init?(withFileUrl fileUrl: URL) {
        self.image = nil
        self.filename = fileUrl.lastPathComponent
        let ext = self.filename.components(separatedBy: ".").last
        if supportedTypes.contains(ext ?? "") {
            self.mimeType = ext ?? ""
        } else {
            self.mimeType = UNSUPPORTED_TYPE
        }
        do {
            let fileData = try Data(contentsOf: fileUrl)
            self.data = fileData
        } catch let error {
            print(error)
            return nil
        }
    }
}
