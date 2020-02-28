//
//  AppContent.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 17/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
class AppContent: Codable {
    let items: [Item]

    init(items: [Item]) {
        self.items = items
    }
    
    
    var email :String {
        get{
            return items.first(where: {$0.keyName == "email"})?.valueText ?? ""
        }
    }
    
    var appStore: String{
        get{
            return items.first(where: {$0.keyName == "appStore"})?.valueText ?? ""
        }
    }
 
    
    private var aboutApp_ar :String {
        get{
            return items.first(where: {$0.keyName == "aboutApp_ar"})?.valueText ?? ""
        }
    }
    
    
    
    
   private var aboutApp_en :String {
        get{
            return items.first(where: {$0.keyName == "aboutApp_en"})?.valueText ?? ""
        }
    }
        
    
    var aboutApp :String {
            get{
               return AppDelegate.shared.language == "ar" ? aboutApp_ar : aboutApp_en
            }
    }
    
    var cashOnDeliveryCost :String {
        get{
            return items.first(where: {$0.keyName == "cash_on_delivery_cost"})?.valueText ?? ""
        }
    }
    
    
    
    
    
     var taxPercentage :String {
         get{
             return items.first(where: {$0.keyName == "tax_percentage"})?.valueText ?? ""
         }
     }
     
    
    
    
    
    private var termsAndConditions_ar :String {
         get{
             return items.first(where: {$0.keyName == "termsAndConditions_ar"})?.valueText ?? ""
         }
     }
     
    
    
    var instagram :String {
           get{
               return items.first(where: {$0.keyName == "instagram"})?.valueText ?? ""
           }
       }
    
    
    private var termsAndConditions_en :String {
         get{
             return items.first(where: {$0.keyName == "termsAndConditions_en"})?.valueText ?? ""
         }
     }
     
    
    
    
    
    var termsAndConditions :String {
            get{
               return AppDelegate.shared.language == "ar" ? termsAndConditions_ar : termsAndConditions_en
            }
    }
    
    
    
     var logo :String {
         get{
             return items.first(where: {$0.keyName == "logo"})?.valueText ?? ""
         }
     }
     
    
    
    
    
    
    
     var facebook :String {
         get{
             return items.first(where: {$0.keyName == "facebook"})?.valueText ?? ""
         }
     }
     
    
    
  
    
    
    
     var whatsaap :String {
         get{
             return items.first(where: {$0.keyName == "whatsapp"})?.valueText ?? ""
         }
     }
     
    
    
       var twitter :String {
           get{
               return items.first(where: {$0.keyName == "twitter"})?.valueText ?? ""
           }
       }
       
      
    
    
    
     var snapchat :String {
         get{
             return items.first(where: {$0.keyName == "snapchat"})?.valueText ?? ""
         }
     }
     
    
    
    
    
    
     var websiteURL :String {
         get{
             return items.first(where: {$0.keyName == "websiteURL"})?.valueText ?? ""
         }
     }
     
    
    
    
    
     var phone :String {
         get{
             return items.first(where: {$0.keyName == "phone"})?.valueText ?? ""
         }
     }
     
    
    
    
     var appName :String {
         get{
             return items.first(where: {$0.keyName == "app_name"})?.valueText ?? ""
         }
     }
     
    
    
    
    
    
     var api_url :String {
         get{
             return items.first(where: {$0.keyName == "api_url"})?.valueText ?? ""
         }
     }
     
    
    
    
    
    
    
    
     var primaryColor :String {
         get{
             return items.first(where: {$0.keyName == "primary_color"})?.valueText ?? ""
         }
     }
     
 
     var primaryColorDark :String {
         get{
             return items.first(where: {$0.keyName == "primary_color_dark"})?.valueText ?? ""
         }
     }
     
    
    
    var font_color :String {
         get{
             return items.first(where: {$0.keyName == "font_color"})?.valueText ?? ""
         }
     }
    
    
    
}


class Item: Codable {
    let keyName: String
    let valueText: String

    enum CodingKeys: String, CodingKey {
        case keyName = "key_name"
        case valueText = "value_text"
    }

    init(keyName: String, valueText: String) {
        self.keyName = keyName
        self.valueText = valueText
    }
}


