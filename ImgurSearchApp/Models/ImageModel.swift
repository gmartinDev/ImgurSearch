//
//  ImageModel.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

class ImageModel: Codable {
    enum ImageKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case link = "link"
    }
    
    let id: String
    let title: String
    let link: String
}
