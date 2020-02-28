//
//  Category.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 25/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation


class Slider: Codable {
    let id: Int
    let image: String?


     enum CodingKeys: String, CodingKey {
         case id
         case image = "img"
        
     }

     init(id: Int, image: String?) {
         self.id = id
         self.image = image
     }
    
 
    
    
    var isSelected :Bool = false
}
