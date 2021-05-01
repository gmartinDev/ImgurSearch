//
//  ImgurModelGeneric.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 5/1/21.
//

class ImgurModelGeneric<T: Codable>: Codable {
    let data: T
    let success: Bool
    let status: Int
}
