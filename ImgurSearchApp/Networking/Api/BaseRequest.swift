//
//  BaseRequest.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

import Foundation

protocol Request {
    var urlRequest: URLRequest { get }
}

class BaseRequest: Request {
    private var request: URLRequest
    
    init(_ urlRequest: URLRequest) {
        request = urlRequest
    }
    
    var urlRequest: URLRequest {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
