//
//  Pin.swift
//  Pindrop
//
//  Created by Will Said on 9/26/18.
//  Copyright © 2018 Will Said. All rights reserved.
//

import Foundation
import MapKit


class Pin: NSObject, Codable {
    let name: String
    let caption: String
    let latitude: Double
    let longitude: Double
    
    init(name: String, description: String, latitude: Double, longitude: Double) {
        self.name = name
        self.caption = description
        self.latitude = latitude
        self.longitude = longitude
    }
}


extension Pin {
    static let pinsKey = "pins"
    
    static func save(pins: [Pin]) {
        let data = try? JSONEncoder().encode(pins)  // json encoding
        UserDefaults.standard.set(data, forKey: pinsKey)
    }
    
    static func loadPins() -> [Pin]? {
        if let data = UserDefaults.standard.value(forKey: pinsKey) as? Data,  // UserDefaults
            let pins = try? JSONDecoder().decode([Pin].self, from: data) {     // json decoding
            
            return pins
        }
        return nil
    }
}


// MARK: - MKANNOTATION
extension Pin: MKAnnotation {
    
    // required
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    // computed properties: these display the Pin attributes on the map
    public var title: String? {
        return self.name
    }
    
    public var subtitle: String? {
        return self.caption
    }
}
