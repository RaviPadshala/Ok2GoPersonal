//
//  DayWorkScheduleViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 05.08.2022.
//

import UIKit

class DayWorkScheduleViewModel {
    
    private(set) var headerViewModel = DayWorkScheduleHeaderViewModel()
    let cellViewModels: [DayWorkScheduleCellViewModel]
    private(set) var titleString: String = "WORK_SCHEDULE_TITLE".localized
    
    init(_ workItems: [WorkScheduleObj]) {
        var viewModels: [DayWorkScheduleCellViewModel] = []
        for model in workItems {
            let viewModel = DayWorkScheduleCellViewModel(model: model)
            viewModels.append(viewModel)
        }
        cellViewModels = viewModels
    }
    
    func reloadInfo() {
        headerViewModel.reloadInfo()
        titleString = "WORK_SCHEDULE_TITLE".localized
    }
}
