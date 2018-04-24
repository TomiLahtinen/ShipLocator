//
//  MetaDataRepository.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 20/04/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

class MetaDataRepository {
    
    private let iceBreakerType = 90
    private let vesselMetaEndPoint = "https://meri.digitraffic.fi/api/v1/metadata/vessels"
    
    private let dataUpdated: ([Ship]) -> ()
    
    init(updated: @escaping ([Ship]) -> ()) {
        self.dataUpdated = updated
        initMetadataModel()
    }
    
    private func initMetadataModel() {
        if let ships = try? Ships(fromURL: URL(string: vesselMetaEndPoint)!) {
            let metadataModel = ships
                .filter() { ship -> Bool in
                    return ship.shipType == iceBreakerType
            }
            dataUpdated(metadataModel)
        }
        else {
            fatalError("Unable to get ship meta data")
        }
    }
    
    public func updateMetaData() {
        initMetadataModel()
    }
    
    
}
