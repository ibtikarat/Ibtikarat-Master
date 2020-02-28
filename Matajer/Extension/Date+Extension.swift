//
//  Date.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 04/12/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation


extension Date{
    static func changeFormat(dateString: String ,toFormat: String = "dd MMM yyyy - hh:mm") -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = toFormat
        
        return formatter.string(from: Date.convertToData(date: dateString))
    }
    static func convertToData(date :String,formatText :String = "yyyy-MM-dd HH:mm:ss") -> Date{
          let formatter = DateFormatter()
           formatter.dateFormat = formatText
           return formatter.date(from: date) ?? Date()
       }
       
       func getElapsedInterval() -> String {
           
           let interval = Calendar.current.dateComponents([.year, .month, .day, .hour ,.minute], from: self, to: Date())
            //one_year_ago
            //two_years_ago
            //year
            //years
        
            //one_month_ago
            //two_months_ago
            //month
            //months
        
            //one_day_ago
            //two_days_ago
            //day
            //days
            //member_today
         

            //one_hour_ago
            //two_hours_ago
            //hour
            //hours
            //member_today

        
            //one_minute_ago
            //two_minutes_ago
            //minute
            //minutes
            
            //moments_ago
        
           if let year = interval.year, year > 0 {
               if year == 1 {
                return  "one_year_ago".localized
               }else if year == 2 {
                   return "two_years_ago".localized
               }else if year <= 10 {
                return  "\(year)" + " " + "years".localized
               }else{
                return  "\(year)" + " " + "year".localized
               }
               
           } else if let month = interval.month, month > 0 {
               if month == 1 {
                return  "one_month_ago".localized
               }else if month == 2 {
                   return "two_months_ago".localized
               }else if month <= 10 {
                   return   " " + "\(month)" + " " + "months"
               }else{
                   return   " " + "\(month)" + " " + "month"
               }
           } else if let day = interval.day, day > 0 {
               if day == 1 {
                return  "one_day_ago".localized
               }else if day == 2 {
                return "two_days_ago".localized
               }else if day <= 10 {
                return   "\(day)" + " " + "days".localized
               }else{
                return   "\(day)" + " " + "day".localized
            }
        } else  if let hour = interval.hour, hour > 0 {
               if hour == 1 {
                return  "one_hour_ago".localized
               }else if hour == 2 {
                return "two_hours_ago".localized
               }else if hour <= 10 {
                return  "\(hour)" + " " + "hours".localized
               }else{
                return "\(hour)" + " " + "hour".localized
               }
           }else if let minute = interval.minute, minute > 0 {
               if minute == 1 {
                return  "one_minute_ago".localized
               }else if minute == 2 {
                return "two_minutes_ago".localized
               }else if minute <= 10 {
                return  "\(minute)" + " " + "minutes".localized
               }else{
                return  "\(minute)" + " " + "minute".localized
               }
           }else{
            return "moments_ago".localized
           }
           
       }
       
       
       
    
    
    
    
    
    
    
    
    
    
    
    
//    func getElapsedInterval() -> String {
//
//             let interval = Calendar.current.dateComponents([.year, .month, .day, .hour ,.minute], from: self, to: Date())
//              //one_year_ago
//              //two_years_ago
//              //year
//              //years
//
//              //one_month_ago
//              //two_months_ago
//              //month
//              //months
//
//              //one_day_ago
//              //two_days_ago
//              //day
//              //days
//
//
//               //one_day_ago
//               //two_days_ago
//               //day
//               //days
//
//
//              //one_hour_ago
//              //two_hours_ago
//              //hour
//              //hours
//
//
//              //one_hour_ago
//              //two_hours_ago
//              //hour
//              //hours
//
//
//
//              //one_minute_ago
//              //two_minutes_ago
//              //minute
//              //minutes
//
//             if let year = interval.year, year > 0 {
//                 if year == 1 {
//                     return  "قبل سنة"
//                 }else if year == 2 {
//                     return "قبل سنتين"
//                 }else if year <= 10 {
//                     return  "قبل" + " " + "\(year)" + " " + "سنوات"
//                 }else{
//                     return  "قبل" + " " + "\(year)" + " " + "سنة"
//                 }
//
//             } else if let month = interval.month, month > 0 {
//                 if month == 1 {
//                     return  "قبل شهر"
//                 }else if month == 2 {
//                     return "قبل شهرين"
//                 }else if month <= 10 {
//                     return  "قبل" + " " + "\(month)" + " " + "شهور"
//                 }else{
//                     return  "قبل" + " " + "\(month)" + " " + "شهر"
//                 }
//             } else if let day = interval.day, day > 0 {
//                 if day == 1 {
//                     return  "قبل يوم"
//                 }else if day == 2 {
//                     return "قبل يومين"
//                 }else if day <= 10 {
//                     return  "قبل" + " " + "\(day)" + " " + "ايام"
//                 }else{
//                     return  "قبل" + " " + "\(day)" + " " + "يوم"
//                 }
//             } else  if let hour = interval.hour, hour > 0 {
//                 if hour == 1 {
//                     return  "قبل ساعة"
//                 }else if hour == 2 {
//                     return "قبل ساعتان"
//                 }else if hour <= 10 {
//                     return  "قبل" + " " + "\(hour)" + " " + "ساعات"
//                 }else{
//                     return  "قبل" + " " + "\(hour)" + " " + "ساعة"
//                 }
//             }else if let minute = interval.minute, minute > 0 {
//                 if minute == 1 {
//                     return  "قبل دقيقة"
//                 }else if minute == 2 {
//                     return "قبل دقيقتان"
//                 }else if minute <= 10 {
//                     return  "قبل" + " " + "\(minute)" + " " + "دقائق"
//                 }else{
//                     return  "قبل" + " " + "\(minute)" + " " + "دقيقة"
//                 }
//             }else{
//                 return "منذ لحظات"
//             }
//
//         }
       
    
}
