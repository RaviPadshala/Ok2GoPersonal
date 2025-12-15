//
//  ChooseListViewModel.swift
//  clock2go2020
//
//  Created by Admin on 2/9/20.
//

import UIKit

class ChooseListViewModel: NSObject {

    var chooseListTitle: String?
    var chooseListArray: [String]?

    var maxCountOfVisibleCells = 5
    var cellHeight = 88

    init(title: String, data: [String]) {
        self.chooseListTitle = title
        self.chooseListArray = data
    }
    
    func getChooseListTitle() -> String {
        return (chooseListTitle ?? "").localized
    }

    func getNumberofRows() -> Int {
        return chooseListArray?.count ?? 0
    }

    func getCellTitle(index: Int) -> String {
        return chooseListArray?[index] ?? ""
    }

    func getTableViewHeight() -> CGFloat {
        let tableHeight = getNumberofRows() > maxCountOfVisibleCells
                        ? maxCountOfVisibleCells * cellHeight
                        : getNumberofRows() * cellHeight
        return CGFloat(tableHeight)
    }

}
