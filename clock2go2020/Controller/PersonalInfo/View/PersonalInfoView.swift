//
//  PersonalInfoView.swift
//  clock2go2020
//
//  Created by MacBookPro on 1/23/20.
//

import UIKit

class PersonalInfoView: UIView {

    // MARK: Outlets
    @IBOutlet var     contentView: UIView!
    @IBOutlet var     userPhotoView: UIView!
    @IBOutlet weak var userPhotoUIImage: UIImageView!
    @IBOutlet weak var addUserPhotoButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var invalidEmailTitle: UILabel!
    @IBOutlet weak var positionTitle: UILabel!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    weak var delegate: PersonalInfoViewDelegate?

    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("PersonalInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setupImageUI()
        setupLocalized()
        setupTextFieldsUI()
        setupButtonsUI()
        reloadInvalidEmailTitle()
    }

    // MARK: Property

    func setupUI() {
        userPhotoView.roundCorners([.bottomLeft, .bottomRight], radius: 74.0)
        userPhotoView.shadow(CGSize(width: 0.5, height: 5), opacity: 0.5, radius: 5, color: #colorLiteral(red: 0.06274509804, green: 0.2823529412, blue: 0.462745098, alpha: 1))

        userPhotoUIImage.image = getImage()
    }

    func getImage() -> UIImage? {
        var image = UIImage(named: "surface1")

        if let imageData = UserDefaultsManager.image {
            image = UIImage(data: imageData)
        }

        return image
    }

    func setupImageUI() {
        userPhotoUIImage.border(width: 3, color: #colorLiteral(red: 0.06274509804, green: 0.2823529412, blue: 0.462745098, alpha: 1))
        userPhotoUIImage.roundCorners([.allCorners], radius: 40.0)
    }

    func setupLocalized() {
        userNameLabel.text = CompaniesDataManager.shared.getEmployeeName()

        nameTitle.text = "WORKER_NAME".localized
        emailTitle.text = "EMAIL_ADDRESS".localized
        positionTitle.text = "POSITION".localized
        invalidEmailTitle.text = "INVALID_EMAIL_FORMAT".localized

        saveButton.setTitle("SAVE".localized, for: .normal)
    }

    func setupTextFieldsUI() {
        // Name Text Field
        setupTextFieldUI(nameTextField, rightImageName: "user15")
        nameTextField.text = CompaniesDataManager.shared.getEmployeeName()

        // eMail Text Field
        setupTextFieldUI(emailTextField, rightImageName: "mail")
        emailTextField.text = CompaniesDataManager.shared.getEmployeeEmail()
        emailTextField.delegate = self

        // position Text Field
        setupTextFieldUI(positionTextField, rightImageName: "portfolio")
    }

    func setupTextFieldUI(_ textField: UITextField, rightImageName: String) {
        textField.roundCorners([.allCorners], radius: 30.0)
        textField.addCloseToolbar()

        textField.border(width: 1, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        textField.borderStyle = .none
        textField.backgroundColor = .clear

        textField.setPadding(rightImage: UIImage(named: rightImageName), rightPadding: 60)
    }

    func setupButtonsUI() {
        saveButton.roundCorners([.allCorners], radius: 30)
        reloadSaveButton()

        addUserPhotoButton.roundCorners([.bottomLeft, .topLeft], radius: 25.3)
    }

    func reloadInvalidEmailTitle() {
        if (emailTextField.text ?? "").count == 0 {
            invalidEmailTitle.isHidden = true
            return
        }
        invalidEmailTitle.isHidden = emailTextField.text?.isValidEmail() ?? true
    }

    func reloadSaveButton() {
        saveButton.alpha = !(emailTextField.text?.isValidEmail() ?? true) ? 0.75 : 1
        saveButton.isUserInteractionEnabled = emailTextField.text?.isValidEmail() ?? true
    }

    @IBAction func uploadImageAction(_ sender: Any) {
        self.showAttachConfirmView()
    }

    @objc func showAttachConfirmView() {
        let vc = ViewSource.attachConfirmView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.shouldCompressImage = false
        vc.allowEditting = true
        vc.attachedFile = { media in
            self.userPhotoUIImage.image = media.image
            UserDefaultsManager.image = media.data
        }
        NavigationController.shared?.present(vc, animated: true, completion: nil)
    }

    @IBAction func saveAction(_ sender: Any) {
        guard emailTextField.text?.isValidEmail() ?? true else {
            self.reloadInvalidEmailTitle()
            self.setupButtonsUI()
            return
        }

        guard let name = nameTextField.text, let email = emailTextField.text else { return }

        delegate?.userDidTapSave(name, email)
    }

}

extension PersonalInfoView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        setupButtonsUI()
        reloadInvalidEmailTitle()
    }
}

protocol PersonalInfoViewDelegate: NSObjectProtocol {
    func userDidTapSave(_ name: String, _ email: String)
}
