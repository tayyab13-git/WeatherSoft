//
//  CurrentWeather.swift
//  WeatherSoft
//
//  Created by Max on 19/08/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class CurrentWeather{
    
    private var _city: String!
    private var _date: Date!
    private var _currentTemp: Double!
    private var _feelsLike: Double!
    private var _uv: Double!
    
    private var _weatherType: String!
    private var _pressure: Double! //mb
    private var _humidity:Double! //%
    private var _windSpeed: Double! //meter/sec
    private var _weatherIcon: String!
    private var _visibility: Double! //km
    private var _sunrise: String!
    private var _sunSet: String!
    
    var city: String {
        
        if _city == nil {
            _city = ""
        }
        return _city
    }
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var feelsLike: Double {
        if _feelsLike == nil {
            _feelsLike = 0.0
        }
        return _feelsLike
    }
    
    var uv: Double {
        if _uv == nil {
            _uv = 0.0
        }
        return _uv
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var pressure: Double {
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    var humidity : Double {
        if _humidity == nil {
            _humidity = 0.0
        }
        return _humidity
    }
    var windSpeed: Double {
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon =  ""
        }
        return _weatherIcon
    }
    
    var visibilty: Double {
        if _visibility == nil {
            _visibility = 0.0
        }
        return _visibility
    }
    var sunrise: String {
        if _sunrise == nil {_sunrise = ""}
        return _sunrise
    }
    var sunSet: String {
        if _sunSet == nil {
            _sunSet = ""
        }
        return _sunSet
    }
    func getCurrentWeather(location: WeatherLocation, completion: @escaping(_ success: Bool) ->Void)
    {
        
        var CURRENTWEATHER_URL: String!
        
        if !location.isCurrentLocation {
            
          CURRENTWEATHER_URL =  String(format: "https://api.weatherbit.io/v2.0/current?city=%@,%@&key=39a68808bd5344e28d941ef0c52e1da9", location.city, location.countryCode)
        }
        else
        {
            CURRENTWEATHER_URL = CURRENTWEATHERLOCATION_URL
        }
        
        Alamofire.request(CURRENTWEATHER_URL).responseJSON { (response) in
            
            let result = response.result
            if result.isSuccess {
                
                let json = JSON(result.value)
                self._city = json["data"][0]["city_name"].stringValue
                self._date = currentDateFromUnix(unixDate: json["data"][0]["ts"].double)
                self._currentTemp = getTempBasedOnSettings(celsius: json["data"][0]["temp"].double ?? 0.0)
                self._feelsLike = getTempBasedOnSettings(celsius: json["data"][0]["app_temp"].double ?? 0.0)
                self._uv = json["data"][0]["uv"].double
                
                self._weatherType = json["data"][0]["weather"]["description"].stringValue
                self._pressure = json["data"][0]["pres"].double
                self._humidity = json["data"][0]["rh"].double
                self._windSpeed = json["data"][0]["wind_spd"].double
                self._weatherIcon = json["data"][0]["weather"]["icon"].stringValue
                self._visibility = json["data"][0]["vis"].double
                self._sunrise = json["data"][0]["sunrise"].stringValue
        
                self._sunSet = json["data"][0]["sunset"].stringValue
                completion(true)

            }
            else
            {
                self._city = location.city
                completion(false)
                print("not able to fetch data")
            }
        }
    }
}
