//
//  AllLocationsTableViewController.swift
//  WeatherSoft
//
//  Created by Max on 16/09/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit

protocol AllLocationsTableViewControllerDelegate {
    func chooseLocation(atIndex: Int, shouldRefresh: Bool)
}

class AllLocationsTableViewController: UITableViewController {

    // MARK:  IBOutlets
    @IBOutlet weak var tempSegmentoutlet: UISegmentedControl!
    @IBOutlet weak var footerView: UIView!
    

    
    
    // MARK:  Vars
    var savedLocation: [WeatherLocation]?
    var userDefaults = UserDefaults.standard
    var weatherData: [CityTempData]?
    var delegate: AllLocationsTableViewControllerDelegate?
    var shouldRefresh = false
    
    
    // MARK: View lifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTempFormatFromUserDefaults()
        loadLocationsFromUserDefaults()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainWeatherTableViewCell
        cell.generateCell(weatherData: weatherData![indexPath.row])
        return cell
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "allLocationSeg" {
            
            let vc = segue.destination as! ChooseCityViewController
            vc.delegate = self
        }
    }
    
    // MARK:  IBActions
    
    @IBAction func tempSegmentControl(_ sender: UISegmentedControl) {
        updateTempFormatInUserDefaults(newValue: sender.selectedSegmentIndex)
    }
    
   

    // MARK:  tableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.chooseLocation(atIndex: indexPath.row, shouldRefresh: shouldRefresh)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.row != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let locationToDelete = weatherData?[indexPath.row]
            weatherData?.remove(at: indexPath.row)
            deleteFromUserDefaults(location: locationToDelete!.city)
            tableView.reloadData()
            
        }
    }
 
    // MARK:  LoadFromUserDefault
    
    private func updateTempFormatInUserDefaults(newValue: Int)
    {
        shouldRefresh = true
        userDefaults.set(newValue, forKey: "tempFormat")
        userDefaults.synchronize()
    }
    
    private func loadTempFormatFromUserDefaults()
    {
        if let index = userDefaults.value(forKey: "tempFormat")
        {
            tempSegmentoutlet.selectedSegmentIndex = index as! Int
        }
        else
        {
            tempSegmentoutlet.selectedSegmentIndex = 0
        }
    }
    
    private func loadLocationsFromUserDefaults() {
        
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocation = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        }
        //print(savedLocation!.count)
    }
    private func deleteFromUserDefaults(location: String)
    {
        if savedLocation != nil {
            
            for i in  0..<savedLocation!.count
            {
                let tempLocation = savedLocation![i]
                
                if tempLocation.city == location
                {
                    savedLocation!.remove(at: i)
                    saveNewLocationToUserDefaults()
                    return
                }
            }
        }
    }
    
    private func saveNewLocationToUserDefaults() {
        shouldRefresh = true
        userDefaults.set(try? PropertyListEncoder().encode(savedLocation!), forKey: "Locations")
        userDefaults.synchronize()
    }
    
}

extension AllLocationsTableViewController: ChooseCityViewControllerDelegte {
    
    func didAdd(newLocation: WeatherLocation) {
        shouldRefresh = true
        
        weatherData?.append(CityTempData(city: newLocation.city, temp: 0.0))
        tableView.reloadData()
    }
    
    
    
}
