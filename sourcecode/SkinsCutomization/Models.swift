//
//  Models.swift
//  Skins
//
//  Created by Work on 4/14/20.
//  Copyright © 2020 Work. All rights reserved.
//

import Foundation

struct ProdesignSubCategoryModel: Codable {
    let image, compressedFile, name, prodesignSubCategoryModelDescription: String
    let createdAt, categoryID, id: String

    enum CodingKeys: String, CodingKey {
        case image
        case compressedFile = "compressed_file"
        case name
        case prodesignSubCategoryModelDescription = "description"
        case createdAt = "created_at"
        case categoryID = "category_id"
        case id
    }
}

struct ProdesignWallpaperModel: Codable {
    let prodesignWallpaperModelDescription, categories, createdAt, price: String
    let compressedFile, filePath, sku: String
    let splittedTags, categoryIDS: [String]
    let id: String
    let tags: String?

    enum CodingKeys: String, CodingKey {
        case prodesignWallpaperModelDescription = "description"
        case categories
        case createdAt = "created_at"
        case price
        case compressedFile = "compressed_file"
        case filePath = "file_path"
        case sku
        case splittedTags = "splitted_tags"
        case categoryIDS = "category_ids"
        case id, tags
    }
}

