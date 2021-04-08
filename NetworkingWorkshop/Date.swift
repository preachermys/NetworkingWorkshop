//
//  Date.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import Foundation

extension Date {
    
    func unixTime(of dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ" //Your date format
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return Date()
    }
    
    func unixTimeForFavorites(from stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: stringDate) {
            return date
        }
    
        return Date()
    }
    
    func getDate(from string: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        if let formattedDate = format.date(from: string) {
            let calendar = Calendar.current
            let year = String(calendar.component(.year, from: formattedDate))
            
            let month: String
            if calendar.component(.month, from: formattedDate) < 10 {
                month = "0" + String(calendar.component(.month, from: formattedDate))
            } else {
                month = String(calendar.component(.month, from: formattedDate))
            }
            
            let day: String
            if calendar.component(.day, from: formattedDate) < 10 {
                day = "0" + String(calendar.component(.day, from: formattedDate))
            } else {
                day = String(calendar.component(.day, from: formattedDate))
            }

            let hour = String(calendar.component(.hour, from: formattedDate))
            
            let minute: String
            if calendar.component(.minute, from: formattedDate) < 10 {
                minute = "0" + String(calendar.component(.minute, from: formattedDate))
            } else {
                minute = String(calendar.component(.minute, from: formattedDate))
            }
            
            let date = day + "." + month + "." + year + " "
            let time = " " + hour + ":" + minute
            return date + "in " + time
        }
        
        return ""
    }
    
    static func trimmedTime(_ completedAt: Date, isDotSeparator: Bool) -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        isDotSeparator
            ? (dateFormatter.dateFormat = "dd.MM.yyyy HH:mm")
            : (dateFormatter.dateFormat = "dd-MM-yyyy HH:mm")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let fullDate = dateFormatter.string(from: completedAt)
        let date = String(fullDate.split(separator: " ")[0])
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: completedAt)
        return (date, time)
    }
}

