//
//  ChooseCityViewController.swift
//  WeatherSoft
//
//  Created by Max on 12/09/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit

protocol ChooseCityViewControllerDelegte {
    func didAdd(newLocation: WeatherLocation)
}


class ChooseCityViewController: UIViewController {
    
    // MARK: IBOUTLETS
    @IBOutlet weak var chooseCityTableView: UITableView!
    
    // MARK:  vars
    var allLocations:  [WeatherLocation] = []
    var filteredLocations: [WeatherLocation] = []
    let searchController  = UISearchController(searchResultsController: nil)
    
    var savedLocation: [WeatherLocation]?
    let userDefaults = UserDefaults.standard
    
    var delegate: ChooseCityViewControllerDelegte?
    
    // MARK:  View LifeCycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFromUserDefaults()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseCityTableView.tableFooterView = UIView()
        setupSearchBar()
        chooseCityTableView.tableHeaderView = searchController.searchBar
        tapGestureRecognizer()
        loadLocationFromCSV()
        
    }
    
    private func tapGestureRecognizer()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.chooseCityTableView.backgroundView = UIView()
        self.chooseCityTableView.backgroundView?.addGestureRecognizer(tap)
    }
    @objc private func tableTapped() {
        dismissView()
    }
    
    
    // MARK:  setupSearchBar
    private func setupSearchBar() {
        
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
        
    }
    
    
    
    // MARK:  getLocationFucntions
    private func loadLocationFromCSV(){
        
        if let path = Bundle.main.path(forResource: "location", ofType: "csv")
        {
            parseCSVAt(url: URL(fileURLWithPath: path))
        }
    }
    
    private func parseCSVAt(url: URL)
    {
        do{
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")})
            {
                var i = 0
                for line in dataArr {
                    
                    if line.count > 2 && i != 0
                    {
                        createLcoation(line: line)
                    }
                    i += 1
                }
            }
        }
            
        catch {
            print("Error in parsing CSV file, ", error.localizedDescription)
        }
    }
    
    private func createLcoation(line: [String]) {
        
        allLocations.append(WeatherLocation(city: line.first!, country: line[1], countryCode: line.last!, isCurrentLocation: false))
        
    }
    
    // MARK:  UserDefaults
    
    private func saveToUserDefaults(location: WeatherLocation){
        
        if savedLocation != nil {
            
            if !savedLocation!.contains(location){
                
                savedLocation!.append(location)
            }
        }
        else
        {
            savedLocation = [location]
        }
        userDefaults.set(try? PropertyListEncoder().encode(savedLocation!), forKey: "Locations")
        userDefaults.synchronize()
    }
    
    private func loadFromUserDefaults() {
        
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocation = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
        }
    }
    
    
    
}

extension ChooseCityViewController: UISearchResultsUpdating {
    
    func filterContentForSearchText(searchText: String, scope: String = "All")
    {
        
        filteredLocations = allLocations.filter({ (location) -> Bool in
            return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
        })
        chooseCityTableView.reloadData()
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    
    private func dismissView() {
        
        if searchController.isActive {
            
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        }
        else
        {
            self.dismiss(animated: true)
        }
    }
    
}



extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let location = filteredLocations[indexPath.row]
        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveToUserDefaults(location: filteredLocations[indexPath.row])
        
        delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
        dismissView()
    }
    
}
