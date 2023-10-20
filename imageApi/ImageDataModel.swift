//
//  ImageDataModel.swift
//  imageApi
//
//  Created by N S on 20.10.2023.
//

import Foundation

struct ImageData: Codable {
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
    }
}

struct JSONResponse: Codable {
    let data: ImageData
}
