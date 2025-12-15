//
//  ErrorViewModel.swift
//  clock2go2020
//
//  Created by Admin on 1/30/20.
//

import UIKit

class ErrorViewModel {

    var message: String?
    var showAproveView: Bool
    var titleError: String?

    init(title: String?, message: String?, showAproveView: Bool = true) {
        self.message = message
        self.showAproveView = showAproveView
        self.titleError = title
    }
}
