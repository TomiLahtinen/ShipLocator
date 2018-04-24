//
//  ViewController.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 12/03/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import UIKit

import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var shipDataModel: ShipDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.shipDataModel = ShipDataModel(shipLocationUpdated: { (shipLocation) in
            self.upsertAnnotation(shipLocation)
        })
        self.shipDataModel?.initWebSockets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shipDataModel?.connectWebSockets()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugPrint("traitCollectionDidChange")
        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            debugPrint("Horizontal class changed from", previousTraitCollection?.horizontalSizeClass, "to", traitCollection.horizontalSizeClass)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        shipDataModel?.disconnectWebSockets()
    }

    private func iceBreaker(_ location: ShipLocation) -> Bool {
        return shipDataModel!.isIceBreaker(mmsi: location.data.mmsi)
    }
    
    func upsertAnnotation(_ location: ShipLocation) {
        if let annotation = mapView.annotations
            .filter({ anno in
                return anno is MMSIPointAnnotation &&
                       (anno as! MMSIPointAnnotation).mmsi == location.data.mmsi
            }).first {
                DispatchQueue.main.async {
                    let annotation = annotation as! MMSIPointAnnotation
                    let distance = self.countDistance(annotation.coordinate, location.coordinates)
                    debugPrint("update coordinates of", String(describing: annotation.title), " by ", distance)
                    annotation.coordinate = location.coordinates
                    
                }
            }
        else {
            let annotation = MMSIPointAnnotation(location.data.mmsi)
            let ship = shipDataModel?.getShipMeta(mmsi: location.data.mmsi)
            annotation.title = ship?.name ?? "\(location.data.mmsi)"
            annotation.subtitle = ship?.destination ?? ""
            self.mapView.addAnnotation(annotation)
        }
    }
    
    private func countDistance(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> CLLocationDistance {
        let point = MKMapPointForCoordinate(from)
        let point2 = MKMapPointForCoordinate(to)
        return MKMetersBetweenMapPoints(point, point2)
    }
}

extension MapViewController: MKMapViewDelegate {}

class MMSIPointAnnotation: MKPointAnnotation {
    
    var mmsi: Int
    
    init(_ mmsi: Int) {
        self.mmsi = mmsi
    }
}

