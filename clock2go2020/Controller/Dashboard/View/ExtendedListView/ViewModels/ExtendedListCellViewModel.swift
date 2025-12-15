//
//  ExtendedListCellViewModel.swift
//  clock2go2020
//
//  Created by Sasha Klovak on 29.06.2022.
//

import UIKit

class ExtendedListCellViewModel {
    let titleString: String
    
    init(model: ExtendedListInterface) {
        titleString = model.itemName()
    }
}
