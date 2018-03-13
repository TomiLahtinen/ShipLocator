// To parse the JSON, add this file to your project and do:
//
//   let ships = try Ships(json)

import Foundation

typealias Ships = [Ship]

struct Ship: Codable {
    let timestamp: Int
    let posType: Int
    let referencePointA: Int
    let referencePointB: Int
    let referencePointC: Int
    let referencePointD: Int
    let shipType: Int
    let mmsi: Int
    let destination: String?
    let eta: Int
    let callSign: String?
    let imo: Int
    let draught: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "timestamp"
        case posType = "posType"
        case referencePointA = "referencePointA"
        case referencePointB = "referencePointB"
        case referencePointC = "referencePointC"
        case referencePointD = "referencePointD"
        case shipType = "shipType"
        case mmsi = "mmsi"
        case destination = "destination"
        case eta = "eta"
        case callSign = "callSign"
        case imo = "imo"
        case draught = "draught"
        case name = "name"
    }
}

// MARK: Convenience initializers

extension Ship {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Ship.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == Ships.Element {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Ships.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
