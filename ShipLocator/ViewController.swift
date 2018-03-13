//
//  ViewController.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 12/03/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import UIKit
import SwiftWebSocket
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    private let iceBreakerType = 90
    private let socketBase = "ws://meri.digitraffic.fi/api/v1/plain-websockets/locations/"
    
    var metadataModel: [Int: Ship] = [:]
    var sockets: [WebSocket]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMetadataModel()
        initWebsockets()
        self.mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        connectWebsockets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disconnectWebSockets()
    }
    
    private func initMetadataModel() {
        if let ships = try? Ships(fromURL: URL(string: "https://meri.digitraffic.fi/api/v1/metadata/vessels")!) {
            metadataModel = ships
                .reduce(into: [Int: Ship]()) {
                    $0[$1.mmsi] = $1
                }
                .filter() { (key, value) -> Bool in
                    return value.shipType == iceBreakerType
                }
        }
        else {
            fatalError("Unable to get ship meta data")
        }
    }
    
    private func iceBreaker(_ location: ShipLocation) -> Bool {
        return metadataModel[location.data.mmsi]!.shipType == iceBreakerType
    }
    
    private func upsertAnnotation(_ location: ShipLocation) {
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
            annotation.title = metadataModel[location.data.mmsi]?.name ?? "\(location.data.mmsi)"
            annotation.subtitle = metadataModel[location.data.mmsi]?.destination ?? ""
            self.mapView.addAnnotation(annotation)
        }
    }
    
    private func initWebsockets(){
        metadataModel.forEach({ (key, value) in
            let socket = WebSocket("\(self.socketBase)\(key)")
            socket.event.open = {
                debugPrint("Connected for mmsi \(key)")
                self.sockets?.append(socket)
            }
            
            socket.event.message = { message in
                if let message = message as? String {
                    if let location = try? ShipLocation(message) {
                        DispatchQueue.main.async {
                            self.upsertAnnotation(location)
                        }
                    }
                }
            }
            
            socket.event.close = { code, reason, clean in
                debugPrint("Closed socket of \(key)", code, reason, clean)
                if let index = self.sockets?.index(of: socket) {
                    self.sockets?.remove(at: index)
                }
            }
        })
    }
    
    private func connectWebsockets() {
        sockets?.forEach() { socket in socket.open() }
    }
    
    private func disconnectWebSockets() {
        sockets?.forEach() { socket in socket.close() }
    }
    
    private func countDistance(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> CLLocationDistance {
        let point = MKMapPointForCoordinate(from)
        let point2 = MKMapPointForCoordinate(to)
        return MKMetersBetweenMapPoints(point, point2)
    }
}

extension ViewController: MKMapViewDelegate {}

class MMSIPointAnnotation: MKPointAnnotation {
    
    var mmsi: Int
    
    init(_ mmsi: Int) {
        self.mmsi = mmsi
    }
}

