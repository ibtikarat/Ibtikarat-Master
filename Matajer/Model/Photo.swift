//
//  File.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 16/10/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import Foundation
class Photo: Codable {
    let id: Int
    let modelType: String
    let modelID: Int
    let collectionName, name, fileName, mimeType: String
    let disk: String
    let size: Int
    let orderColumn: Int
    let createdAt, updatedAt, url, thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id
        case modelType = "model_type"
        case modelID = "model_id"
        case collectionName = "collection_name"
        case name
        case fileName = "file_name"
        case mimeType = "mime_type"
        case disk, size
        case orderColumn = "order_column"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case url, thumbnail
    }

    init(id: Int, modelType: String, modelID: Int, collectionName: String, name: String, fileName: String, mimeType: String, disk: String, size: Int,  orderColumn: Int, createdAt: String, updatedAt: String, url: String, thumbnail: String) {
        self.id = id
        self.modelType = modelType
        self.modelID = modelID
        self.collectionName = collectionName
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.disk = disk
        self.size = size

        self.orderColumn = orderColumn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.url = url
        self.thumbnail = thumbnail
    }
}
