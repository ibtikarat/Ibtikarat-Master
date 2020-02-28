//
//  ShippingMethods.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 18/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation


class ShippingMethods: Codable {
    let id: Int
    let promoCode, type, amount: String

    enum CodingKeys: String, CodingKey {
        case id
        case promoCode = "promo_code"
        case type, amount
    }

    init(id: Int, promoCode: String, type: String, amount: String) {
        self.id = id
        self.promoCode = promoCode
        self.type = type
        self.amount = amount
    }
}


