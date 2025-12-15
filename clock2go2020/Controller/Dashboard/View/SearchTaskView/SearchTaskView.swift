//
//  SearchTaskView.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 25.08.2022.
//

import UIKit

protocol SearchTaskViewDelegate: AnyObject {
    func didFinishSearching(_ task: TaskObj?, error: ErrorObject?)
}

class SearchTaskView: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    private let viewModel: SearchTaskViewModel = SearchTaskViewModel()
    
    weak var delegate: SearchTaskViewDelegate?
    private let loadingView = LoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showContent()
    }
    
    private func prepareUI() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideContent))
        backgroundView.addGestureRecognizer(tapGesture)
        
        backgroundView.alpha = 0.0
        popupView.alpha = 0.0
        closeImageView.alpha = 0.0
        
        confirmView.roundCorners([.allCorners], radius: 30.0)
        confirmView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        cancelView.roundCorners([.allCorners], radius: 30.0)
        cancelView.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 3, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        titleLabel.text = viewModel.titleString
        confirmLabel.text = viewModel.confirmButtonTitle
        cancelLabel.text = viewModel.cancelButtonTitle
        keyLabel.text = viewModel.insuredIdString
        
        popupView.roundCorners([.allCorners], radius: 30.0)
        popupView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        textField.keyboardType = .numberPad
        textField.becomeFirstResponder()
        textField.delegate = self
        
        loadingView.frame = view.frame
        loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        updateUI()
    }
    
    private func updateUI() {
        confirmView.alpha = viewModel.searchButtonAlpha
        confirmButton.isEnabled = viewModel.searchButtonEnabled
    }
    
    private func showContent() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.5
            self.popupView.alpha = 1.0
            self.closeImageView.alpha = 1.0
        }
    }
    
    @objc private func hideContent() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.0
            self.popupView.alpha = 0.0
            self.closeImageView.alpha = 0.0
        } completion: { success in
            self.dismiss(animated: false)
        }

    }
    
    func showErrorView(message: String?, errorCode: Int?) {
        let vc = ViewSource.errorView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.viewModel = ErrorViewModel(title: String(errorCode ?? 0), message: message)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        hideContent()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        self.textField.resignFirstResponder()
        view.addSubview(loadingView)
        viewModel.searchTask { [weak self] task, error in
            self?.loadingView.removeFromSuperview()
            
            if let err = error {
                let message = String(format: "Patient_not_found".localized)
                self?.showErrorView(message: message, errorCode: nil)
                return
            }
            
            if let task = task {
                AdditionalTasksManager.saveTask(task)
            }
            self?.dismiss(animated: false, completion: {
                if let task = task {
                    var tempTask = task
                    let cleaned = task.taskName.replacingOccurrences(of: "[0-9\\-]", with: "", options: .regularExpression)
                    tempTask.taskName = task.taskName//cleaned + " - " + task.taskId
                    self?.delegate?.didFinishSearching(tempTask, error: error)
                }
            })
            
            return
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        hideContent()
    }
}

extension SearchTaskView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else { return true }
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        guard viewModel.canEnterMore(updatedText) else { return false }
        
        viewModel.didChangeSearchString(updatedText)
        updateUI()
        return true
    }
}
