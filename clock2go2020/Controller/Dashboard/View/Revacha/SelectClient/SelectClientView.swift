//
//  SelectClientView.swift
//  clock2go2020
//
//  Created by Svitlana Davydiuk on 14.08.2020.
//

import UIKit

class SelectClientView: UIView {
    
    
    @IBOutlet weak var view_mainBG: UIView!
    
    @IBOutlet weak var view_revechaButton: UIView!
    @IBOutlet weak var view_holocaust: UIView!
    @IBOutlet weak var view_holocustSubOption: UIView!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var treatmentStackView: UIStackView!
    @IBOutlet weak var treatmentCheckButton: UIButton!
    @IBOutlet weak var treatmentTitle: UILabel!
    
    @IBOutlet weak var trainingStackView: UIStackView!
    @IBOutlet weak var trainingCheckButton: UIButton!
    @IBOutlet weak var trainingTitle: UILabel!
    
    @IBOutlet weak var groupTrainingStackView: UIStackView!
    @IBOutlet weak var groupTrainingCheckButton: UIButton!
    @IBOutlet weak var groupTrainingTitle: UILabel!
    
    @IBOutlet weak var OfficeTreatmentStackView: UIStackView!
    @IBOutlet weak var OfficeTreatmentCheckButton: UIButton!
    @IBOutlet weak var OfficeTreatmentTitle: UILabel!
    
    @IBOutlet weak var OnSiteTreatmentStackView: UIStackView!
    @IBOutlet weak var OnSiteTreatmentCheckButton: UIButton!
    @IBOutlet weak var OnSiteTreatmentTitle: UILabel!
    
    @IBOutlet weak var groupTreatmentStackView: UIStackView!
    @IBOutlet weak var groupTreatmentCheckButton: UIButton!
    @IBOutlet weak var groupTreatmentTitle: UILabel!
    
    @IBOutlet weak var selectClientView: UIView!
    @IBOutlet weak var selectClientLabel: UILabel!
    
    @IBOutlet weak var selectEventView: UIView!
    @IBOutlet weak var selectEventLabel: UILabel!
    
    
    @IBOutlet weak var lbl_indivisual: UILabel!
    @IBOutlet weak var lbl_group: UILabel!
    @IBOutlet weak var lbl_projective: UILabel!
    @IBOutlet weak var lbl_medical: UILabel!
    @IBOutlet weak var btn_indivisual: UIButton!
    @IBOutlet weak var btn_group: UIButton!
    @IBOutlet weak var btn_projective: UIButton!
    @IBOutlet weak var btn_medical: UIButton!
    
    @IBOutlet weak var stack_individual: UIStackView!
    @IBOutlet weak var stack_group: UIStackView!
    @IBOutlet weak var stack_projective: UIStackView!
    @IBOutlet weak var stack_medical: UIStackView!
    
    @IBOutlet weak var view_selectTheraphy: UIView!
    @IBOutlet weak var lbl_theraphyTitle: UILabel!
    
    
    
    
    var viewModel = SelectClientViewModel()
    
    var selectClientTapped: ((_ type: Int) -> (Void))?
    var selectEventTapped: ((_ type: Int) -> (Void))?
    var selectTrnsTypeTapped: ((_ type: Int) -> (Void))?
    var selectTheraphyTypeTapped: ((_ type: Int) -> (Void))?
    
