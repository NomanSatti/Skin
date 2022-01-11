//
//  DateHelper.swift
//  Skins
//
//  Created by Work on 2/26/20.
//  Copyright © 2020 Work. All rights reserved.
//


import UIKit

class DateHelper: NSObject {
    
    static let sharedInstance = DateHelper()
    let dateFormatter: DateFormatter = DateFormatter()

    
    class func dateFromString(_ dateString: String?, dateFormat: String = K.DateTimeFormatStandard) -> Date? {
        
        if let dateString = dateString {
            
            let dateHelper = DateHelper.sharedInstance
            dateHelper.dateFormatter.dateFormat = dateFormat
            
            let dateObj = dateHelper.dateFormatter.date(from: dateString)
            return dateObj
            
        } else {
            return nil
        }
    }
    
    class func stringFromDate(_ date: Date, dateFormat: String = K.DateTimeFormatStandard) -> String? {
        
        let dateHelper = DateHelper.sharedInstance
        dateHelper.dateFormatter.dateFormat = dateFormat
        
        let dateStr = dateHelper.dateFormatter.string(from: date)
        return dateStr
    }
    
    class func dateStringFromString(_ dateString: String?, inputDateFormat: String = K.DateTimeFormatStandard, outputDateFormat: String = K.DateTimeFormatStandard2) -> String? {
        
        if let dateObj = DateHelper.dateFromString(dateString, dateFormat: inputDateFormat) {
            
            return DateHelper.stringFromDate(dateObj, dateFormat: outputDateFormat)
            
        } else {
            return nil
        }
    }
    
    class func UTCFormattedCurrentDate() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = K.DateTimeFormatStandard3
        
        let currentDate = dateFormatter.string(from: Date())
     
        return dateFormatter.date(from: currentDate)!
    }
    
    class func UTCFormattedDate(_ date: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = K.DateTimeFormatStandard3
        
        return dateFormatter.date(from: date)!
    }
    
    class func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
        
    }
    
}
