//
//  MultipleChooseCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/14/20.
//

import UIKit

class MultipleChooseCellViewModel {

    private var title: String
    private var isSelected: Bool

    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }

    func getTitle() -> String {
        return title
    }

    func getSelectButtonImage() -> UIImage? {
        return isSelected ? #imageLiteral(resourceName: "checked_terms") : #imageLiteral(resourceName: "unchecked_terms")
    }

}
