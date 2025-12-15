//
//  RequestCompletionView.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 16.09.2022.
//

import UIKit

class RequestCompletionView: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var topIndicatorView: UIView!
    @IBOutlet weak var topIndicatorImageView: UIImageView!
    @IBOutlet weak var loginSuccessTitle: UILabel!
    @IBOutlet weak var completionHeaderLabel: UILabel!
    @IBOutlet weak var completionAdditionalLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeErrorLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var noteErrorLabel: UILabel!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTitle: UILabel!
    @IBOutlet weak var roundedViewVerticalPosition: NSLayoutConstraint!
    
    private let loadingView = LoadingView()
//    var vc: UIViewController? {
//        let vc = NavigationController.shared?.getCurrentViewController()
//        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
//        return vc
//    }

    
    var viewModel: RequestCompletionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
        
        viewModel.delegate = self

        prepareUI()
    }
    
    private func refreshUI() {
        loginSuccessTitle.text = viewModel.successLoginString
        completionHeaderLabel.text = viewModel.completionHeaderString
        completionAdditionalLabel.text = viewModel.completionAdditionalString
        timeLabel.text = viewModel.timeString
        confirmTitle.text = viewModel.confirmButtonTitle
        cancelTitle.text = viewModel.cancelButtonTitle
        timeErrorLabel.text = viewModel.timeErrorString
        noteErrorLabel.text = viewModel.noteErrorString
        
        confirmView.alpha = viewModel.confirmButtonOpacity
        confirmButton.isEnabled = viewModel.confirmButtonEnabled
        
        print("\n\nREFRESH UI\n\n")
    }
    
    private func prepareUI() {
        roundedView.roundCorners(.allCorners, radius: 30.0)

        topIndicatorView.roundCorners(.allCorners, radius: topIndicatorView.frame.width / 2.0)
        topIndicatorView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        topIndicatorView.border(width: 3.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

        timeView.roundCorners(.allCorners, radius: timeView.frame.height / 2.0)
        timeView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        timeView.border(width: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        cancelView.roundCorners([.allCorners], radius: 30.0)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        confirmView.roundCorners([.allCorners], radius: 30.0)
        confirmView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        loadingView.frame = UIScreen.main.bounds
                
        refreshUI()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showTimePickerAction(_ sender: Any) {
        view.endEditing(true)
        let vc = ViewSource.datePickerView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.config(isDate: false, maxDate: nil)
        vc.selectedValue = { [weak self] value in
            self?.viewModel.changeTime(value)
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func comfirmAction(_ sender: Any) {
        view.endEditing(true)
        view.addSubview(loadingView)
        viewModel.confirmAction { [weak self] in
            self?.loadingView.removeFromSuperview()
            self?.dismiss(animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RequestCompletionView: UITextFieldDelegate {
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as? Double {
            let difference = keyboardFrame.height - ((UIScreen.main.bounds.height / 2.0) - 261.0)
            if difference > 0.0 {
                roundedViewVerticalPosition.constant = -difference
                UIView.animate(withDuration: animationDuration) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }

    @objc func keyboardWillDisappear(_ notification: Notification) {
        if let animationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as? Double {
            self.roundedViewVerticalPosition.constant = 0.0
            UIView.animate(withDuration: animationDuration) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else { return true }
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        return viewModel.canChangeNote(updatedText)
    }
}

extension RequestCompletionView: RequestCompletionViewModelDelegate {
    
    func shouldRefreshView() {
        refreshUI()
    }
}
