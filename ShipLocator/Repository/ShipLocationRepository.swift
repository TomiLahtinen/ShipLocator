//
//  ShipLocationRepository.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 20/04/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation
import SwiftWebSocket

protocol LocationWebSocketHandler {
    func initWebSockets()
    func connectWebSockets()
    func disconnectWebSockets()
}

class ShipLocationRepository {
    
    var sockets: [WebSocket]?
    
    private let locationUpdated: (ShipLocation) -> ()
    
    init(locationUpdated: @escaping (ShipLocation) -> ()) {
        self.locationUpdated = locationUpdated
    }
    
    public func initWebSockets(keys: [Int]){
        keys.forEach({ (key) in
            let socket = WebSocket("\(Constants.socketBase)\(key)")
            socket.event.open = {
                self.sockets?.append(socket)
            }
            
            socket.event.message = { message in
                if let message = message as? String {
                    if let location = try? ShipLocation(message) {
                        self.locationUpdated(location)
                        self.notify(location)
                    }
                }
            }
            
            socket.event.close = { code, reason, clean in
                if let index = self.sockets?.index(of: socket) {
                    self.sockets?.remove(at: index)
                }
            }
        })
    }
    
    public func connectWebsockets() {
        sockets?.forEach() { socket in socket.open() }
    }
    
    public func disconnectWebSockets() {
        sockets?.forEach() { socket in socket.close() }
    }
    
    private func notify(_ location: ShipLocation) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.shipLocationNotifications),
                                        object: self,
                                        userInfo: [Constants.shipLocationNotifications: location])
    }
}
