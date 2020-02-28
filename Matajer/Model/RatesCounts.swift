//
//  RatesCounts.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 15/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
class RatesCounts: Codable {
    let total :Double
    let one, two, three: Int
    let four, five: Int

    init(total: Double, one: Int, two: Int, three: Int, four: Int, five: Int) {
        self.total = total
        self.one = one
        self.two = two
        self.three = three
        self.four = four
        self.five = five
    }
}