    var trnsType = 1
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SelectClientView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        setLocalizedStrings()
        setupUI()
        setupTaps()
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload),
                                               name: NSNotification.Name(rawValue: "updateTrsType"), object: nil)
    }
    
    @objc func shouldReload() {
        if CompaniesDataManager.shared.isRevacha(){
            viewModel.type = .treatment
        }else{
            viewModel.type = .officeTreatment
        }
    }
    
    func setLocalizedStrings() {
        treatmentTitle.text     = "TREATMENT".localized
        trainingTitle.text      = "EVENT_TRAINING".localized
        groupTrainingTitle.text = "GENERAL_TRAINING".localized
        
        OfficeTreatmentTitle.text      = "Clinic_treatment".localized
        OnSiteTreatmentTitle.text      = "On_site_treatment".localized
        groupTreatmentTitle.text       = "Online".localized
        
        self.lbl_indivisual.text      = "Individual".localized
        self.lbl_group.text           = "Group".localized
        self.lbl_projective.text      = "Projective".localized
        self.lbl_medical.text         = "Medical".localized
        
        if UserDefaultsManager.appleLanguagesNew.first == "he" {
            groupTrainingStackView.addArrangedSubview(groupTrainingStackView.subviews[0])
            trainingStackView.addArrangedSubview(trainingStackView.subviews[0])
            treatmentStackView.addArrangedSubview(treatmentStackView.subviews[0])
            
            OfficeTreatmentStackView.addArrangedSubview(OfficeTreatmentStackView.subviews[0])
            OnSiteTreatmentStackView.addArrangedSubview(OnSiteTreatmentStackView.subviews[0])
            groupTreatmentStackView.addArrangedSubview(groupTreatmentStackView.subviews[0])
            
            stack_individual.addArrangedSubview(stack_individual.subviews[0])
            stack_group.addArrangedSubview(stack_group.subviews[0])
            stack_projective.addArrangedSubview(stack_projective.subviews[0])
            stack_medical.addArrangedSubview(stack_medical.subviews[0])
            
        } else {
            groupTrainingStackView.addArrangedSubview(groupTrainingStackView.subviews[1])
            trainingStackView.addArrangedSubview(trainingStackView.subviews[1])
            treatmentStackView.addArrangedSubview(treatmentStackView.subviews[1])
            
            OfficeTreatmentStackView.addArrangedSubview(OfficeTreatmentStackView.subviews[1])
            OnSiteTreatmentStackView.addArrangedSubview(OnSiteTreatmentStackView.subviews[1])
            groupTreatmentStackView.addArrangedSubview(groupTreatmentStackView.subviews[1])
            
            stack_individual.addArrangedSubview(stack_individual.subviews[1])
            stack_group.addArrangedSubview(stack_group.subviews[1])
            stack_projective.addArrangedSubview(stack_projective.subviews[1])
            stack_medical.addArrangedSubview(stack_medical.subviews[1])
        }
    }
    
    func setupUI() {
        selectClientView.roundCorners(.allCorners, radius: 25)
        selectClientView.border(width: 0.7, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))

        selectEventView.roundCorners(.allCorners, radius: 25)
        selectEventView.border(width: 0.7, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        
        self.view_selectTheraphy.roundCorners(.allCorners, radius: 25)
        self.view_selectTheraphy.border(width: 0.7, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
    }
    
    fileprivate func disableClientButton() {
        selectClientView.isUserInteractionEnabled = false
        selectClientView.alpha = 0.5
    }
    
    fileprivate func disableEventButton() {
        selectEventView.isUserInteractionEnabled = false
        selectEventView.alpha = 0.5
    }
    
    fileprivate func enableClientButton() {
        selectClientView.isUserInteractionEnabled = true
        selectClientView.alpha = 1.0
    }
    
    fileprivate func enableEventButton() {
        selectEventView.isUserInteractionEnabled = true
        selectEventView.alpha = 1.0
    }
    
    func reloadView() {
        if viewModel.needRoundCorners {
            self.view_mainBG.roundCorners([.bottomLeft, .bottomRight], radius: 25)
            self.view_mainBG.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 1))
        }
        
        if CompaniesDataManager.shared.isRevacha(){
            self.view_holocaust.isHidden = true
            self.view_holocustSubOption.isHidden = true
            self.view_revechaButton.isHidden = false
            self.selectEventView.isHidden = false
            self.view_selectTheraphy.isHidden = true
        }else{
            self.view_holocaust.isHidden = false
            self.view_holocustSubOption.isHidden = true
            self.view_revechaButton.isHidden = true
            self.selectEventView.isHidden = true
            self.view_selectTheraphy.isHidden = false
        }

        treatmentCheckButton.setImage(viewModel.getTreatmentImage(), for: .normal)
        trainingCheckButton.setImage(viewModel.getTrainingImage(), for: .normal)
        groupTrainingCheckButton.setImage(viewModel.getGroupTrainingImage(), for: .normal)
        
        switch viewModel.isLastReportLogin {
        case true:
            selectClientLabel.text = DashboardViewModel().getChooseTaskTitle()
            break
        case false:
            selectClientLabel.text = "SELECT_CLIENT".localized
            break
        }
        
        selectEventLabel.text = DashboardViewModel().getChooseEventTitle()
        
