//
//  MapView.swift
//  clock2go2020
//
//  Created by MacBookPro on 1/21/20.
//

import UIKit
import GoogleMaps

class MapView: UIView, GMSMapViewDelegate {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet var gmsMapView: GMSMapView!
    @IBOutlet weak var gmsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var pullToHideView: UIView!

    // MARK: Property
    var marker: GMSMarker?
    var markerImage = UIImage(named: "marker")
    var infoWindow = MapMarkerWindowView()

    weak var delegate: MapViewDelegate?

    var shouldShowInfoView: Bool = false

    var shouldShowBottomView: Bool = true {
        didSet {
            self.setupHideView()
        }
    }

    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("MapView", owner: self, options: nil)

        gmsMapView.delegate = self

        DispatchQueue.main.async {
            self.setupMap()
        }

        addSubview(contentView)
        contentView.frame = self.bounds

        setupHideView()
    }

    func setupHideView() {
        if shouldShowBottomView {
            // UI
            hideButton.adjustsImageWhenHighlighted = false

            // Swipe
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeUp.direction = .up
            self.pullToHideView.addGestureRecognizer(swipeUp)
        } else {
            pullToHideView.isHidden = true
        }
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
       if gesture.direction == .up {
            hideMap()
       }
    }

    let markerLocations = CompaniesDataManager.shared.getLastReportsForTrackingMap()

    func markers(trackReports: [TrackingObj?] = []) {
        for i  in 0 ..< markerLocations.count {
          print(i)

            let latitude = markerLocations[i].lat
            let longitude = markerLocations[i].lon

            if let lat = Double(latitude ?? ""), let lon = Double(longitude ?? "") {
                print("Lat \(lat), Lon\(lon)")
                let location = CLLocation(latitude: lat, longitude: lon)

                let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

                let camera = GMSCameraPosition.camera(withTarget: (location.coordinate), zoom: 15)
                gmsMapView.animate(to: camera)

                let actionType = markerLocations[i].actionType

                if actionType == "1" {
                     markerImage = markerImage?.maskWithColor(color: #colorLiteral(red: 0.2088022828, green: 0.7962543368, blue: 0.4894775748, alpha: 1))
                } else if actionType == "2" {
                    markerImage = markerImage?.maskWithColor(color: #colorLiteral(red: 0.9561534524, green: 0.3323298395, blue: 0.3320666552, alpha: 1))
                } else if actionType == "99" {
                    markerImage = markerImage?.maskWithColor(color: #colorLiteral(red: 0.9866847396, green: 0.7379429936, blue: 0.9088150859, alpha: 1))
                } else if actionType == "98" {
                    markerImage = markerImage?.maskWithColor(color: #colorLiteral(red: 0.9773489833, green: 0.4326385856, blue: 0.8032094836, alpha: 1))
                }

                marker = GMSMarker(position: position)
                marker?.icon = markerImage
                marker?.userData = ["marker": markerLocations[i]]
                marker?.map = gmsMapView
            }
        }

        for track in trackReports {
            if track?.startstop == 72 {
                let latitude = track?.lat
                    let longitude = track?.lon

                    if let lat = Double(latitude ?? ""), let lon = Double(longitude ?? "") {
                        print("Lat \(lat), Lon\(lon)")
                        let location = CLLocation(latitude: lat, longitude: lon)

                        let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

                        markerImage = markerImage?.maskWithColor(color: #colorLiteral(red: 0, green: 1, blue: 0.8470588235, alpha: 1))

                        marker = GMSMarker(position: position)
                        marker?.icon = markerImage
                        marker?.map = gmsMapView

                        let reportObj = ReportObj(time: track?.time ?? "--:--", actionType: track?.startstop?.description, location: track?.location, lon: track?.lon, lat: track?.lat, taskName: nil, remark: nil, healthDisclaimerAccepted: nil)
                        marker?.userData = ["marker": reportObj]
                    }
            }
        }
    }

    func changeLocation(location: CLLocation) {

        let latitude = location.coordinate.latitude // 49.229308
        let longitude = location.coordinate.longitude // 28.426619

        let camera = GMSCameraPosition.camera(withTarget: (location.coordinate), zoom: 17)
        gmsMapView.animate(to: camera)
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        if marker != nil {
            marker?.map = nil
            marker = nil
        }

        marker = GMSMarker(position: position)
        marker?.icon = UIImage(named: "shape")
        marker?.map = gmsMapView

        let circ = GMSCircle(position: position, radius: 4.5)
        circ.fillColor = #colorLiteral(red: 0.9327428937, green: 0.3153797984, blue: 0.3197889924, alpha: 1)
        circ.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        circ.strokeWidth = 2
        circ.map = self.gmsMapView

        gmsMapView.isBuildingsEnabled = false

        // print("add subview")

    }

    func setupMap() {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                gmsMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        gmsMapView.selectedMarker = marker

        guard let markerData = marker.userData as? [String: Any], let reportObj = markerData["marker"] as? ReportObj else { return false }
        shouldShowInfoView = true

        print("\(String(describing: reportObj))")

        let position = marker.position

        infoWindow.removeFromSuperview()
        infoWindow = MapMarkerWindowView()
        infoWindow.config(markerData: reportObj, position: position)

        infoWindow.center = mapView.projection.point(for: position)
        infoWindow.center.x = infoWindow.center.x - infoWindow.contentView.frame.width / 2
        self.gmsMapView.addSubview(infoWindow)

        return false
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        guard shouldShowInfoView else { return }

        infoWindow.removeFromSuperview()

        if let position = infoWindow.position {
            infoWindow.center = mapView.projection.point(for: position)
            infoWindow.center.x = infoWindow.center.x - infoWindow.contentView.frame.width / 2
            self.gmsMapView.addSubview(infoWindow)
        }

    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard shouldShowInfoView else { return }

        infoWindow.removeFromSuperview()
        shouldShowInfoView = false
    }

    @IBAction func hideMapAction(_ sender: Any) {
        self.hideMap()
    }

    func hideMap() {
        self.layoutIfNeeded()
        self.pullToHideView.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.gmsBottomConstraint.constant = self.gmsMapView.frame.height
            self.layoutIfNeeded()
        }) { (_) in
            self.delegate?.userDidHideMap()
        }
    }

}

protocol MapViewDelegate: NSObjectProtocol {
    func userDidHideMap()
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
