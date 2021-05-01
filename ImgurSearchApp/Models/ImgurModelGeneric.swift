//
//  ImgurModelGeneric.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 5/1/21.
//

class ImgurModelGeneric<T: Codable>: Codable {
    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case success = "success"
        case status = "status"
    }
    
    let data: T
    let success: Bool
    let status: Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        data = try container.decode(T.self, forKey: .data)
        success = try container.decode(Bool.self, forKey: .success)
        status = try container.decode(Int.self, forKey: .status)
    }
}
