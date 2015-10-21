//
//  Weather.swift
//  Weather-App-Example
//
//  Created by mitchell hudson on 10/6/15.
//  Copyright © 2015 mitchell hudson. All rights reserved.
//

import Foundation

struct Weather {
    let cityName: String
    let temp: Double
    let description: String
    let icon: String
    let clouds: Double
    
    var tempC: Double {
        get {
            return temp - 273.15
        }
    }
    
    init(cityName: String,
        temp: Double,
        description: String,
        icon: String,
        clouds: Double) {
            
        self.cityName = cityName
        self.temp = temp
        self.description = description
        self.icon = icon
        self.clouds = clouds
    }
    
}