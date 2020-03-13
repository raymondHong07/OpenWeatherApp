//
//  DateHelper.swift
//  OpenWeatherApp
//
//  Created by Raymond Hong on 2020-03-11.
//  Copyright © 2020 RH. All rights reserved.
//

import Foundation

// A helper class to extract the date and day of week needed to be shown in the UI
// from the API returned date format: "2020-03-12 12:00:00"
//
final class DateHelper {
    
    private static let formatter = DateFormatter()
    
    enum DateType {
        
        case dayOfWeek
        case monthAndDay
    }
    
    class func getDateFrom(_ dateString: String?, type: DateType) -> String {
        
        if let date = dateString {
            
            formatter.timeZone = TimeZone(abbreviation: "UTC")!
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedDate = formatter.date(from: date)
            
            formatter.dateFormat = type == DateType.dayOfWeek ? "EEEE" : "MMM dd"
            return formatter.string(from: formattedDate ?? Date())
        }
        
        return ""
    }
}
