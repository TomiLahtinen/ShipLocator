//
//  Constants.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 20/04/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation

enum Constants {
    public static let socketBase = "ws://meri.digitraffic.fi/api/v1/plain-websockets/locations/"
    public static let vesselMetaEndPoint = "https://meri.digitraffic.fi/api/v1/metadata/vessels"
    public static let iceBreakerType = 90
    
    public static let shipLocationNotifications = "SHIP_LOCATION_NOTIFICATIONS"
}
