//
//  File.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 22/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation

class Address: Codable {

    var id: Int?
    var title, region, addressDetails :String
    let latitude: Double
    let longitude: Double
    let phone: String?
    var  isdefult: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, region
        case addressDetails = "details"
        case latitude = "lat"
        case longitude = "lng"
        case phone
 
        case isdefult = "is_default"
    }

    init(id: Int, title: String, region: String, addressDetails: String, latitude: Double, longitude: Double, phone: String, isdefult: Int) {
        self.id = id
        self.title = title
        self.region = region
        self.addressDetails = addressDetails
        self.latitude = latitude
        self.longitude = longitude
        self.isdefult = isdefult
        self.phone = phone
    }
    
    
    var  isDefult :Bool{
        get{
            return isdefult ?? 0 == 1
        }
        
        set{
            isdefult = newValue ? 1 : 0
        }
    }
}
