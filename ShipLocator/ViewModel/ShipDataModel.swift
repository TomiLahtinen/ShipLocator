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

    private var model: [Ship] = [] {
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
    
    func getModel(filteredBy: String? = nil) -> [Ship] {
        return model.filter({ ship -> Bool in
            if let filter = filteredBy?.lowercased(), !filter.isEmpty {
                return ship.name.lowercased().contains(filter) || (ship.callSign?.lowercased().contains(filter)) ?? false
            }
            else {
                return true
            }
        })
    }
    
    func getShipMeta(mmsi: Int) -> Ship? {
        return model.filter() { $0.mmsi == mmsi }.first
    }
    
    // MARK:- LocationWebSocketHandler implementation
    func initWebSockets() {
        disconnectWebSockets()
        shipLocationRepository?.initWebSockets(keys: model.map { $0.mmsi })
    }
    
    func connectWebSockets() {
        shipLocationRepository?.connectWebsockets()
    }
    
    func disconnectWebSockets() {
        shipLocationRepository?.disconnectWebSockets()
    }
    
}
