//
//  WeatherLocation.swift
//  WeatherSoft
//
//  Created by Max on 09/09/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import Foundation


struct WeatherLocation: Codable, Equatable {
    
    
    var city: String!
    var country: String!
    var countryCode: String!
    var isCurrentLocation: Bool!
}
