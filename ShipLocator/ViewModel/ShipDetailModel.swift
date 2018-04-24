//
//  ShipDetailModel.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 24/04/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

class ShipDetailModel {
    
    private let updated: (ShipDetail) -> ()
    private var shipDetail: ShipDetail? {
        didSet {
            if let shipDetail = shipDetail {
                updated(shipDetail)
            }
        }
    }
    
    init(updated: @escaping (ShipDetail) -> ()) {
        self.updated = updated
    }
}
