//
//  Rating.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 15/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
class Rate: Codable {
    let rateValue: Int
    let username: String?
    let comment: String?
    var createdAt :String?  
    let images: [Image]
    let product: Product?

    enum CodingKeys: String, CodingKey {
        case rateValue = "rate_value"
        case comment
        case createdAt = "created_at"
        case username = "user_name"
        case images, product
    }

    init(rateValue: Int, comment: String, createdAt: String?, images: [Image], product: Product,username :String) {
        self.rateValue = rateValue
        self.comment = comment
        self.createdAt = createdAt
        self.images = images
        self.product = product
        self.username = username
    }
}
