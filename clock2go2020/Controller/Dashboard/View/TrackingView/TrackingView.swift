//
//  TrackingView.swift
//  clock2go2020
//
//  Created by Admin on 1/3/20.
//

import UIKit



protocol TrackingViewDelegate: AnyObject {
    func bituachLeumiMadeAction(_ action: BituachLeumiAdditionalAction)
    func AdditionalButtonAction(_ action: AdditionalButtonsAction)
    func shouldUpdateTimer()
}

class TrackingView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginStandardLabel: UILabel!
    
    @IBOutlet weak var timerRoundView: UIView!
    @IBOutlet weak var timerView: TimerView!
    
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var logoutStandardLabel: UILabel!
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    @IBOutlet weak var roundPauseView: UIView!
    @IBOutlet weak var roundPauseViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pauseStackViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var roundIMHereView: UIView!
    @IBOutlet weak var roundIMhereViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iMHereView: UIView!
    
    
    @IBOutlet weak var absenceView: UIView!
    @IBOutlet weak var absenceLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var pauseLabel: UILabel!
    
    @IBOutlet weak var roundDistanceView: UIView!
    @IBOutlet weak var roundDistanceViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var additionalButtonView: AdditionalButtonsView!
    @IBOutlet weak var additionalButtonsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var startTrackingView: UIView!
    @IBOutlet weak var startTrackingLabel: UILabel!
    
    @IBOutlet weak var trackingSeparatorView: UIView!
    @IBOutlet weak var startTrackingIcon: UIImageView!
    
    @IBOutlet weak var stopTrackingView: UIView!
    @IBOutlet weak var stopTrackingLabel: UILabel!
    
    @IBOutlet weak var multiReportRoundView: UIView!
    
    @IBOutlet weak var multiLoginView: UIView!
    @IBOutlet weak var multiLoginLabel: UILabel!
    
    @IBOutlet weak var multiLogoutView: UIView!
    @IBOutlet weak var multiLogoutLabel: UILabel!
    
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var eventsLabel: UILabel!
    
    @IBOutlet weak var bituachLeumiAdditionalView: BituachLeumiAdditionalView!
    var viewModel: TrackingViewModel!
    
    var loginTapped: (() -> Void)?
    var logoutTapped: (() -> Void)?
    var absenceTapped: (() -> Void)?
    var pauseTapped: (() -> Void)?
    var iMHereTapped: (() -> Void)?
    var signedReportTapped: (() -> Void)?
    
    var startTrackingTapped: (() -> Void)?
    var stopTrackingTapped: (() -> Void)?
    
    var multiLoginTapped: (() -> Void)?
    var multiLogoutTapped: (() -> Void)?
    
    var additionalButtonTapped: (() -> Void)?
    
    var tappedReturnFormService: (() -> Void)?
    var tappedExitFormService: (() -> Void)?
    
    var eventsTapped: (() -> Void)?
    
    weak var delegate: TrackingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TrackingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        bituachLeumiAdditionalView.delegate = self
        additionalButtonView.delegate = self
        
        setupUI()
        setupTaps()
        setupAdditionalButtons()
        
    }
    
    func setLocalizedStrings() {
        loginLabel.text = "LOGIN".localized
        logoutLabel.text = "LOGOUT".localized
        absenceLabel.text = "ABSCENCE".localized
        
        startTrackingLabel.text = "START_RIDE".localized
        stopTrackingLabel.text = "END_RIDE".localized
        
        multiLoginLabel.text = "MULTI_LOGIN".localized
        multiLogoutLabel.text = "MULTI_LOGOUT".localized
        
        eventsLabel.text = "EVENTS".localized
        //DispatchQueue.main.async {
        if self.viewModel.shouldDisplayBreakView(){
            self.pauseLabel.text = self.viewModel.getPauseTitle()
        }else{
            self.pauseLabel.text = "I_M_Here".localized
        }
        //        }
        
        
        
        additionalButtonView.setupValues()
        bituachLeumiAdditionalView.refreshView()
    }
    
    func setupUI() {
        for view in buttonsStackView.arrangedSubviews {
            buttonsStackView.sendSubviewToBack(view)
        }
        
        roundPauseView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        roundPauseView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        roundIMHereView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        roundIMHereView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        
        roundDistanceView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        roundDistanceView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        timerRoundView.roundCorners([.bottomLeft, .bottomRight], radius: 65)
        timerRoundView.shadow(.zero, opacity: 0.5, radius: 10, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        timerView.roundCorners([.allCorners], radius: (timerView.bounds.width + 14.0 + 4.6) / 2.0)
        timerView.shadow(CGSize(width: 0, height: 2), opacity: 0.5, radius: 2, color: #colorLiteral(red: 0.6898986694, green: 0.716962263, blue: 0.7384650849, alpha: 1))
        
        multiReportRoundView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        multiReportRoundView.shadow(CGSize(width: 0, height: 5), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }
    
    func configure(model: TrackingViewModel) {
        self.viewModel = model
        
        setLocalizedStrings()
        
        self.reloadView()
        
        
    }
    
    func reloadView() {
        loginView.isUserInteractionEnabled = !viewModel.shouldDisableLoginView()
        logoutView.isUserInteractionEnabled = !viewModel.shouldDisableLogoutView()
        absenceView.isUserInteractionEnabled = !viewModel.shouldDisableAbsenceView()
        pauseView.isUserInteractionEnabled = !viewModel.shouldDisablePauseView()
        
        eventsView.isUserInteractionEnabled = !viewModel.shouldDisableEventsView()
        
        loginView.backgroundColor = viewModel.getLoginViewBackgroundColor()
        logoutView.backgroundColor = viewModel.getLogoutViewBackgroundColor()
        absenceView.alpha = viewModel.getAlphaValueForAbsenceView()
        
        eventsView.isHidden = viewModel.shouldHideEventsView()
        
        pauseView.alpha = viewModel.getAlphaValueForPauseView()
        
        if self.viewModel.shouldDisplayBreakView(){
            self.pauseLabel.text = self.viewModel.getPauseTitle()
        }else{
            self.pauseLabel.text = "I_M_Here".localized
        }
        //        pauseLabel.text = viewModel.getPauseTitle()
        
        loginStandardLabel.text = viewModel.getStandardStartTime()
        logoutStandardLabel.text = viewModel.getStandardfinishTime()
        loginStandardLabel.isHidden = !viewModel.shouldDisplayStandards()
        logoutStandardLabel.isHidden = !viewModel.shouldDisplayStandards()
        
        roundDistanceView.isHidden = !viewModel.shouldDisplayTrackingView()
        
        startTrackingIcon.isHidden = !viewModel.shouldDisplayStartTrackingImage()
        startTrackingView.isUserInteractionEnabled = viewModel.shouldEnableStartTrackingButton()
        startTrackingView.alpha = viewModel.shouldEnableStartTrackingButton() ? 1 : 0.5
        
        trackingSeparatorView.isHidden = viewModel.shouldDisplayStartTrackingImage()
        stopTrackingView.isUserInteractionEnabled = viewModel.shouldEnableStopTrackingButton()
        stopTrackingView.alpha = viewModel.shouldEnableStopTrackingButton() ? 1 : 0.5
        
        timerView.isHidden = viewModel.shouldDisableTimerView()
        
        if viewModel.shouldShowAdditionalButtonsView() {
            additionalButtonView.isHidden = false
            additionalButtonView.setupValues()
            
            roundPauseView.isHidden = true
            roundIMHereView.isHidden = true
        } else {
            additionalButtonView.isHidden = true
            
            roundPauseView.isHidden = false
            roundIMHereView.isHidden = false
        }
        
        additionalButtonsHeight.constant = viewModel.additionalButtonsHeight()
       
        ButtonThreeVisible()
        
        multiReportRoundView.isHidden = !viewModel.shouldDisplayMultiReportView()
        
        bituachLeumiAdditionalView.isHidden = viewModel.shouldHideBituachLeumiAdditionalView()
        
        timerView.setupTimer()
       
        self.bituachLeumiAdditionalView.refreshView()
        
    }
    
    
    func ButtonThreeVisible(){
        if (viewModel.shouldDisplayAbsenceView()  && viewModel.shouldDisplayBreakView()  && viewModel.shouldDisplayImHereView()) {
            
            self.roundPauseView.isHidden = !self.viewModel.shouldDisplayRoundPauseView()
            self.pauseView.isHidden = !self.viewModel.shouldDisplayBreakView()
            self.separatorView.isHidden = !self.viewModel.shouldDisplaySeparatorView()
            self.absenceView.isHidden = !self.viewModel.shouldDisplayAbsenceView()
            self.roundPauseViewHeightConstraint.constant = self.viewModel.getPauseViewHeight()
            self.pauseStackViewHeightConstraint.constant = self.viewModel.getPauseStackViewHeight()
            self.roundIMHereView.isHidden = !self.viewModel.shouldDisplayImHereView()
            
        }else if (viewModel.shouldDisplayAbsenceView()  && viewModel.shouldDisplayBreakView()){
                    
            roundPauseView.isHidden = !viewModel.shouldDisplayRoundPauseView()
            pauseView.isHidden = !viewModel.shouldDisplayBreakView()
            separatorView.isHidden = !viewModel.shouldDisplaySeparatorView()
            absenceView.isHidden = !viewModel.shouldDisplayAbsenceView()
            roundPauseViewHeightConstraint.constant = viewModel.getPauseViewHeight()
            pauseStackViewHeightConstraint.constant = viewModel.getPauseStackViewHeight()
            roundIMHereView.isHidden = !viewModel.shouldDisplayImHereView()
            
        }else if (viewModel.shouldDisplayAbsenceView() && viewModel.shouldDisplayImHereView()){
            
            roundPauseView.isHidden = !viewModel.shouldDisplayRoundPauseView()
            pauseView.isHidden = !viewModel.shouldDisplayImHereView()
            separatorView.isHidden = false//!viewModel.shouldDisplaySeparatorView()
            absenceView.isHidden = !viewModel.shouldDisplayAbsenceView()
            roundPauseViewHeightConstraint.constant = viewModel.getImHereViewHeight()
            pauseStackViewHeightConstraint.constant = viewModel.getImHereStackViewHeight()
            roundIMHereView.isHidden = !viewModel.shouldDisplayBreakView()
            
        }else if (viewModel.shouldDisplayAbsenceView()){
            
            roundPauseView.isHidden = !viewModel.shouldDisplayRoundPauseView()
            pauseView.isHidden = !viewModel.shouldDisplayBreakView()
            separatorView.isHidden = !viewModel.shouldDisplaySeparatorView()
            absenceView.isHidden = !viewModel.shouldDisplayAbsenceView()
            roundPauseViewHeightConstraint.constant = viewModel.getPauseViewHeight()
            pauseStackViewHeightConstraint.constant = viewModel.getPauseStackViewHeight()
            roundIMHereView.isHidden = !viewModel.shouldDisplayImHereView()
            
        }else if (viewModel.shouldDisplayImHereView()){
            
            roundPauseView.isHidden = !viewModel.shouldDisplayRoundPauseView()
            pauseView.isHidden = !viewModel.shouldDisplayBreakView()
            separatorView.isHidden = !viewModel.shouldDisplaySeparatorView()
            absenceView.isHidden = !viewModel.shouldDisplayAbsenceView()
            roundPauseViewHeightConstraint.constant = viewModel.getPauseViewHeight()
            pauseStackViewHeightConstraint.constant = viewModel.getPauseStackViewHeight()
            roundIMHereView.isHidden = !viewModel.shouldDisplayImHereView()
            
        }else if (viewModel.shouldDisplayBreakView()){
            
            roundPauseView.isHidden = !viewModel.shouldDisplayRoundPauseView()
            pauseView.isHidden = !viewModel.shouldDisplayBreakView()
            separatorView.isHidden = !viewModel.shouldDisplaySeparatorView()
            absenceView.isHidden = !viewModel.shouldDisplayAbsenceView()
            roundPauseViewHeightConstraint.constant = viewModel.getPauseViewHeight()
            pauseStackViewHeightConstraint.constant = viewModel.getPauseStackViewHeight()
            roundIMHereView.isHidden = !viewModel.shouldDisplayImHereView()
            
        }else if (!viewModel.shouldDisplayAbsenceView()  && !viewModel.shouldDisplayBreakView()  && !viewModel.shouldDisplayImHereView()) {
            
            self.roundPauseView.isHidden = !self.viewModel.shouldDisplayRoundPauseView()
            self.pauseView.isHidden = !self.viewModel.shouldDisplayBreakView()
            self.separatorView.isHidden = !self.viewModel.shouldDisplaySeparatorView()
            self.absenceView.isHidden = !self.viewModel.shouldDisplayAbsenceView()
            self.roundPauseViewHeightConstraint.constant = self.viewModel.getPauseViewHeight()
            self.pauseStackViewHeightConstraint.constant = self.viewModel.getPauseStackViewHeight()
            self.roundIMHereView.isHidden = !self.viewModel.shouldDisplayImHereView()
            
        }
        
    }
    
    func setupAdditionalButtons() {
        additionalButtonView.reportsChanged = {
            self.additionalButtonTapped?()
        }
        
        additionalButtonView.tappedReturnFormService = {
            self.tappedReturnFormService?()
        }
        
        additionalButtonView.tappedExitFormService = {
            self.tappedExitFormService?()
        }
    }
    
    func setupTaps() {
        let loginTap = UITapGestureRecognizer.init(target: self, action: #selector(loginViewTapped))
        loginView.addGestureRecognizer(loginTap)
        
        let logoutTap = UITapGestureRecognizer.init(target: self, action: #selector(logoutViewTapped))
        logoutView.addGestureRecognizer(logoutTap)
        
        let absenceTap = UITapGestureRecognizer.init(target: self, action: #selector(absenceViewTapped))
        absenceView.addGestureRecognizer(absenceTap)
        
        let pauseTap = UITapGestureRecognizer.init(target: self, action: #selector(pauseViewTapped))
        pauseView.addGestureRecognizer(pauseTap)
        
        let iMHereViewTap = UITapGestureRecognizer.init(target: self, action: #selector(iMHereViewTapped))
        iMHereView.addGestureRecognizer(iMHereViewTap)
        
        
        let startTrackingTap = UITapGestureRecognizer(target: self, action: #selector(startTrackingViewTapped))
        startTrackingView.addGestureRecognizer(startTrackingTap)
        
        let stopTrackingTap = UITapGestureRecognizer(target: self, action: #selector(stopTrackingViewTapped))
        stopTrackingView.addGestureRecognizer(stopTrackingTap)
        
        let multiLoginTap = UITapGestureRecognizer(target: self, action: #selector(multiLoginViewTapped))
        multiLoginView.addGestureRecognizer(multiLoginTap)
        
        let multiLogoutTap = UITapGestureRecognizer(target: self, action: #selector(multiLogoutViewTapped))
        multiLogoutView.addGestureRecognizer(multiLogoutTap)
        
        let eventsTap = UITapGestureRecognizer(target: self, action: #selector(eventsViewTapped))
        eventsView.addGestureRecognizer(eventsTap)
    }
    
    @objc func eventsViewTapped() {
        eventsTapped?()
    }
    
    @objc func loginViewTapped() {
        loginTapped?()
    }
    
    @objc func logoutViewTapped() {
        logoutTapped?()
    }
    
    @objc func absenceViewTapped() {
        absenceTapped?()
    }
    
    @objc func iMHereViewTapped() {
        iMHereTapped?()
    }
    
    @objc func pauseViewTapped() {
        
        print("I M pause view")
        if self.viewModel.shouldDisplayBreakView(){
            print("I M pause view")
            if viewModel.shouldDisplaySignedReportView() {
                signedReportTapped?()
            } else {
                
                pauseTapped?()
            }
        }else{
            print("I M pause i m here view")
            iMHereTapped?()
        }
               
    }
    
    @objc func startTrackingViewTapped() {
        startTrackingTapped?()
    }
    
    @objc func stopTrackingViewTapped() {
        stopTrackingTapped?()
    }
    
    @objc func multiLoginViewTapped() {
        multiLoginTapped?()
    }
    
    @objc func multiLogoutViewTapped() {
        multiLogoutTapped?()
    }
    
    func callBackForReturnFromService(){
        self.additionalButtonView.viewModel.firstButtonTapped()
    }
    
    func callBackForExitFromService(){
        self.additionalButtonView.viewModel.secondButtonTapped()
    }
}

//additionl buttons view configuration
extension TrackingView {
    
    func changeSelectedTask(_ task: TaskObj?) {
        additionalButtonView.changeSelectedTask(task)
    }
}

extension TrackingView: BituachLeumiAdditionalViewDelegate {
    
    func didMakeAction(_ actionType: BituachLeumiAdditionalAction) {
        delegate?.bituachLeumiMadeAction(actionType)
    }
}

extension TrackingView: AdditionalButtonsViewDelegate {
    func didMakeActionAdditional(_ actionType: AdditionalButtonsAction) {
        delegate?.AdditionalButtonAction(actionType)
    }
    
    func shouldUpdateTimer() {
        delegate?.shouldUpdateTimer()
    }
}
