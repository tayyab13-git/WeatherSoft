//
//  WeeklyForecast.swift
//  WeatherSoft
//
//  Created by Max on 28/08/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class WeeklyForecast {
    
    private var _date : Date!
    private var _temp : Double!
    private var _weatherIcon  : String!
    
    var date : Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var temp : Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }
    
    var weatherIcon : String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    init(weatherDictionary: Dictionary<String,AnyObject>) {
        
        let json = JSON(weatherDictionary)
        
        self._temp = getTempBasedOnSettings(celsius: json["temp"].double ?? 0.0)
        self._date = currentDateFromUnix(unixDate: json["ts"].double!)
        self._weatherIcon = json["weather"]["icon"].string
        
    }
    
    static func getWeeklyWeather(location: WeatherLocation, completion: @escaping(_ HourlyForecast: [WeeklyForecast])-> Void){
        
        
        
        var WEEKLYWEATHER_URL: String!
        
        if !location.isCurrentLocation {
            
            WEEKLYWEATHER_URL =  String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&days=7&key=39a68808bd5344e28d941ef0c52e1da9", location.city, location.countryCode)
        }
        else
        {
            WEEKLYWEATHER_URL = WEEKYLWEATHERLOCATION_URL
        
        }
            Alamofire.request(WEEKLYWEATHER_URL).responseJSON { (response) in
            
            let result = response.result
            var forecastArray : [WeeklyForecast] = []
            
            if result.isSuccess {
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    if var list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                        list.remove(at: 0)
                        for item in list {
                            let forecast = WeeklyForecast.init(weatherDictionary: item)
                            forecastArray.append(forecast)
                        }
                    }
                }
                completion(forecastArray)
            }
            else {
                completion(forecastArray)
                print("No Weekly forecast")
            }
        }
    }
}
