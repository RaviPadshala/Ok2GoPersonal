//
//  MapMarkerWindowView.swift
//  ok2go_Map
//
//  Created by MacBookPro on 2/12/20.
//

import UIKit
import  GoogleMaps
import GooglePlaces

class MapMarkerWindowView: UIView, GMSMapViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet var MapMarkerTableView: UITableView!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet var statusView: UIView!
    @IBOutlet var statusLabel: UILabel!

    var viewModel: MapMarkerWindowViewModel?
    var position: CLLocationCoordinate2D?

    // MARK: Property
    let idCell = "idCell"
    let tableHeigth = 25

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
        Bundle.main.loadNibNamed("MapMarkerWindowView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)

        drawTriangle()
        setupUI()
        setupTableView()
    }

    // MARK: Property func
    func setupUI() {
        roundView.roundCorners([.allCorners], radius: 13.0)
        roundView.shadow(CGSize(width: 0, height: 3), opacity: 0.5, radius: 5, color: #colorLiteral(red: 0.396780706, green: 0.4296031412, blue: 0.4772859865, alpha: 1))

        statusView.roundCorners([.allCorners], radius: 13)
        statusView.border(width: 3.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        statusView.shadow(CGSize(width: 0, height: 3), opacity: 0.2, radius: 4, color: #colorLiteral(red: 0.396780706, green: 0.4296031412, blue: 0.4772859865, alpha: 1))

        closeImage.shadow(.zero, opacity: 0.2, radius: 4, color: #colorLiteral(red: 0.396780706, green: 0.4296031412, blue: 0.4772859865, alpha: 1))
    }

    func drawTriangle() {
        let triangleHeight = 20
        let triangheWidth = 20

        let viewWidth = self.contentView.frame.width

        let path = UIBezierPath()
        path.move(to: CGPoint(x: viewWidth / 2, y: CGFloat(0)))
        path.addLine(to: CGPoint(x: viewWidth / CGFloat(2.0) + CGFloat(triangheWidth) / CGFloat(2.0), y: CGFloat(triangleHeight)))
        path.addLine(to: CGPoint(x: viewWidth / CGFloat(2.0) - CGFloat(triangheWidth) / CGFloat(2.0), y: CGFloat(triangleHeight)))
        path.addLine(to: CGPoint(x: viewWidth / CGFloat(2.0), y: CGFloat(0)))
        path.close()

        let shape = CAShapeLayer()
        shape.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        shape.path = path.cgPath

        let shadowSubLayer = createShadowLayer()
        shadowSubLayer.insertSublayer(shape, at: 0)

        self.contentView.layer.addSublayer(shadowSubLayer)
    }

    func createShadowLayer() -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = #colorLiteral(red: 0.396780706, green: 0.4296031412, blue: 0.4772859865, alpha: 1)
        shadowLayer.shadowOffset = CGSize(width: 0, height: -1)
        shadowLayer.shadowRadius = 2.0
        shadowLayer.shadowOpacity = 0.35

        shadowLayer.backgroundColor = UIColor.clear.cgColor
        return shadowLayer
    }

    func config(markerData: ReportObj?, position: CLLocationCoordinate2D?) {
        viewModel = MapMarkerWindowViewModel(reportObj: markerData)
        self.position = position

        statusView.backgroundColor = viewModel?.getStatusColor()
        statusLabel.text = viewModel?.getStatusTitle()
    }

    func setupTableView() {
        MapMarkerTableView.delegate = self
        MapMarkerTableView.dataSource = self
        MapMarkerTableView.sectionIndexMinimumDisplayRowCount = 4

        let nibCell = UINib(nibName: "MapMarkerTableViewCell", bundle: nil)
        MapMarkerTableView.register(nibCell, forCellReuseIdentifier: idCell)
    }
}

extension MapMarkerWindowView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MapMarkEntity.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! MapMarkerTableViewCell

        cell.selectionStyle = .default
        cell.title.text = viewModel?.getValueForRow(row: indexPath.row)
        cell.imageCell.image = MapMarkEntity.init(rawValue: indexPath.row)?.icon

        cell.roundCorners([.allCorners], radius: 13.0)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableHeigth)
    }

}
