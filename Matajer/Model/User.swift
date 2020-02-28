//
//  User.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 10/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit

class User :Codable{
       let id: Int
        let name, email, mobile: String
        private let allowNotifi:String
        var apiToken: String?
        var birthday: String?
        var gender: String?
        var createdAtTimeAgo: String?
        var createdAt: String?

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case email, mobile
            case allowNotifi = "allow_notifi"
            case apiToken = "api_token"
            case birthday
            case gender
            case createdAtTimeAgo = "created_at_time_ago"
            case createdAt = "created_at"
        }

        init(id: Int, name: String, email: String, mobile: String, allowNotifi: String, apiToken: String) {
            self.id = id
            self.name = name
            self.email = email
            self.mobile = mobile
            self.allowNotifi = allowNotifi
            self.apiToken = apiToken
        }
    
    
    
    
    
    var timeAgo :String{
        get{
            return Date.convertToData(date: createdAt ?? "").getElapsedInterval()
        }
    }

    
    
    var isNotify :Bool {
        get{
            return allowNotifi == "1"
        }
    }
}
