//
//  Cities.swift
//  Weather App Attempt 2
//
//  Created by Kasra Panahi on 3/29/22.
//

import Foundation
import SwiftyJSON

struct Cities {
    var city: String
    var capital: String
    
    init(json: JSON) {
        self.city = json["name"].stringValue
        self.capital = json["capital"].stringValue
    }
}
