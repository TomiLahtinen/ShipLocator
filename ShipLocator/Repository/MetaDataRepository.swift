//
//  MetaDataRepository.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 20/04/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

class MetaDataRepository {
    
    private let dataUpdated: ([Ship]) -> ()
    
    init(updated: @escaping ([Ship]) -> ()) {
        self.dataUpdated = updated
        initMetadataModel()
    }
    
    private func initMetadataModel() {
        if let ships = try? Ships(fromURL: URL(string: Constants.vesselMetaEndPoint)!) {
            let metadataModel = ships
                .filter() { ship -> Bool in
                    return ship.shipType == Constants.iceBreakerType
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
