//
//  DateUtils.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/26/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation

class DateUtils {
    
    func getToday() -> Date {
        return Date();
    }
    
    func currentHour() -> Int {
        let currentHourInInt : Int = Calendar.current.component(.hour, from: Date())
        return currentHourInInt
    }
    
    func currentDateString() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let timeString = "\(year)-\(month)-\(day) \(hour)"
        return timeString
    }
    
    func currentDayString() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let timeString = "\(year)-\(month)-\(day)"
        return timeString
    }
    
    func stringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        let format = "yyyy-MM-dd HH"
        dateFormatter.dateFormat = format
        
        let dateFormated = dateFormatter.date(from: dateString)
        return dateFormated!
    }
    
    func getTodayWeekDay()-> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEEE"
           let weekDay = dateFormatter.string(from: Date())
           return weekDay
     }
}
