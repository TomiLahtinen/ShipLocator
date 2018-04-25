//
//  ShipDetailModel.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 24/04/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

protocol ShipDetailModel {
    var shipDetail: ShipDetail? { get }
    func fetchDetailsFor(mmsi: Int, withLocation: ShipLocation?)
}

class ShipDetailModelImpl: ShipDetailModel {

    private let updated: (ShipDetail) -> ()
    var shipDetail: ShipDetail? {
        didSet {
            if let shipDetail = shipDetail {
                updated(shipDetail)
            }
        }
    }
    
    init(updated: @escaping (ShipDetail) -> ()) {
        self.updated = updated
    }
    
    func fetchDetailsFor(mmsi: Int, withLocation: ShipLocation? = nil) {
        guard let model = ShipDataModel.instance,
              let ship = model.getShipMeta(mmsi: mmsi)
        else {
            debugPrint("No meta data model available")
            return
        }
        
        self.shipDetail = [
            ("Latitude", String(format: "%.4f", withLocation?.coordinates.latitude ?? 0)),
            ("Longitude", String(format: "%.4f", withLocation?.coordinates.longitude ?? 0)),
            ("Callsign", ship.callSign ?? ""),
            ("Destination", ship.destination ?? ""),
            ("Type", String(ship.shipType)),
            ("Draught", String(ship.draught)),
            ("IMO", String(ship.imo)),
            ("MMSI", String(ship.mmsi)),
            ("ETA", String(ship.eta))
        ]
    }
}
