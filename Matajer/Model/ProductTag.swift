//
//  ProductTag.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 19/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
class ProductTag: Codable {
    let id: Int
    private let name: String
    private let created_at: String
    private let updated_at: String
    private let deleted_at: String?
}
