//
//  AttachConfirmView.swift
//  clock2go2020
//
//  Created by Admin on 2/9/20.
//

import UIKit
import Photos

class AttachConfirmView: UIViewController {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var closeImage: UIImageView!

    @IBOutlet weak var attachTitle: UILabel!
    @IBOutlet weak var attachPhotoView: UIView!
    @IBOutlet weak var attachPhotoTitle: UILabel!
    @IBOutlet weak var attachCameraView: UIView!
    @IBOutlet weak var attachCameraTitle: UILabel!

    var attachedFile: ((_ media: MediaObj) -> Void)?
    var bigSizeAttached: (() -> Void)?

    var shouldCompressImage = true

    var allowEditting: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setLocalizedStrings()
        setupTaps()
    }

    // MARK: Property
    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        attachPhotoView.border(width: 1.3, color: #colorLiteral(red: 0, green: 0.4388672411, blue: 0.7514092326, alpha: 1))
        attachPhotoView.roundCorners([.allCorners], radius: 30.0)

        attachCameraView.border(width: 1.3, color: #colorLiteral(red: 0, green: 0.4388672411, blue: 0.7514092326, alpha: 1))
        attachCameraView.roundCorners([.allCorners], radius: 30.0)
    }

    func setLocalizedStrings() {
        attachTitle.text = "ATTACH_TITLE".localized
        attachPhotoTitle.text = "ATTACH_PHOTO_TITLE".localized
        attachCameraTitle.text = "ATTACH_CAMERA_TITLE".localized
    }

    func setupTaps() {
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(backgroundTap)

        let closeTap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        closeImage.addGestureRecognizer(closeTap)

        let photoTap = UITapGestureRecognizer(target: self, action: #selector(showAttachPhotoView))
        attachPhotoView.addGestureRecognizer(photoTap)

        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(showCameraView))
        attachCameraView.addGestureRecognizer(cameraTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func showAttachFileView() {
        let vc = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        vc.delegate = self
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        UIButton.appearance().tintColor = UIColor.blue
        self.present(vc, animated: true, completion: nil)
    }

    @objc func showAttachPhotoView() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = allowEditting
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    @objc func showCameraView() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = allowEditting
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

}

extension AttachConfirmView: UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - document picker delegate

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if let media = MediaObj(withFileUrl: url) {
            attachedFile?(media)
        }
        self.dismissView()
    }

    // MARK: - image picker delegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        var image = UIImage()
        var filename = ""

        if let originalImage = info[.originalImage] as? UIImage {
            image = originalImage

            if let cropRect = info[.cropRect] as? CGRect {
                image = originalImage.crop(cropRect: cropRect)
            }

            if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL,
                let asset = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil).firstObject,
                let name = asset.value(forKey: "filename") as? String {
                filename = name.components(separatedBy: ".").first! + ".jpg"
            } else {
                filename = getCameraImageName()
            }
        }

        picker.dismiss(animated: true, completion: nil)

        if let data = image.jpegData(compressionQuality: 0.45), let finalImage = UIImage(data: data) {
            let size = Float(Double(data.count)/1024)
            if size > 1000, shouldCompressImage {
                self.dismiss(animated: true) {
                    self.bigSizeAttached?()
                }
            } else {
                self.dismissView()
                if let media = MediaObj(withImage: finalImage, fileName: filename) {
                    attachedFile?(media)
                }
            }
        }
    }

    func getCameraImageName() -> String {
        return "photo-" + Date().toString(format: "dd.MM.yy_HH.mm.ss") + ".jpg"
    }

}
