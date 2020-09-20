//
//  WeatherView.swift
//  WeatherSoft
//
//  Created by Max on 31/08/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    

    
    // Mark: IBOutlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var weatherInfo: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bottomContainerLabel: UIScrollView!
    @IBOutlet weak var hourlyTempCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var tabelView: UITableView!
    
    // Mark: Vars
    var currentWeather: CurrentWeather!
    var weeklyForecastData : [WeeklyForecast] = []
    var hourlyForecastData : [HourlyForecast] = []
    var forecastInfoData : [WeatherInfo] = []
    
    // Mark: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainViewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mainViewSetup()
    }
    
    private func mainViewSetup() {
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupHourlyCollectionView()
        setupInfoCollectionView()
        setupTableView()
    }
    
    private func setupTableView()
    {
        tabelView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.tableFooterView = UIView()
    }
    
    private func setupHourlyCollectionView()
    {
        
        hourlyTempCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        hourlyTempCollectionView.dataSource = self
        
    }
    
    private func setupInfoCollectionView()
    {
        
       infoCollectionView.register(UINib(nibName: "infoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        infoCollectionView.dataSource = self
    }
    
    private  func setupCurrentWeather() {
        
        city.text = currentWeather.city
        dateLabel.text = "Today, \(currentWeather.date.shortDate())"
        weatherInfo.text = currentWeather.weatherType
        tempLabel.text = String(format: "%.f%@", currentWeather.currentTemp, returnTempFormatFromUserDefaults())
    }
    
    func refreshData() {
        
        setupCurrentWeather()
        setupWeatherInfo()
        infoCollectionView.reloadData()
    }
    
    private func setupWeatherInfo(){
        
        let windInfo = WeatherInfo(infoText: String(format: "%.1f m/sec", currentWeather.windSpeed), imageLabel: getImageFor("wind"), nameText: nil)
        let humidity = WeatherInfo(infoText: String(format: "%.0f %%", currentWeather.humidity), imageLabel: getImageFor("humidity"), nameText: nil)
        let pressureInfo = WeatherInfo(infoText: String(format: "%.0f mb", currentWeather.pressure), imageLabel: getImageFor("pressure"), nameText: nil)
        let visibilityInfo = WeatherInfo(infoText: String(format: "%.0f km", currentWeather.visibilty), imageLabel: getImageFor("visibility"), nameText: nil)
        let feelsLikeInfo = WeatherInfo(infoText: String(format: "%.1f ", currentWeather.feelsLike), imageLabel: getImageFor("feelsLike"), nameText: nil)
        let uvInfo = WeatherInfo(infoText: String(format: "%.1f ", currentWeather.uv), imageLabel: nil, nameText: "UV Index")
        let sunriseInfo = WeatherInfo(infoText: currentWeather.sunrise, imageLabel: getImageFor("sunrise"), nameText: nil)
        let sunsetInfo = WeatherInfo(infoText:  currentWeather.sunSet, imageLabel: getImageFor("sunset"), nameText: nil)
        
        forecastInfoData = [windInfo, humidity, pressureInfo, visibilityInfo, feelsLikeInfo, uvInfo, sunriseInfo, sunsetInfo]
    }
}

extension WeatherView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
        cell.generateCell(forecast: weeklyForecastData[indexPath.row])
        return cell
    }
}


extension WeatherView: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == hourlyTempCollectionView {
            
           return hourlyForecastData.count
        }
        else
        {
           return forecastInfoData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyTempCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ForecastCollectionViewCell
            cell.generateCell(weather: hourlyForecastData[indexPath.row])
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! infoCollectionViewCell
            cell.generateCell(weatherInfo: forecastInfoData[indexPath.row])
            return cell
        }
    }
}














