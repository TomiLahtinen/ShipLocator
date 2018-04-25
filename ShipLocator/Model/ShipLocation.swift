// To parse the JSON, add this file to your project and do:
//
//   let shipLocation = try ShipLocation(json)

import Foundation
import CoreLocation

class ShipLocation: NSObject, Codable  {
    let type: String
    let data: ShipLocationData
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case data = "data"
    }
    
    init(type: String, data: ShipLocationData) {
        self.type = type
        self.data = data
        super.init()
    }
    
    override var debugDescription: String {
        return "\(self.data.mmsi) \(self.data.geometry)"
    }
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(data.geometry.coordinates[1], data.geometry.coordinates[0])
    }
}

class ShipLocationData: NSObject, Codable {
    let mmsi: Int
    let type: String
    let geometry: Geometry
    let properties: Properties
    
    enum CodingKeys: String, CodingKey {
        case mmsi = "mmsi"
        case type = "type"
        case geometry = "geometry"
        case properties = "properties"
    }
    
    init(mmsi: Int, type: String, geometry: Geometry, properties: Properties) {
        self.mmsi = mmsi
        self.type = type
        self.geometry = geometry
        self.properties = properties
        super.init()
    }
}

class Geometry: NSObject, Codable {
    let type: String
    let coordinates: [Double]
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case coordinates = "coordinates"
    }
    
    init(type: String, coordinates: [Double]) {
        self.type = type
        self.coordinates = coordinates
        super.init()
    }
}

class Properties: NSObject, Codable {
    let sog: Int
    let cog: Double
    let navStat: Int
    let rot: Int
    let posAcc: Bool
    let raim: Bool
    let heading: Int
    let timestamp: Int
    let timestampExternal: Int
    
    enum CodingKeys: String, CodingKey {
        case sog = "sog"
        case cog = "cog"
        case navStat = "navStat"
        case rot = "rot"
        case posAcc = "posAcc"
        case raim = "raim"
        case heading = "heading"
        case timestamp = "timestamp"
        case timestampExternal = "timestampExternal"
    }
    
    init(sog: Int, cog: Double, navStat: Int, rot: Int, posAcc: Bool, raim: Bool, heading: Int, timestamp: Int, timestampExternal: Int) {
        self.sog = sog
        self.cog = cog
        self.navStat = navStat
        self.rot = rot
        self.posAcc = posAcc
        self.raim = raim
        self.heading = heading
        self.timestamp = timestamp
        self.timestampExternal = timestampExternal
        super.init()
    }
}

// MARK: Convenience initializers

extension ShipLocation {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(ShipLocation.self, from: data)
        self.init(type: me.type, data: me.data)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ShipLocationData {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(ShipLocationData.self, from: data)
        self.init(mmsi: me.mmsi, type: me.type, geometry: me.geometry, properties: me.properties)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Geometry {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(Geometry.self, from: data)
        self.init(type: me.type, coordinates: me.coordinates)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Properties {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(Properties.self, from: data)
        self.init(sog: me.sog, cog: me.cog, navStat: me.navStat, rot: me.rot, posAcc: me.posAcc, raim: me.raim, heading: me.heading, timestamp: me.timestamp, timestampExternal: me.timestampExternal)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

