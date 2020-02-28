//
//  ShippingMethod.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 17/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class ShippingMethod: Codable {
    let id: Int?
    let deliveryTime: String?
    
    let img: String
    let price: String
    let title: String 
    
    var isSelected = false
    
 
    enum CodingKeys: String, CodingKey {
        case id
        case deliveryTime = "delivery_time"
        case price, title, img
    }

    init(id: Int, deliveryTime: String, price: String, title: String, img: String) {
        self.id = id
        self.deliveryTime = deliveryTime
        self.price = price
        self.title = title
        self.img = img
    }
}
