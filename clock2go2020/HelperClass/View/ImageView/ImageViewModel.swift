//
//  ImageViewModel.swift
//  clock2go2020
//
//  Created by Admin on 3/30/20.
//

import UIKit

class ImageViewModel {

    private var image: UIImage?

    init(image: UIImage?) {
        self.image = image
    }

    func getImage() -> UIImage? {
        return image
    }

}
