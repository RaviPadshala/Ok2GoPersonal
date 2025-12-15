//
//  SideBarCellViewModel.swift
//  clock2go2020
//
//  Created by Admin on 4/10/20.
//

import UIKit

class SideBarCellViewModel {

    private var image: UIImage?
    private var title: String?
    private var additionalView: UIView?

    init(image: UIImage?, title: String?, additionalView: UIView?) {
        self.image = image
        self.title = title
        self.additionalView = additionalView
    }

    func getImage() -> UIImage? {
        return image
    }

    func getTitle() -> String {
        return title ?? ""
    }

    func getAdditionalView() -> UIView? {
        return additionalView
    }

}
