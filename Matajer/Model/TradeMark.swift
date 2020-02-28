//
//  Marka.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 17/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
class TradeMark: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image = "img"
        case products
    }

    init(id: Int, name: String,image: String) {
        self.id = id
        self.name = name
        self.image = image
        products = []
    }
    
    
    
    
//    var name :String {
//        get{
//           return AppDelegate.shared.language == "ar" ? nameAr : nameEn
//        }
//    }
//
//
    
    
}
