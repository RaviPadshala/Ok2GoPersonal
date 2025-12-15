//
//  MapViewController.swift
//  clock2go2020
//
//  Created by Admin on 3/24/20.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var mapView: MapView!

    var viewModel: MapControllerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillLayoutSubviews() {
        mapView.shouldShowBottomView = false
        locationTitle.text = viewModel.getLocationTitle()
        mapView.changeLocation(location: viewModel.getLocation())
    }

    func configure(model: MapControllerViewModel) {
        self.viewModel = model
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
