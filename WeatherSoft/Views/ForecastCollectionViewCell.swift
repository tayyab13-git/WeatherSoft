//
//  ForecastCollectionViewCell.swift
//  WeatherSoft
//
//  Created by Max on 02/09/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hourlyTempLabel: UILabel!
    @IBOutlet weak var hourlyWeatherIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func generateCell(weather: HourlyForecast)
    {
        timeLabel.text = weather.date.time()
        hourlyWeatherIcon.image = getImageFor(weather.weatherIcon)
        hourlyTempLabel.text = String(format:"%.0f%@" , weather.temp,returnTempFormatFromUserDefaults())
    }
}

