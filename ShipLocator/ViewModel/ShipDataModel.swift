//
//  MetaDataModel.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 20/04/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

class ShipDataModel: LocationWebSocketHandler {

    let metaDataChanged: () -> ()

    private var model: [Int: Ship] = [:] {
        didSet {
            self.metaDataChanged()
        }
    }
    
    var metadataRepository: MetaDataRepository?
    var shipLocationRepository: ShipLocationRepository?
    
    init(shipLocationUpdated: @escaping (ShipLocation) -> () = { _ in /* NOP */ },
         metaDataChanged: @escaping () -> () = { /* NOP */ }){
        
        self.metaDataChanged = metaDataChanged
        self.metadataRepository = MetaDataRepository(updated: { metadata in
            self.model = metadata
        })
        
        self.shipLocationRepository = ShipLocationRepository(locationUpdated: { location in
            shipLocationUpdated(location)
        })
        
        self.metadataRepository?.updateMetaData()
    }
    
    func getModel(filteredBy: String? = nil) -> [Int: Ship] {
        return model.filter({ (key, ship) -> Bool in
            if let filter = filteredBy?.lowercased(),
                !filter.isEmpty
            {
                return ship.name.lowercased().contains(filter) || (ship.callSign?.lowercased().contains(filter)) ?? false
            }
            else {
                return true
            }
        })
    }
    
    func getShipMeta(mmsi: Int) -> Ship? {
        return model[mmsi]
    }
    
    public func isIceBreaker(mmsi: Int) -> Bool {
        return model[mmsi]?.shipType == Constants.iceBreakerType
    }
    
    // MARK:- LocationWebSocketHandler implementation
    func initWebSockets() {
        disconnectWebSockets()
        shipLocationRepository?.initWebSockets(keys: model.keys.map { $0 })
    }
    
    func connectWebSockets() {
        shipLocationRepository?.connectWebsockets()
    }
    
    func disconnectWebSockets() {
        shipLocationRepository?.disconnectWebSockets()
    }
    
}
