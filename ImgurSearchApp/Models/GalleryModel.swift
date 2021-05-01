//
//  GalleryModel.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

class GalleryModel: Codable {
    enum GalleryKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case imageCount = "images_count"
        case images = "images"
    }
    
    let id: String
    let title: String?
    let imageCount: Int?
    let images: [ImageModel]?
}
