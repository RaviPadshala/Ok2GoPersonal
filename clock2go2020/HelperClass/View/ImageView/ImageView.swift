//
//  ImageView.swift
//  clock2go2020
//
//  Created by Admin on 3/30/20.
//

import UIKit

class ImageView: UIView {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    var viewModel: ImageViewModel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ImageView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
    }

    override func layoutSubviews() {
        imageView.image = viewModel.getImage()
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        self.removeFromSuperview()
    }

}
