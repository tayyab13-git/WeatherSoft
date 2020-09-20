//
//  GlobalHelpers.swift
//  WeatherSoft
//
//  Created by Max on 25/08/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import Foundation
import UIKit
func currentDateFromUnix(unixDate: Double?) -> Date? {
    
    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    }
    else {
        return Date()
    }
}

func getImageFor(_ type: String) -> UIImage? {
    
    return UIImage(named: type)
}

func fahrenheitFromCelsius(celsius: Double) -> Double
{
    return (celsius * 9/5) + 32
}

func getTempBasedOnSettings(celsius: Double) -> Double
{
    let format = returnTempFormatFromUserDefaults()
    
    if format == TempFormat.celsius
    {
        return celsius
    }
    else
    {
        return fahrenheitFromCelsius(celsius: celsius)
    }
    
}

func returnTempFormatFromUserDefaults() -> String
{
        if let tempFormat = UserDefaults.standard.value(forKey: "tempFormat")
        {
            if tempFormat as! Int == 0
            {
                return TempFormat.celsius
            }
            else
            {
                return TempFormat.fahrenheit
            }
    }
    else
        {
          return TempFormat.celsius
    }
    
}
