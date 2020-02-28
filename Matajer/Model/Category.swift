//
//  Category.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation


class Category: Codable {
    
       let id: Int?
       let name: String
       let image: String?
    
       let productCategories :[Category]?
    var products: [Product]?
       let tradeMarks: [TradeMark]?

    
    enum CodingKeys: String, CodingKey {
           case id
           case image = "img"
           case name
           case productCategories = "product_categories"
           case products
           case tradeMarks = "trade_marks"
       }

    init(id: Int, image: String, name: String) {
           self.id = id
           self.image = image
           self.name = name
           self.products = []
           self.tradeMarks = []
           self.productCategories = []
       }
    
    
    init(){
        self.id = 0
        self.image = ""
        self.name = ""
        self.products = []
        self.tradeMarks = []
        self.productCategories = []
    }
    
//
//    var name :String {
//        get{
//           return AppDelegate.shared.language == "ar" ? nameAr : nameEn
//        }
//    }
    
    //for visual selected
    var isSelected :Bool = false
    
    //for expanding or collabseing
    var isOpen : Bool = false

}



 
