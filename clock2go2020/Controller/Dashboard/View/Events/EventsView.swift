//
//  EventsView.swift
//  clock2go2020
//
//  Created by Gleb on 26.05.2021.
//

import Foundation
import UIKit


class EventsView: UIViewController {
    
    //MARk: - IBOutlets
    @IBOutlet weak var eventsTitleLabel:UILabel!
    
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmViewTitle: UILabel!
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewTitle: UILabel!
    
    @IBOutlet weak var remarkTextView:UITextView!
    
    @IBOutlet weak var selectEventView:UIView!
    @IBOutlet weak var selectEventTitleLabel:UILabel!
    
    @IBOutlet weak var iconView: UIView!
    
    @IBOutlet weak var choosedClientNameLabel:UILabel!
    
    @IBOutlet weak var remarkInputViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var counterTitleLabel:UILabel!
    
    var placeholderLabel : UILabel!
    
    weak var delegate: EventsRevachaDelegate?
    
    var isEnable = false
    var remark = ""
    var eventType:String?
    var taskId: Int?
    var characterCounter: Int = 500
    var setEventsType:[String]? = []
    
    var model: EventsViewModel?
    
    
    let loadingView = LoadingView()
    var vc: UIViewController? {
        let vc = NavigationController.shared?.getCurrentViewController()
        self.loadingView.frame = vc?.view.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        return vc
    }
    
    //MARK: - Lifecycle
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotificationCenterKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configTextView()
        configTaps()
        updateView()
        setupLocalized()
        refreshView()
    }
    
    func config(viewModel: EventsViewModel, taskId: Int) {
        self.model = viewModel
        self.model?.delegate = self
        self.taskId = taskId
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationCenterKeyboard()
    }
    
    func setupLocalized() {
        selectEventTitleLabel.text = "SELECT_AN_EVENT".localized
        eventsTitleLabel.text = "EVENTS".localized
        confirmViewTitle.text = "CONFIRM".localized
        cancelViewTitle.text = "CANCEL".localized
        counterTitleLabel.text = "max \(characterCounter)"
    }
    func updateView() {
        switch isEnable {
        case true:
            confirmView.isUserInteractionEnabled = true
            confirmView.alpha = 1
            break
        case false :
            confirmView.isUserInteractionEnabled = false
            confirmView.alpha = 0.5
            break
        }
    }
    
    
    //MARK: - Private func
    private func configUI() {
        setupUIForView(confirmView)
        setupUIForView(cancelView)
        
        remarkTextView.border(width: 1.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        remarkTextView.roundCorners(.allCorners, radius: 30.0)
        
        selectEventView.border(width: 1.5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        selectEventView.roundCorners(.allCorners, radius: 30.0)
        
        roundedView.roundCorners([.topRight, .topLeft], radius: 30.0)
        
        iconView.roundCorners([.allCorners], radius: 50)
        iconView.shadow(.zero, opacity: 0.3, radius: 5, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        iconView.border(width: 7.3, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
    }
    
    
    private func setupUIForView(_ view: UIView) {
        view.roundCorners([.allCorners], radius: 30.0)
        view.shadow(CGSize(width: 0, height: 3), opacity: 0.13, radius: 1, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }
    
    private func configTextView() {
        remarkTextView.delegate = self
        remarkTextView.addCloseToolbar()
        remarkTextView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        remarkTextView.textColor = #colorLiteral(red: 0.08235294118, green: 0.2823529412, blue: 0.462745098, alpha: 1)
        
        configTextViewPlaceholder()
    }
    
    
    private func configTextViewPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "ADD_REMARK".localized
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (remarkTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.adjustsFontSizeToFitWidth = true
        placeholderLabel.center = CGPoint(x: self.remarkTextView.bounds.midX,
                                          y: self.remarkTextView.bounds.midY)
        placeholderLabel.textColor = #colorLiteral(red: 0.08235294118, green: 0.2823529412, blue: 0.462745098, alpha: 0.5)
        placeholderLabel.isHidden = !remarkTextView.text.isEmpty
        
        remarkTextView.addSubview(placeholderLabel)
    }
    
    private func configTaps() {
        let chooseEventTap = UITapGestureRecognizer(target: self, action: #selector(chooseEventTapped))
        selectEventView.isUserInteractionEnabled = true
        selectEventView.addGestureRecognizer(chooseEventTap)
        
        let confirmTap = UITapGestureRecognizer(target: self, action: #selector(confirmTapped))
        confirmView.isUserInteractionEnabled = true
        confirmView.addGestureRecognizer(confirmTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        cancelView.isUserInteractionEnabled = true
        cancelView.addGestureRecognizer(cancelTap)
    }
    
    
    //MARK: - Actions
    @objc func chooseEventTapped() {
        self.isEnable = false
        self.updateView()
        selectEventTitleLabel.text = "SELECT_AN_EVENT".localized
        
        
        let listView = ViewSource.chooseListView()
        listView.viewModel = ChooseListViewModel(title: "SELECT_AN_EVENT".localized, data: self.model?.eventsName ?? [])
        listView.modalTransitionStyle = .crossDissolve
        listView.modalPresentationStyle = .overCurrentContext
        
        listView.choosedType = {  index , type in
            self.eventType = self.model?.eventsTypeId[index]
            
            self.selectEventTitleLabel.text = type
            if self.eventType == "-1" {
                self.counterTitleLabel.text = "min 10 / max \(self.characterCounter)"
                if !self.remark.isEmpty && self.remark.count >= 10{
                    self.isEnable = true
                    self.updateView()
                } else {
                    self.placeholderLabel.text = "ADD_REMARK".localized + " ⃰"
                }
            } else {
                self.counterTitleLabel.text = "max \(self.characterCounter)"
                self.isEnable = true
                self.updateView()
                self.placeholderLabel.text = "ADD_REMARK".localized
            }
        }
        self.present(listView, animated: true, completion: nil)
    }
    
    @objc func confirmTapped() {
        vc?.view.addSubview(loadingView)        
    }
    
    @objc func cancelTapped() {
        delegate?.showEvents()
        self.dismiss(animated: true, completion: nil)
    }
}

protocol EventsRevachaDelegate: AnyObject {
    func showEvents()
}

extension EventsView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        remark = textView.text
        print(remark)
        if textView.text.count >= 10 && self.eventType == "-1"{
            isEnable = true
            self.updateView()
        } else if textView.text.count < 10 && self.eventType == "-1" {
            isEnable = false
            self.updateView()
        }
        if self.eventType == "-1"{
            counterTitleLabel.text = "min 10 / max \(characterCounter - textView.text.count)"
        } else {
            counterTitleLabel.text = "max \(characterCounter - textView.text.count)"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= characterCounter
    }
}

extension EventsView {
    
    func addNotificationCenterKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func removeNotificationCenterKeyboard() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight = CGFloat(0.0)
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        
        UIView.animate(withDuration: 3) {
            self.remarkInputViewBottomConstraint.constant = keyboardHeight  - 80
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 1) {
            self.remarkInputViewBottomConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: Private func
    private func refreshView () {
        choosedClientNameLabel.text = self.model?.client?.taskName
        self.setEventsType = self.model?.eventsName
   
    }
}
extension EventsView: EventsViewModelDelegate {
    func shouldRefreshView() {
        self.refreshView()
    }
}
