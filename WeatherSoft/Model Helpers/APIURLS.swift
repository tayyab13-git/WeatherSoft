//
//  APIURLS.swift
//  WeatherSoft
//
//  Created by Max on 09/09/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import Foundation


let CURRENTWEATHERLOCATION_URL = "https://api.weatherbit.io/v2.0/current?&lat=\(LocationService.shared.latitude)&lon=\(LocationService.shared.longitude)&key=39a68808bd5344e28d941ef0c52e1da9"
let WEEKYLWEATHERLOCATION_URL = "https://api.weatherbit.io/v2.0/forecast/daily?&lat=\(LocationService.shared.latitude)&lon=\(LocationService.shared.longitude)&days=7&key=39a68808bd5344e28d941ef0c52e1da9"
let HOURLYWEATHERLOCATION_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?&lat=\(LocationService.shared.latitude)&lon=\(LocationService.shared.longitude)&hours=24&key=39a68808bd5344e28d941ef0c52e1da9"
