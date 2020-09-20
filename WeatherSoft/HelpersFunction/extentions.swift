//
//  extentions.swift
//  WeatherSoft
//
//  Created by Max on 02/09/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import Foundation




extension Date {
    
    func shortDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
    
    
    func time() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func getDayOfTheWeek() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
   
}
