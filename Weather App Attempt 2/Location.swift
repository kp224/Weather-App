//
//  Location.swift
//  Weather App Attempt 2
//
//  Created by Kasra Panahi on 4/1/22.
//

import Foundation
import SwiftyJSON

struct Location {
//    let lat: String
//    let lon: String
    
    let lat: Double
    let lon: Double
    
    init(json: JSON) {
        self.lat = json["lat"].doubleValue
        self.lon = json["lon"].doubleValue
    }
}
