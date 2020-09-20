//
//  ViewController.swift
//  WeatherSoft
//
//  Created by Max on 22/07/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // MARK:  Vars
    let userDefault = UserDefaults.standard
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    
    var allLocation: [WeatherLocation] = []
    var allWeatherView: [WeatherView] = []
    var allWeatherData: [CityTempData] = []
    
    var shouldRefresh = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerStart()
        scrollView.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if shouldRefresh {
        allLocation = []
        allWeatherView = []
        removeWeatherFromScrollView()
        locationAuthCheck()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManagerStop()
    }
    // MARK:  download Weather
    
    
    private func getWeather() {
        
        loadLocationFromUserDefaults()
        createWeatherViews()
        addWeatherToScrollView()
        setPageControl()
    }
    
    private func createWeatherViews(){
        
        for _ in allLocation {
            
            allWeatherView.append(WeatherView())
        }
    }
    private func removeWeatherFromScrollView()
    {
        for view in scrollView.subviews
        {
            view.removeFromSuperview()
        }
    }
    
    private func addWeatherToScrollView(){
        
        for i in 0..<allWeatherView.count {
            
            let view = allWeatherView[i]
            let location = allLocation[i]
            
            downloadCurrentWeather(weatherview: view, location: location)
            downloadHourlyWeather(weatherview: view, location: location)
            downlaodWeeklyWeather(weatherview: view, location: location)
            
            let xPos = self.view.frame.width * CGFloat(i)
            view.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            
            scrollView.addSubview(view)
            scrollView.contentSize.width = view.frame.width * CGFloat(i + 1)
        }
    }
    
    private func downloadCurrentWeather(weatherview: WeatherView, location: WeatherLocation)
    {
        weatherview.currentWeather = CurrentWeather()
        weatherview.currentWeather.getCurrentWeather(location: location) { (success) in
            
            weatherview.refreshData()
            self.generateWeatherList()
        }
    }
    
    private func downloadHourlyWeather(weatherview: WeatherView, location: WeatherLocation)
    {
        HourlyForecast.getHourlyWeather(location: location) { (hourlyForecasts) in
            
            weatherview.hourlyForecastData = hourlyForecasts
            weatherview.hourlyTempCollectionView.reloadData()
        }
    }
    
    private func downlaodWeeklyWeather(weatherview: WeatherView, location: WeatherLocation)
    {
        WeeklyForecast.getWeeklyWeather(location: location) { (weeklyForecasts) in
            
            weatherview.weeklyForecastData = weeklyForecasts
            
            weatherview.tabelView.reloadData()
        }
    }
    // MARK:  LoadLocationFromUserDefaults
    
    private func loadLocationFromUserDefaults(){
        
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)
        
        if let data = userDefault.value(forKey: "Locations") as? Data
        {
            allLocation = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
            allLocation.insert(currentLocation, at: 0)
        }
        else
        {
            print("no data saved in user defaults")
            allLocation.append(currentLocation)
        }
    }
    
    // MARK:  Page Control
    
    private func setPageControl()
    {
        pageControl.numberOfPages = allWeatherView.count
        
    }
    
    private func updatedPageControl(currentPage: Int)
    {
        pageControl.currentPage = currentPage
    }
    
    // MARK:  Location Manager
    
    
    private func locationManagerStart()
    {
        if locationManager == nil {
            
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager?.delegate = self
        }
        
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    
    private func locationManagerStop() {
        
        if locationManager != nil {
            
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    
    private func locationAuthCheck() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            currentLocation = locationManager!.location?.coordinate
            
            if currentLocation != nil {
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.longitude = currentLocation.longitude
                getWeather()
            }
            else
            {
                locationAuthCheck()
            }
        }else {
            locationManager?.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
    }
    
    private func generateWeatherList()
    {
        allWeatherData = []
        
        for weatherView in allWeatherView {
            
            allWeatherData.append(CityTempData(city: weatherView.currentWeather.city, temp: weatherView.currentWeather.currentTemp))
            
        }
    }
    
    
    // MARK:  Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pathToallLocationSegue"
        {
            let vc = segue.destination as! AllLocationsTableViewController
            vc.weatherData = allWeatherData
            vc.delegate = self
        }
    }

    
}

extension ViewController: AllLocationsTableViewControllerDelegate {
    func chooseLocation(atIndex: Int, shouldRefresh: Bool) {
        
        let viewNumber = CGFloat(integerLiteral: atIndex)
        let newOffset = CGPoint(x: (scrollView.frame.width + 1.0) * viewNumber, y: 0)
        scrollView.setContentOffset(newOffset, animated: true)
        updatedPageControl(currentPage: atIndex)
        self.shouldRefresh = shouldRefresh
    }
    
    
    
}



extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get the Location, \(error.localizedDescription)")
    }
}
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        updatedPageControl(currentPage: Int(round(value)))
    }
    
}



