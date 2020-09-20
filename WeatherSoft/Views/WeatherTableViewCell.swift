//
//  WeatherTableViewCell.swift
//  WeatherSoft
//
//  Created by Max on 03/09/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(forecast: WeeklyForecast) {
        
        dayOfTheWeekLabel.text = forecast.date.getDayOfTheWeek()
        weatherIconImageView.image = getImageFor(forecast.weatherIcon)
        tempLabel.text = String(format: "%.0f%@", forecast.temp, returnTempFormatFromUserDefaults())
    }
}





