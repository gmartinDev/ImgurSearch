//
//  ApiConstants.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

import Foundation

struct ApiConstants {
    static let baseUrl: String = "https://api.imgur.com/3"
    static let imgurClientID: String = "a8f9347a23f012f"
    
    struct EndPoints {
        static let gallerySearch = "\(ApiConstants.baseUrl)/gallery/search"
    }
}
