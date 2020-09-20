//
//  MainWeatherTableViewCell.swift
//  WeatherSoft
//
//  Created by Max on 16/09/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {

    // MARK:  Outlets

@IBOutlet weak var cityLabel: UILabel!
@IBOutlet weak var tempLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func generateCell(weatherData: CityTempData)
    {
        cityLabel.text = weatherData.city
        cityLabel.adjustsFontSizeToFitWidth = true
        tempLabel.text = String(format: "%.0f%@", weatherData.temp,returnTempFormatFromUserDefaults())
    }
    
    
}
