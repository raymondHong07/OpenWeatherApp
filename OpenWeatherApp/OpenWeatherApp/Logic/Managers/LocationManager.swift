//
//  LocationManager.swift
//  OpenWeatherApp
//
//  Created by Raymond Hong on 2020-04-29.
//  Copyright © 2020 RH. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager {
    
    
    private let locationManager = CLLocationManager()
    
    public var currentLocation: CLLocation? {
        return self.locationManager.location
    }
    
    override init() {
        super.init()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - Primary Location Functions
extension LocationManager {
    
    func setUp(with viewController: ViewController) {
        
        locationManager.delegate = viewController
    }
    
    func getLocation(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}
