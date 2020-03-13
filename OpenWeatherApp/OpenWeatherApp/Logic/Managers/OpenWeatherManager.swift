//
//  OpenWeatherManager.swift
//  OpenWeatherApp
//
//  Created by Raymond Hong on 2020-03-11.
//  Copyright © 2020 RH. All rights reserved.
//

import UIKit

final class OpenWeatherManager {
    
    private enum Request {
        
        static let token = "a94ace9be7994ce0beb8b5e27cefcd7b"
        static let baseUrl = "https://api.openweathermap.org/data/2.5/forecast?q=%@&appid=%@&units=%@"
    }
    
    static let sharedInstance = OpenWeatherManager()
    private let timeToCheckWeather = "12:00:00"
    
    var allWeather: [Weather.WeatherData] = []
    var city: String = "Toronto"
    var units: String = "Metric"
    
    func getFiveDayForecast(completion: @escaping (Bool) -> Void) {
        
        // Set request url with reference to Request enum for easy modification
        let requestUrlString = String(format: Request.baseUrl,
                                      city,
                                      Request.token,
                                      units)
        
        guard let url = URL(string: requestUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if err != nil {
                
                completion(false)
                
            } else {
                
                let decoder = JSONDecoder()
                guard let data = data else { return }
                
                do {
                    self.allWeather = []
                    let allWeatherData = try decoder.decode(Weather.self, from: data)
                    
                    for weather in allWeatherData.data {
                        // Only add weather data for 5 days at *12pm*
                        if let date = weather.date?.components(separatedBy: " "),
                            date.count == 2,
                            date[1] == self.timeToCheckWeather {
                            
                            self.allWeather.append(weather)
                        }
                    }
                } catch {
                    //Failed to decode JSON
                    completion(false)
                }
                
                completion(true)
            }
                        
        }.resume()
    }
}
