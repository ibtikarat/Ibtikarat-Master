//
//  Notification.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 14/11/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
class Notification: Codable {
    let  createdAt, title: String
    let _modelId :String?
    let model :String?
    let content: String
    let id :Int
    var _isSeen :Int?
    
    enum CodingKeys: String, CodingKey {
        case model
        case _modelId = "model_id"
        case createdAt = "created_at"
        case _isSeen = "is_seen"
        case id
        case title, content
    }

    init(model: String, modelID: String, createdAt: String, title: String, content: String) {
        self.model = model
        self._modelId = modelID
        self.createdAt = createdAt
        self.title = title
        self.content = content
        self.id = 0
        self._isSeen = 0
     }
    
    
    
    var isSeen :Bool{
        get{
            return (_isSeen ?? 0) == 1
        }
    }
    
    var modelId :Int? {
        get{
            return Int(_modelId ?? "0")
        }
    }
}
