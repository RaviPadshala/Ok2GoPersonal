//
//  ReportPictureView.swift
//  clock2go2020
//
//  Created by Gleb on 06.08.2020.
//

import UIKit
import Photos

class ReportPictureView: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var mustPictureTextlabel: UILabel!
    @IBOutlet weak var attachStackView: UIStackView!
    @IBOutlet weak var attachView: UIView!
    @IBOutlet weak var takePictureTitle: UILabel!
    @IBOutlet weak var commentTaskTextField: UITextField!
    @IBOutlet weak var photoTableView: UITableView!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmViewTitle: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewTitle: UILabel!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachedTableViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var mustNoteTitle: UILabel!
    @IBOutlet weak var commentListView: UIView!
    @IBOutlet weak var arrowCommentListImage: UIImageView!
    @IBOutlet weak var commentListTitle: UILabel!

    // MARK: Property
    var viewModel: ReportPictureViewModel!
    var shouldCompressImage = true

    var cancelTappedAction: (() -> Void)?

    var commentListType: CommentListViewModel?
    var commentAdded: Bool = false
    var makePhoto: Bool = false

    // MARK: Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setTextField()
        setLocalizedStrings()
        setupTableView()
        setupTaps()
        checkingMustNote()
    }

    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         NotificationCenter.default.removeObserver(self)
     }

    func checkingMustNote() {
        if viewModel.mustSelectCommentOnEntry() || viewModel.mustSelectCommentOnExit() {
            commentTaskTextField.isHidden = viewModel.mustSelectCommentOnEntry()
            mustNoteTitle.isHidden = viewModel.mustSelectCommentOnEntry()
            commentListView.isHidden = !viewModel.mustSelectCommentOnEntry()
            disableConfirmVIew()
        } else if viewModel.mustNoteOnExit() || viewModel.mustNoteOnEntry() {
            commentListView.isHidden = viewModel.mustNoteOnExit()
            commentTaskTextField.isHidden = !viewModel.mustNoteOnExit()
            mustNoteTitle.isHidden = commentAdded
            disableConfirmVIew()
        } else {
            reloadAttachView()
        }
    }

    func setupConfirmView(enable: Bool) {
        switch enable {
        case true:
            confirmView.isUserInteractionEnabled = enable
            confirmView.alpha = 1
        default:
            confirmView.isUserInteractionEnabled = enable
            confirmView.alpha = 0.5
        }
    }

    func disableConfirmVIew() {
        if commentAdded && makePhoto {
            setupConfirmView(enable: true)
            mustNoteTitle.isHidden = true
        } else {
            setupConfirmView(enable: false)
        }
    }

    // MARK: Property func
    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)

        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        setupUIForView(confirmView)
        setupUIForView(cancelView)
        setupUIForView(attachView)
        attachView.border(width: 1.3, color: #colorLiteral(red: 0, green: 0.4388672411, blue: 0.7514092326, alpha: 1))

        // attachStackView.addBackground(color: #colorLiteral(red: 0.9212146401, green: 0.9490351081, blue: 0.9671724439, alpha: 1), corners: 30.0)

        refreshTableViewHeight(animate: false)

        iconView.backgroundColor = viewModel.reportPicture.getBackgroundColor()

        setupUIForView(commentListView)
        commentListView.border(width: 1.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        mustNoteTitle.isHidden = true
        commentListView.isHidden = true
    }

    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 30.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }

    func setTextField() {
        commentTaskTextField.delegate = self
        commentTaskTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        commentTaskTextField.roundCorners([.allCorners], radius: 30)
        commentTaskTextField.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        commentTaskTextField.border(width: 1.3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        commentTaskTextField.borderStyle = .none

        commentTaskTextField.placeholder = "ADD_COMMENT".localized
        commentTaskTextField.placeholderColor(color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        commentTaskTextField.setPadding(rightImage: UIImage(named: "writing"), rightPadding: 50, leftPadding: 10)

        commentTaskTextField.addCloseToolbar()
    }

    func setLocalizedStrings() {
        mustPictureTextlabel.text = viewModel.getTitleText()
        takePictureTitle.text = "TAKE_A_PICTURE".localized
        confirmViewTitle.text = "CONFIRM".localized
        cancelViewTitle.text = "CANCEL".localized
    }

    func setupTableView() {
        let cell = UINib(nibName: AttachedFileCell.identifier, bundle: nil)
        photoTableView.register(cell, forCellReuseIdentifier: AttachedFileCell.identifier)

        photoTableView.delegate = self
        photoTableView.dataSource = self
        photoTableView.tableFooterView = UIView()
        photoTableView.flashScrollIndicators()
    }

    func setViewModel(_ viewModel: ReportPictureViewModel) {
        self.viewModel = viewModel
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        backgroundView.addGestureRecognizer(tap)

        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        confirmView.addGestureRecognizer(confirmTap)

        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)

        let attachTap = UITapGestureRecognizer(target: self, action: #selector(showCameraView))
        attachView.addGestureRecognizer(attachTap)

        let selectCommentTap = UITapGestureRecognizer(target: self, action: #selector(selectComment))
        commentListView.addGestureRecognizer(selectCommentTap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func confirmTapped() {
        dismissView()
        viewModel.sendReport()
    }

    @objc func cancelTapped() {
        dismissView()
        cancelTappedAction?()
    }

    @objc func showCameraView() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    @objc func selectComment() {
         let vc = ViewSource.commentListScreen()
        vc.config(model: viewModel.commentType!)
        vc.selectedComment = { [weak self] (comment) in
            self?.commentListTitle.text = comment
            self?.commentAdded = true
            self?.checkingMustNote()
            vc.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
    }

    func showErrorView(title: String?, message: String?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: title, message: message)
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: Extension TextField
extension ReportPictureView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 30
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.setRemark(remark: textField.text)

        if viewModel.mustNoteOnEntry() || viewModel.mustNoteOnExit() {
            if textField.text != nil && textField.text != "" {
                 commentAdded = true
                mustNoteTitle.isHidden = true
            } else {
                commentAdded = false
                mustNoteTitle.isHidden = false
            }
            checkingMustNote()
        }
    }

}

// MARK: Extension Camera
extension ReportPictureView: UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

        
        
        
            ImageCompressor.compress(image: image, maxByte: 1000000) { image in
                        guard let compressedImage = image else { return }
                        // Use compressedImage
                print("Compressed Image")
                if let data = compressedImage.jpegData(compressionQuality: 1.0){
                    let size = Float(Double(data.count)/1024)
                    if size > 1000, self.shouldCompressImage {
                            print("bieggest")
                        DispatchQueue.main.async {
                            self.showErrorView(title: nil, message: "ATTACH_BIG_SIZE_MESSAGE".localized)
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            if let media = MediaObj(withImage: compressedImage, fileName: filename) {
                                /// add image
                                self.makePhoto = true
                                self.viewModel.addAttachedMedia(media: media)
                                self.reloadTableView()
                            }
                        }
                        
                    }
                }
        }
        
        picker.dismiss(animated: true, completion: nil)
           
        
       

//        if let data = image.jpegData(compressionQuality: 0.8), let finalImage = UIImage(data: data) {
//            ImageCompressor.compress(image: image, maxByte: 2000000) { image in
//                        guard let compressedImage = image else { return }
//                        // Use compressedImage
//                print("Compressed Image")
//                    }
//            let size = Float(Double(data.count)/1024)
//            if size > 1000, shouldCompressImage {
//                    print("bieggest")
//                self.showErrorView(title: nil, message: "ATTACH_BIG_SIZE_MESSAGE".localized)
//            } else {
//
//                if let media = MediaObj(withImage: finalImage, fileName: filename) {
//                    /// add image
//                    self.makePhoto = true
//                    self.viewModel.addAttachedMedia(media: media)
//                    self.reloadTableView()
//                }
//            }
//        }
    }

    func getCameraImageName() -> String {
        return "photo-" + Date().toString(format: "dd.MM.yy_HH.mm.ss") + ".jpg"
    }
}

// MARK: Extension TableView
extension ReportPictureView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reportPicture.attachedFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AttachedFileCell.identifier, for: indexPath) as? AttachedFileCell {

            let cellViewModel = viewModel.getModelForItemAt(index: indexPath.row)

            cell.config(viewModel: cellViewModel)
            cell.selectionStyle = .none
            cell.removeAction = {
                self.viewModel.removeAttachedFile(index: indexPath.row)
                self.makePhoto = false
                self.reloadTableView()
            }

            return cell
        }
        return UITableViewCell()
    }

    func reloadTableView() {
          refreshTableViewHeight()
          photoTableView.reloadData()
        checkingMustNote()
      }

      func refreshTableViewHeight(animate: Bool = true) {
          let duration = animate ? 0.3 : 0
          self.view.layoutIfNeeded()
          UIView.animate(withDuration: duration) {
              self.attachedTableViewHeightConstraint.constant = self.viewModel.getAttachedTableViewHeight()
              self.view.layoutIfNeeded()
          }
      }

    func reloadAttachView() {
        attachView.isUserInteractionEnabled = !viewModel.shouldDisableAttachView()
        attachView.alpha = viewModel.shouldDisableAttachView() ? 0.5 : 1

        confirmView.isUserInteractionEnabled = viewModel.shouldDisableAttachView()
        confirmView.alpha = !viewModel.shouldDisableAttachView() ? 0.5 : 1
    }
}

extension ReportPictureView {

    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.layoutIfNeeded()

        var keyboardHeight = CGFloat(0.0)

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        UIView.animate(withDuration: 3) {
            self.bottomConstraint.constant = keyboardHeight + 40
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.bottomConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }
}
