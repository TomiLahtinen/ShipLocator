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
    
    private let dataUpdated: ([Int: Ship]) -> ()
    
    init(updated: @escaping ([Int: Ship]) -> ()) {
        self.dataUpdated = updated
        initMetadataModel()
    }
    
    private func initMetadataModel() {
        if let ships = try? Ships(fromURL: URL(string: vesselMetaEndPoint)!) {
            let metadataModel = ships
                .reduce(into: [Int: Ship]()) {
                    $0[$1.mmsi] = $1
                }
                .filter() { (key, value) -> Bool in
                    return value.shipType == iceBreakerType
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
