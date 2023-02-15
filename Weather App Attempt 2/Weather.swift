//
//  Weather.swift
//  Weather App Attempt 2
//
//  Created by Kasra Panahi on 4/3/22.
//

import Foundation
import SwiftyJSON

struct Weather {
    let weatherDescription: String
    let icon: String
    let temp: Int
    let pressure: Int
    let humidity: Int
    let seaLevel: Int
    let groundLevel: Int
    
    init(json: JSON) {
        self.weatherDescription = json["weather"][0]["description"].stringValue
        self.icon = json["weather"][0]["icon"].stringValue
        self.temp = json["main"]["temp"].intValue
        self.pressure = json["main"]["pressure"].intValue
        self.humidity = json["main"]["humidity"].intValue
        self.seaLevel = json["main"]["seaLevel"].intValue
        self.groundLevel = json["main"]["groundLevel"].intValue
        
//        self.lat = json["lat"].stringValue
//        self.lon = json["lon"].stringValue
    }
}
