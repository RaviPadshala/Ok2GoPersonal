//
//  ExtendedListViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 29.06.2022.
//

import UIKit

enum ExtendedListContentType {
    case project
    case locationName
}

protocol ExtendedListInterface {
    func itemId() -> Int?
    func itemName() -> String
}

class ExtendedListViewModel {
    
    private let models: [ExtendedListInterface]
    let type: ExtendedListContentType
    let parameters: Any?
    let tableViewHeight: CGFloat
    let titleString: String
    private(set) var cellViewModels: [ExtendedListCellViewModel] = []
    private var selectedModel: ExtendedListInterface?
    var approveButtonEnabled: Bool {
        return selectedModel != nil ? true : false
    }
    var approveViewAlpha: CGFloat {
        return selectedModel != nil ? 1.0 : 0.5
    }
    
    init(type: ExtendedListContentType, models: [ExtendedListInterface], parameters: Any? = nil) {
        self.models = models
        self.type = type
        self.parameters = parameters
        self.tableViewHeight = models.count > 4 ? 200.0 : CGFloat(models.count) * 50.0
        titleString = type == .project ? "CHOOSE_PROJECT_STRING".localized : "LOCATION_NAMES".localized

        prepareCellViewModels()
    }
    
    private func prepareCellViewModels() {
        for model in models {
            let viewModel = ExtendedListCellViewModel(model: model)
            cellViewModels.append(viewModel)
        }
    }
    
    func didSelectProject(at indexPath: IndexPath) {
        guard models.count > indexPath.row else {
            return
        }
        selectedModel = models[indexPath.row]
    }
    
    func selectedItemId() -> Int? {
        return selectedModel?.itemId()
    }
}
