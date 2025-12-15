//
//  WeeklyScheduleViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 09.08.2022.
//

import UIKit

protocol WeeklyScheduleViewModelDelegate: AnyObject {
    func didStartLoading()
    func didLoadData(_ viewModels: [WeeklyScheduleCellViewModel])
    func didFinishLoading()
}

class WeeklyScheduleViewModel {
    
    private(set) var cellViewModels: [WeeklyScheduleCellViewModel] = []
    let sectionHeaderViewModel: WeeklyScheduleSectionViewModel = WeeklyScheduleSectionViewModel()
    weak var delegate: WeeklyScheduleViewModelDelegate?
    private var weekType: ScheduleWeekType = .current
    let previousButtonTitle: String = "WEEK_SCHEDULE_PREVIOUS_BUTTON_TITLE".localized
    let currentButtonTitle: String = "WEEK_SCHEDULE_CURRENT_BUTTON_TITLE".localized
    let nextButtonTitle: String = "WEEK_SCHEDULE_NEXT_BUTTON_TITLE".localized
    private(set) var titleString: String = ""
    
    private(set) var previousButtonBackground: UIColor = .clear
    private(set) var previousButtonFont: UIFont = .systemFont(ofSize: 12)
    private(set) var previousButtonTextColor: UIColor = .white
    private(set) var currentButtonBackground: UIColor = .clear
    private(set) var currentButtonFont: UIFont = .systemFont(ofSize: 12)
    private(set) var currentButtonTextColor: UIColor = .white
    private(set) var nextButtonBackground: UIColor = .clear
    private(set) var nextButtonFont: UIFont = .systemFont(ofSize: 12)
    private(set) var nextButtonTextColor: UIColor = .white
    
    private let selectedButtonFont: UIFont = UIFont(name: "OpenSansHebrew-Bold", size: 13) ?? .systemFont(ofSize: 12)
    private let notSelectedButtonFont: UIFont = UIFont(name: "OpenSansHebrew-Regular", size: 13) ?? .systemFont(ofSize: 12)
    private let blueColor: UIColor = UIColor(red: 0, green: 112 / 255.0, blue: 191 / 255.0, alpha: 1.0)
    private let darkBlueColor: UIColor = UIColor(red: 0.06274509804, green: 0.2784313725, blue: 0.462745098, alpha: 1.0)

    
    init(delegate: WeeklyScheduleViewModelDelegate?) {
        self.delegate = delegate
        weekType = .current
        loadData()
        prepareTitle()
        prepareButtonStyle()
    }

    func showPreviousWeek() {
        if weekType != .previous {
            weekType = .previous
            loadData()
            prepareTitle()
            prepareButtonStyle()
        }
    }
    
    func showCurrentWeek() {
        if weekType != .current {
            weekType = .current
            loadData()
            prepareTitle()
            prepareButtonStyle()
        }
    }
    
    func showNextWeek() {
        if weekType != .next {
            weekType = .next
            loadData()
            prepareTitle()
            prepareButtonStyle()
        }
    }
}

private extension WeeklyScheduleViewModel {
    
    func loadData() {
        delegate?.didStartLoading()
        
        let getWeekSchedule = GetWorkScheduleEndpoint(weekType)
        getWeekSchedule.apiCall { [weak self] (response, error) in
            self?.delegate?.didFinishLoading()
            
            if error?.success ?? false {
                self?.prepareCellViewModels(response)
            } else {
                NavigationController.shared?.showErrorView(error: error)
            }
        }
    }
    
    func prepareCellViewModels(_ response: WeekWorkScheduleResponseModel?) {
        guard let model = response else { return }
        
        var viewModels: [WeeklyScheduleCellViewModel] = []
        for scheduleItem in model.data {
            let viewModel = WeeklyScheduleCellViewModel(model: scheduleItem)
            viewModels.append(viewModel)
        }
        viewModels = viewModels.sorted(by: { $0.dayString < $1.dayString })
        cellViewModels = viewModels
        delegate?.didLoadData(cellViewModels)
    }
    
    func prepareTitle() {
        titleString = "WEEK_SCHEDULE_SCREEN_TITLE".localized + " - " + secondPartOfTitle()
    }
    
    func secondPartOfTitle() -> String {
        switch weekType {
        case .previous:
            return "WEEK_SCHEDULE_PREVIOUS_BUTTON_TITLE".localized.lowercased()
        case .current:
            return "WEEK_SCHEDULE_CURRENT_BUTTON_TITLE".localized.lowercased()
        case .next:
            return "WEEK_SCHEDULE_NEXT_BUTTON_TITLE".localized.lowercased()
        }
    }
    
    func prepareButtonStyle() {
        switch weekType {
        case .previous:
            previousButtonBackground = blueColor
            previousButtonFont = selectedButtonFont
            previousButtonTextColor = .white
            currentButtonBackground = .white
            currentButtonFont = notSelectedButtonFont
            currentButtonTextColor = darkBlueColor
            nextButtonBackground = .white
            nextButtonFont = notSelectedButtonFont
            nextButtonTextColor = darkBlueColor
        case .current:
            previousButtonBackground = .white
            previousButtonFont = notSelectedButtonFont
            previousButtonTextColor = darkBlueColor
            currentButtonBackground = blueColor
            currentButtonFont = selectedButtonFont
            currentButtonTextColor = .white
            nextButtonBackground = .white
            nextButtonFont = notSelectedButtonFont
            nextButtonTextColor = darkBlueColor
        case .next:
            previousButtonBackground = .white
            previousButtonFont = notSelectedButtonFont
            previousButtonTextColor = darkBlueColor
            currentButtonBackground = .white
            currentButtonFont = notSelectedButtonFont
            currentButtonTextColor = darkBlueColor
            nextButtonBackground = blueColor
            nextButtonFont = selectedButtonFont
            nextButtonTextColor = .white
        }
    }
}
