//
//  ConfirmTaskView.swift
//  clock2go2020
//
//  Created by Macbook Pro on 04.01.2020.
//

import UIKit

class ConfirmTaskView: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var closeImage: UIImageView!
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var additionalStackView: UIStackView!
    
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var finishViewTitle: UILabel!
    
    @IBOutlet weak var finishAndStartView: UIView!
    @IBOutlet weak var finishAndStartViewTitle: UILabel!
    
    @IBOutlet weak var commonStackView: UIStackView!
    
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmViewTitle: UILabel!
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewTitle: UILabel!
    
    @IBOutlet weak var commentTaskTextField: UITextField!
    @IBOutlet weak var comentTextfilend_count: UILabel!
    
    @IBOutlet weak var mustNoteTitle: UILabel!
    @IBOutlet weak var commentListView: UIView!
    @IBOutlet weak var arrowCommentListImage: UIImageView!
    @IBOutlet weak var commentListTitle: UILabel!
    
    weak var delegate: TaskConfirmViewDelegate?
    
    var viewModel: ConfirmTaskViewModel?
    var commentListType: CommentListViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setTextField()
        setLocalizedStrings()
        setupTaps()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        config()
    }
    
    // MARK: Property
    func setupUI() {
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)
        
        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        setupUIForView(confirmView)
        setupUIForView(cancelView)
        setupUIForView(finishView)
        setupUIForView(finishAndStartView)
        
        setupUIForView(commentListView)
        
        commentListView.border(width: 1.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        mustNoteTitle.isHidden = true
    }
    
    func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 30.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
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
        finishViewTitle.text = "FINISH_TASK_TITLE".localized
        finishAndStartViewTitle.text = "FINISH_AND_START_TASK_TITLE".localized
        confirmViewTitle.text = "CONFIRM".localized
        cancelViewTitle.text = "CANCEL".localized
        mustNoteTitle.text = "MUST_NOTE".localized
        commentListTitle.text = "SELECT_COMMENT".localized
    }
    
    func setViewModel(_ viewModel: ConfirmTaskViewModel) {
        self.viewModel = viewModel
    }
    
    func config() {
        guard let viewModel = self.viewModel else { return }
        
        icon.image = viewModel.getIconImage()
        iconView.backgroundColor = viewModel.getIconBackgroundColor()
        taskTitle.attributedText = viewModel.getTitleString()
        
        if let name = viewModel.getTaskNameString() {
            taskNameLabel.text = name
        } else {
            taskNameLabel.isHidden = true
        }
        
        closeImage.isHidden = !viewModel.shouldShowCloseImage()
        cancelView.isHidden = !viewModel.shouldShowCancelView()
        additionalStackView.isHidden = !viewModel.shouldShowAdditionalLogoutOptions()
        commonStackView.isHidden = viewModel.shouldShowAdditionalLogoutOptions()
        mustNoteTitle.isHidden = true
        
        print("viewModel.confirmType", viewModel.confirmType)
        
        if viewModel.shouldShowCommentField() {
            switch viewModel.confirmType {
            case .loginConfirm:
                if viewModel.mustNoteOnEntry() && viewModel.mustSelectCommentOnEntry() {
                    commentListType = CommentListViewModel(type: .listOnEntry)
                    if viewModel.isCommentSelected {
                        confirmView.isUserInteractionEnabled = true
                        confirmView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.2980392157, blue: 0.4862745098, alpha: 1)
                    } else {
                        confirmView.isUserInteractionEnabled = false
                        confirmView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    }
                    commentTaskTextField.isHidden = true
                    mustNoteTitle.isHidden = true
                    comentTextfilend_count.isHidden = true
                    commentListView.isHidden = false
                } else if viewModel.mustNoteOnEntry() && !viewModel.mustSelectCommentOnEntry() {
                    commentTaskTextField.isHidden = false
                    comentTextfilend_count.isHidden = false
                    mustNoteTitle.isHidden = false
                    commentListView.isHidden = true
                    changeCommentDields(textField: commentTaskTextField)
                    
                } else {
                    disableMustNote()
                }
                break
            case .logoutConfirm, .logoutMustNote:
                if viewModel.mustNoteOnExit() && viewModel.mustSelectCommentOnExit() {
                    commentListType = CommentListViewModel(type: .listOnExit)
                    if viewModel.isCommentSelected {
                        confirmView.isUserInteractionEnabled = true
                        confirmView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.2980392157, blue: 0.4862745098, alpha: 1)
                    } else {
                        confirmView.isUserInteractionEnabled = false
                        confirmView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    }
                    commentTaskTextField.isHidden = true
                    comentTextfilend_count.isHidden = true
                    mustNoteTitle.isHidden = true
                    commentListView.isHidden = false
                } else if viewModel.mustNoteOnExit() && !viewModel.mustSelectCommentOnExit() {
                    commentTaskTextField.isHidden = false
                    comentTextfilend_count.isHidden = false
                    // mustNoteTitle.isHidden = false
                    commentListView.isHidden = true
                    changeCommentDields(textField: commentTaskTextField)
                } else {
                    disableMustNote()
                }
                break
            default:
                commentTaskTextField.isHidden = !viewModel.shouldShowCommentField()
                comentTextfilend_count.isHidden = !viewModel.shouldShowCommentField()
                disableMustNote()
                break
            }
        } else {
            commentTaskTextField.isHidden = !viewModel.shouldShowCommentField()
            comentTextfilend_count.isHidden = !viewModel.shouldShowCommentField()
            disableMustNote()
            
            if viewModel.confirmType == .logoutConfirm{
                print(CompaniesDataManager.shared.getAppReportCompletionNoteExit())
                if viewModel.mustNoteOnExit() {
                    finishView.isUserInteractionEnabled = false
                    finishView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    
                    finishAndStartView.isUserInteractionEnabled = false
                    finishAndStartView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    
                    mustNoteTitle.isHidden = false
                    
                    commentTaskTextField.isHidden = false
                    comentTextfilend_count.isHidden = false
                    
                    changeCommentDields(textField: commentTaskTextField)
                }else{
                    finishView.isUserInteractionEnabled = true
                    finishView.backgroundColor = #colorLiteral(red: 0.01960784314, green: 0.4392156863, blue: 0.7529411765, alpha: 1)
                    
                    finishAndStartView.isUserInteractionEnabled = true
                    finishAndStartView.backgroundColor = #colorLiteral(red: 0.8, green: 0.8862745098, blue: 0.9529411765, alpha: 1)
                    
                    mustNoteTitle.isHidden = true
                    
                    commentTaskTextField.isHidden = false
                    comentTextfilend_count.isHidden = false
                }
                
                
            }
            
        }
        self.view.layoutIfNeeded()
    }
    
    func disableMustNote() {
        mustNoteTitle.isHidden = true
        commentListView.isHidden = true
        confirmView.isUserInteractionEnabled = true
        confirmView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.2980392157, blue: 0.4862745098, alpha: 1)
        self.view.layoutIfNeeded()
    }
    
    func setupTaps() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        backgroundView.addGestureRecognizer(tap)
        
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        confirmView.addGestureRecognizer(confirmTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.addGestureRecognizer(cancelTap)
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        closeImage.addGestureRecognizer(closeTap)
        
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(logoutConfirmTapped))
        finishView.addGestureRecognizer(logoutTap)
        
        let logoutAndLoginTap = UITapGestureRecognizer(target: self, action: #selector(logoutAndLoginConfirmTapped))
        finishAndStartView.addGestureRecognizer(logoutAndLoginTap)
        
        let selectCommentTap = UITapGestureRecognizer(target: self, action: #selector(selectComment))
        commentListView.addGestureRecognizer(selectCommentTap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmTapped() {
        dismissView()
        guard let viewModel = self.viewModel else { return }
        delegate?.userDidTapConfirm(viewModel.getConfirmActionType(), viewModel.task, viewModel.additional, viewModel.remark, viewModel.event)
    }
    
    @objc func cancelTapped() {
        dismissView()
        //        delegate?.userDidTapConfirm(.cancel, nil, nil, nil, nil)
    }
    
    @objc func logoutConfirmTapped() {
//        dismissView()
//        delegate?.userDidTapConfirm(.logout, viewModel?.task, nil, nil, nil)
        dismissView()
        guard let viewModel = self.viewModel else { return }
        print("getConfirmActionType", viewModel.getConfirmActionType())
        print("task", viewModel.task)
        print("additional", viewModel.additional)
        print("remark", viewModel.remark)
        print("event", viewModel.event)
        delegate?.userDidTapConfirm(viewModel.getConfirmActionType(), viewModel.task, viewModel.additional, viewModel.remark, viewModel.event)
    }
    
    @objc func logoutAndLoginConfirmTapped() {
        dismissView()
        delegate?.userDidTapConfirm(.logoutAndLogin, viewModel?.task, nil, nil, nil)
    }
    
    @objc func selectComment() {
        let vc = ViewSource.commentListScreen()
        vc.config(model: commentListType!)
        vc.selectedComment = { [weak self] (comment) in
            self?.commentListTitle.text = comment
            self?.confirmView.isUserInteractionEnabled = true
            self?.confirmView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.2980392157, blue: 0.4862745098, alpha: 1)
            self?.viewModel?.isCommentSelected(select: true)
            self?.viewModel?.setRemaark(comment)
            vc.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
    }
}

protocol TaskConfirmViewDelegate: NSObjectProtocol {
    func userDidTapConfirm(_ type: ConfirmActionType, _ task: TaskObj?, _ aditionalButton: AddonButtonObj?, _ remark: String?, _ event: RevachaEventObj?)
}

extension ConfirmTaskView: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//            return false
//        }
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
//        let count = textFieldText.count - substringToReplace.count + string.count
//        if viewModel?.event != nil {
//            return count <= 500
//        }
//        return count <= 30
//    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(
            in: textRange,
            with: string
        )
        
        let characterCount = updatedText.count
        
        // Maximum 255 characters
        if characterCount > 255 {
            showNoteLimitError()
            return false
        }
        
        updateNoteCharacterCount(characterCount)
        
        return true
    }
    
    private func showNoteLimitError() {
//        showAlert(
//            title: "Note Limit",
//            message: "Notes cannot exceed 255 characters."
//        )
        print("Notes cannot exceed 255 characters.")
    }
    
    private func updateNoteCharacterCount(_ count: Int) {
        
        self.comentTextfilend_count.text = "\(count)/255"
        
        switch count {
        case 0...200:
            self.comentTextfilend_count.textColor = .black
            
        case 201...248:
            self.comentTextfilend_count.textColor = .orange
            
        default:
            // 249...255
            self.comentTextfilend_count.textColor = .red
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel?.setRemaark(textField.text)
        changeCommentDields(textField: textField)
        print("count:", textField.text?.count)
        
        if let str = textField.text, str.count > 0{
            
        }else{
            self.comentTextfilend_count.text = "0/250"
        }
    }
    
    func changeCommentDields(textField: UITextField) {
        if viewModel!.mustNoteOnEntry() || ((viewModel?.mustNoteOnExit()) != nil) {
            if textField.text == nil || textField.text == "" {
                confirmView.isUserInteractionEnabled = false
                confirmView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                
                finishView.isUserInteractionEnabled = false
                finishView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//                
                finishAndStartView.isUserInteractionEnabled = false
                finishAndStartView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                
                mustNoteTitle.isHidden = false
            } else {
                confirmView.isUserInteractionEnabled = true
                confirmView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.2980392157, blue: 0.4862745098, alpha: 1)
                
                finishView.isUserInteractionEnabled = true
                finishView.backgroundColor = #colorLiteral(red: 0.01960784314, green: 0.4392156863, blue: 0.7529411765, alpha: 1)
//                
                finishAndStartView.isUserInteractionEnabled = true
                finishAndStartView.backgroundColor = #colorLiteral(red: 0.8, green: 0.8862745098, blue: 0.9529411765, alpha: 1)
                
                mustNoteTitle.isHidden = true
            }
        } else {
            confirmView.isUserInteractionEnabled = true
            confirmView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.2980392157, blue: 0.4862745098, alpha: 1)
            
            finishView.isUserInteractionEnabled = true
            finishView.backgroundColor = #colorLiteral(red: 0.01960784314, green: 0.4392156863, blue: 0.7529411765, alpha: 1)
//            
            finishAndStartView.isUserInteractionEnabled = true
            finishAndStartView.backgroundColor = #colorLiteral(red: 0.8, green: 0.8862745098, blue: 0.9529411765, alpha: 1)
            
            mustNoteTitle.isHidden = true
        }
        self.view.layoutIfNeeded()
    }
}

extension ConfirmTaskView {
    
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
