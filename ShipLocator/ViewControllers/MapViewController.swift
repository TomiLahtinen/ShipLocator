//
//  ViewController.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 12/03/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var shipDataModel: ShipDataModel?
    var followMmsi: Int?
    
    private let template = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
    private var tileRenderer: MKOverlayRenderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let overlay = MKTileOverlay(urlTemplate: template)
        overlay.canReplaceMapContent = true
        mapView.add(overlay, level: .aboveLabels)
        tileRenderer = MKTileOverlayRenderer(overlay: overlay)
        self.mapView.delegate = self
        
        self.shipDataModel = ShipDataModel(shipLocationUpdated: { (shipLocation) in
            self.upsertAnnotation(shipLocation)
            if shipLocation.data.mmsi == self.followMmsi {
                self.mapView.centerCoordinate = shipLocation.coordinates
            }
        })
        self.shipDataModel?.initWebSockets()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shipDataModel?.connectWebSockets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        shipDataModel?.disconnectWebSockets()
    }

    func upsertAnnotation(_ location: ShipLocation) {
        if let annotation = mapView.annotations
            .filter({ anno in
                return anno is MMSIPointAnnotation &&
                       (anno as! MMSIPointAnnotation).mmsi == location.data.mmsi
            }).first {
                DispatchQueue.main.async {
                    let annotation = annotation as! MMSIPointAnnotation
                    annotation.coordinate = location.coordinates
                }
            }
        else {
            let annotation = MMSIPointAnnotation(location.data.mmsi)
            let ship = shipDataModel?.getShipMeta(mmsi: location.data.mmsi)
            annotation.title = ship?.name ?? "\(location.data.mmsi)"
            annotation.subtitle = ship?.destination ?? ""
            annotation.coordinate = location.coordinates
            self.mapView.addAnnotation(annotation)
        }
    }
    
    private func countDistance(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> CLLocationDistance {
        let point = MKMapPointForCoordinate(from)
        let point2 = MKMapPointForCoordinate(to)
        return MKMetersBetweenMapPoints(point, point2)
    }
    
    func zoomToSingleShip(mmsi: Int) {
        if let annotation = mapView.annotations
            .filter({ (annotation) -> Bool in
                return annotation is MMSIPointAnnotation && (annotation as! MMSIPointAnnotation).mmsi == mmsi
            })
            .first {
            mapView.showAnnotations([annotation], animated: true)
            followMmsi = mmsi
        }
    }
    
    func zoomToAllShips() {
        mapView.showAnnotations(mapView.annotations, animated: true)
        followMmsi = nil
    }
    
    
}

//MARK:- MapViewDelegate
extension MapViewController {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return tileRenderer!
    }
    
}

class MMSIPointAnnotation: MKPointAnnotation {
    
    var mmsi: Int
    
    init(_ mmsi: Int) {
        self.mmsi = mmsi
    }
}

