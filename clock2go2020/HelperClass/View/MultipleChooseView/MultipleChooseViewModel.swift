//
//  MultipleChooseViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/14/20.
//

import UIKit

class MultipleChooseViewModel {
    var chooseListTitle: String?
    var chooseListArray: [String]?

    var selectedListArray: [String]?

    var maxCountOfVisibleCells = 5
    var cellHeight = 50

    init(title: String, data: [String], selectedData: [String] = []) {
        self.chooseListTitle = title
        self.chooseListArray = data
        self.selectedListArray = selectedData
    }

    func updateSelections(index: Int) {
        let title = getCellTitle(index: index)

        if let index = selectedListArray?.firstIndex(of: title) {
            selectedListArray?.remove(at: index)
        } else {
            selectedListArray?.append(title)
        }
    }

    func getSelectedValues() -> [String] {
        return selectedListArray ?? []
    }

    func getChooseListTitle() -> String {
        return chooseListTitle ?? ""
    }

    func getNumberofRows() -> Int {
        return chooseListArray?.count ?? 0
    }

    func getCellTitle(index: Int) -> String {
        return chooseListArray?[index] ?? ""
    }

    func getModelForCellAt(indexPath: IndexPath) -> MultipleChooseCellViewModel {

        let title = getCellTitle(index: indexPath.row)
        let isSelected = selectedListArray?.contains(title) ?? false

        return MultipleChooseCellViewModel(title: title, isSelected: isSelected)
    }

    func getTableViewHeight() -> CGFloat {
        let tableHeight = getNumberofRows() > maxCountOfVisibleCells
                        ? maxCountOfVisibleCells * cellHeight
                        : getNumberofRows() * cellHeight
        return CGFloat(tableHeight)
    }
}
