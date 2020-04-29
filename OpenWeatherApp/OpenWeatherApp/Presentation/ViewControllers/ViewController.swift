//
//  ViewController.swift
//  OpenWeatherApp
//
//  Created by Raymond Hong on 2020-03-11.
//  Copyright © 2020 RH. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let openWeatherManager = OpenWeatherManager.sharedInstance
    private let locationManager = LocationManager()
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var noResultsLabel: UILabel!
    @IBOutlet private weak var activityLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        locationManager.setUp(with: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cityLabel.text = openWeatherManager.city
    }
    
    private func getUserLocation() {
        
        if let currentLocation = locationManager.currentLocation {
            
            locationManager.getLocation(for: currentLocation) { (placemark) in
               
               if let currentLocation = placemark,
                   let city = currentLocation.locality {
                    
                    self.cityLabel.text = city
                    self.openWeatherManager.city = city
                    self.getWeather()
               }
           }
        } else {
            
            getWeather()
        }
    }
    
    private func setUpTableView() {
        
        WeatherTableViewCell.register(with: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        // Remove extra empty cells from showing up in tableView
        tableView.tableFooterView = UIView()
    }
    
    @IBAction private func didTapSettingsButton(_ sender: Any) {
        
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
        settingsViewController.modalPresentationStyle = .overFullScreen
        present(settingsViewController, animated: true, completion: {})
    }
    
    private func checkForEmptyWeatherData() {
        
        noResultsLabel.isHidden = !openWeatherManager.allWeather.isEmpty
    }
    
    private func getWeather() {
        
        activityLoader.startAnimating()
        
        OpenWeatherManager.sharedInstance.getFiveDayForecast { (success) in

            if success {
                
                DispatchQueue.main.async {
                    self.activityLoader.stopAnimating()
                    self.tableView.reloadData()
                    self.checkForEmptyWeatherData()
                }
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        status == .authorizedWhenInUse ? getUserLocation() : getWeather()
    }
}

extension ViewController: SettingsViewControllerDelegate {
    
    func didTapClose() {
        
        getWeather()
        cityLabel.text = openWeatherManager.city
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return openWeatherManager.allWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier)
            as? WeatherTableViewCell else {

                fatalError("cellForRowAt error")
        }
        
        cell.configure(with: openWeatherManager.allWeather[indexPath.row])
        
        return cell
    }
}

