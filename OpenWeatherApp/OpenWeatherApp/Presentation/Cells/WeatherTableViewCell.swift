//
//  WeatherTableViewCell.swift
//  OpenWeatherApp
//
//  Created by Raymond Hong on 2020-03-11.
//  Copyright © 2020 RH. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with weather: Weather.WeatherData) {
        
        selectionStyle = .none
        
        let temperature = Int(weather.forecast.temp ?? 0)
        let feelsLikeTemperature = Int(weather.forecast.feelsLike ?? 0)
        let humidity = weather.forecast.humidity ?? 0
        
        dayOfWeekLabel.text = DateHelper.getDateFrom(weather.date, type: .dayOfWeek)
        dateLabel.text = DateHelper.getDateFrom(weather.date, type: .monthAndDay)
        
        temperatureLabel.text = String(format: "%d°", temperature)
        feelsLikeLabel.text = String(format: "Feels like %d°", feelsLikeTemperature)
        humidityLabel.text = String(format: "Humidity %d%%", humidity)
        
        descriptionLabel.text = weather.weatherDescription.first?.description ?? ""
        getImage(for: weather)
    }
    
    private func getImage(for weather: Weather.WeatherData) {
        
        if let icon = weather.weatherDescription.first?.icon {
            
            let imageUrl = String(format: "https://openweathermap.org/img/wn/%@@2x.png", icon)
            ImageManager.shared.imageForUrl(urlString: imageUrl) { (image) in
                
                if let weatherImage = image {
                    
                    self.weatherIcon.image = weatherImage
                }
            }
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