//        UserDefaultsManager.holocustLastTheraphyType = DashboardViewModel().getChooseTaskTitle().1
//        print("UserDefaultsManager.holocustLastTheraphyType", UserDefaultsManager.holocustLastTheraphyType)
        self.lbl_theraphyTitle.text = viewModel.getTheraphyTitle()
        
        if viewModel.type.shouldDisableSelectClientView() {
            disableClientButton()
            disableEventButton()
        } else {
            if !self.viewModel.shouldDisableLoginView() {
                disableClientButton()
            } else {
                enableClientButton()
                enableEventButton()
            }
        }
        
        if CompaniesDataManager.shared.isRevacha(){
            switch UserDefaultsManager.revachaLastLoginType {
            case 1:
                viewModel.type = .treatment
            case 2:
                viewModel.type = .training
            case 3:
                viewModel.type = .generalTraining
            default:
                viewModel.type = .treatment
            }
        }else{
            switch UserDefaultsManager.holocustLastLoginType {
            case 4:
                viewModel.type = .onSiteTreatment
            case 5:
                viewModel.type = .groupTreatment
            case 6:
                viewModel.type = .officeTreatment
            default:
                viewModel.type = .officeTreatment
            }
        }
        
        
        if !viewModel.isLastReportLogin && DashboardViewModel().getChooseTaskTitle() == "" {
            if CompaniesDataManager.shared.isRevacha(){
                viewModel.type = .treatment
            }else{
                viewModel.type = .officeTreatment
            }
        }
        
        treatmentCheckButton.isEnabled     = self.viewModel.shouldDisableLoginView()
        trainingCheckButton.isEnabled      = self.viewModel.shouldDisableLoginView()
        groupTrainingCheckButton.isEnabled = self.viewModel.shouldDisableLoginView()
        
        OfficeTreatmentCheckButton.setImage(viewModel.unselectedImage, for: .normal)
        OnSiteTreatmentCheckButton.setImage(viewModel.unselectedImage, for: .normal)
        groupTreatmentCheckButton.setImage(viewModel.unselectedImage, for: .normal)
        
        if self.viewModel.type == .officeTreatment{
            OfficeTreatmentCheckButton.setImage(viewModel.selectedImage, for: .normal)
        }else if self.viewModel.type == .onSiteTreatment{
            OnSiteTreatmentCheckButton.setImage(viewModel.selectedImage, for: .normal)
        }else if self.viewModel.type == .groupTreatment{
            groupTreatmentCheckButton.setImage(viewModel.selectedImage, for: .normal)
        }else{
            print("self.type-----", self.viewModel.type)
        }
        
        self.groupTreatmentCheckButton.isEnabled = self.viewModel.getOnlineOptionEnable()
        self.OnSiteTreatmentCheckButton.isEnabled = self.viewModel.getOnSiteOptionEnable()
        self.OfficeTreatmentCheckButton.isEnabled = self.viewModel.getOfficeOptionEnable()
        
