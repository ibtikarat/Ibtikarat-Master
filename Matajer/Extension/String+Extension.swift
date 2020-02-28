//
//  String.swift
//  SmartSafty
//
//  Created by Abdullah Ayyad on 10/18/19.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation

extension String
{
    var localized: String {
        return NSLocalizedString(self, comment: self) //NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    //cut first caracters from full names
    public func getAcronyms(separator: String = "") -> String {
        let acronyms = self.components(separatedBy: " ").map({ String($0.first!) }).joined(separator: separator);
        return acronyms;
    }
    //remove spaces from text
    var trimmed:String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isEmailValid: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    
    
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    
    func getFormatedNumber()->String{
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.locale = Locale(identifier: "en")
        return fmt.string(from: NSNumber(value: Double(self) ?? 0))!
    }
    
    
    
    var valueWithCurrency :String{
        get{
            return self + " " + (AppDelegate.shared.language == "ar" ? "ر.س" : "SAR") 
        }
    }
    
    
    
    var htmlAttributedString : NSAttributedString? {
        
        get{
           guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
           guard let html = try? NSMutableAttributedString(
               data: data,
               options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
               documentAttributes: nil) else { return nil }
           return html
        }
       }
    
    
    
}
