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
    func fetchDetailsFor(ship: Ship?)
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
    
    func fetchDetailsFor(ship: Ship?) {
        self.shipDetail = [
            ("Latitude", "0.00"),
            ("Longitude", "0.00"),
            ("Callsign", ship?.callSign ?? ""),
            ("Destination", ship?.destination ?? ""),
            ("Type", "\(String(describing: ship?.shipType))"),
            ("Draught", "\(String(describing: ship?.draught))"),
            ("IMO", "\(String(describing: ship?.imo))"),
            ("MMSI", "\(String(describing: ship?.mmsi))"),
            ("ETA", "\(String(describing: ship?.eta))")
        ]
    }
}