//        self.groupTreatmentCheckButton.isUserInteractionEnabled = self.viewModel.getOnlineOptionEnable()
//        self.OnSiteTreatmentCheckButton.isUserInteractionEnabled = self.viewModel.getOnSiteOptionEnable()
//        self.OfficeTreatmentCheckButton.isUserInteractionEnabled = self.viewModel.getOfficeOptionEnable()
    }
    
    func setupTaps() {
        let selectClientTap = UITapGestureRecognizer(target: self, action: #selector(showClientSelection))
        selectClientView.addGestureRecognizer(selectClientTap)
        
        let selectEventTap = UITapGestureRecognizer(target: self, action: #selector(showEventSelection))
        selectEventView.addGestureRecognizer(selectEventTap)
        
        let selectTheraphyTap = UITapGestureRecognizer(target: self, action: #selector(showTheraphySelection))
        self.view_selectTheraphy.addGestureRecognizer(selectTheraphyTap)
    }
    
    @objc func showClientSelection() {
        if CompaniesDataManager.shared.isRevacha(){
            selectClientTapped?(trnsType)
        }else {
            if UserDefaultsManager.holocustLastTheraphyType == 0{
                self.showErrorView(title: nil, message: "Please_select_therapy_type".localized)
            }else{
                selectClientTapped?(trnsType)
            }
        }
    }
    
    func showErrorView(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve
        NavigationController.shared?.present(alertController, animated: true, completion: nil)
    }
    
    func disableReportTypeTaskTypeTreantmentType(isDisable: Bool){
//        print("isDisable: \(isDisable)")
        if isDisable{
            self.view_holocaust.alpha = 0.5
            
            self.OfficeTreatmentCheckButton.isEnabled = false
            self.OnSiteTreatmentCheckButton.isEnabled = false
            self.groupTreatmentCheckButton.isEnabled = false
            
            self.OfficeTreatmentCheckButton.isUserInteractionEnabled = false
            self.OnSiteTreatmentCheckButton.isUserInteractionEnabled = false
            self.groupTreatmentCheckButton.isUserInteractionEnabled = false
            
            self.view_selectTheraphy.alpha = 0.5
            self.view_selectTheraphy.isUserInteractionEnabled = false
            
            self.selectClientView.alpha = 0.5
            self.selectClientView.isUserInteractionEnabled = false
            
        }else{
            self.view_holocaust.alpha = 1.0
            self.OfficeTreatmentCheckButton.isEnabled = true
            self.OnSiteTreatmentCheckButton.isEnabled = true
            self.groupTreatmentCheckButton.isEnabled = true
            
            self.OfficeTreatmentCheckButton.isUserInteractionEnabled = true
            self.OnSiteTreatmentCheckButton.isUserInteractionEnabled = true
            self.groupTreatmentCheckButton.isUserInteractionEnabled = true
            
            self.view_selectTheraphy.alpha = 1.0
            self.view_selectTheraphy.isUserInteractionEnabled = true
            
            self.selectClientView.alpha = 1.0
            self.selectClientView.isUserInteractionEnabled = true
        }
    }
    
    @objc func showEventSelection() {
        selectEventTapped?(trnsType)
    }
    
    @objc func showTheraphySelection() {
        selectTheraphyTypeTapped?(trnsType)
    }
    
    @IBAction func treatmentSelection(_ sender: Any) {
        viewModel.type = .treatment
        trnsType = 1
        UserDefaultsManager.revachaLastLoginType = 1
        selectTrnsTypeTapped?(trnsType)
        reloadView()
    }
    
    @IBAction func trainingSelection(_ sender: Any) {
        viewModel.type = .training
        trnsType = 2
        UserDefaultsManager.revachaLastLoginType = 2
        selectTrnsTypeTapped?(trnsType)
        reloadView()
    }
    
    @IBAction func groupTrainingSelection(_ sender: Any) {
        viewModel.type = .generalTraining
        trnsType = 3
        UserDefaultsManager.revachaLastLoginType = 3
        selectTrnsTypeTapped?(trnsType)
        reloadView()
    }
    
    @IBAction func OfficeTreatmentSelection(_ sender: Any) {
        viewModel.type = .officeTreatment
        trnsType = 6
        UserDefaultsManager.holocustLastLoginType = 6
        UserDefaultsManager.holocustLastTheraphyType = 0
        selectTrnsTypeTapped?(trnsType)
        reloadView()
        
    }
    
    @IBAction func OnSiteTreatmentSelection(_ sender: Any) {
        viewModel.type = .onSiteTreatment
        trnsType = 4
        UserDefaultsManager.holocustLastLoginType = 4
        UserDefaultsManager.holocustLastTheraphyType = 0
        selectTrnsTypeTapped?(trnsType)
        reloadView()
        
    }
    
    @IBAction func groupTreatmentSelection(_ sender: Any) {
        viewModel.type = .groupTreatment
        trnsType = 5
        UserDefaultsManager.holocustLastLoginType = 5
        UserDefaultsManager.holocustLastTheraphyType = 0
        selectTrnsTypeTapped?(trnsType)
        reloadView()
    }
    
    
    @IBAction func clickHolocustSuboption(_ sender: UIButton) {

    }
    
    private func clientList() {
        let vc = ViewSource.taskListScreen()
        vc.viewModel = TaskListViewModel(showAddTask: false)
        vc.delegate = self
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        NavigationController.shared?.present(vc, animated: true)
    }
    
    func updateChooseTaskTitle(task: TaskObj?) {
        self.selectClientLabel.text = task?.taskName
    }
}
// MARK: - ChooseTaskDelegate
extension SelectClientView: ChooseTaskDelegate {
    func userDidSelectTask(_ task: TaskObj?) {
        self.updateChooseTaskTitle(task: task)
    }
}
