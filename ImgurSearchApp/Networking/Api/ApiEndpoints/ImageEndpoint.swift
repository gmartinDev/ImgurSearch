//
//  ImageEndpoint.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

import Foundation

struct ImageEndpoint: ApiHandler {
    private func getDefaultHeaders() -> [String: String] {
        return [
            "Authorization": "Client-ID \(ApiConstants.imgurClientID)"
        ]
    }
    
    func makeRequest(from parameters: [String: String] = [:]) -> Request? {
        guard let urlComponents = URLComponents(string: ApiConstants.EndPoints.gallerySearch),
              let url = set(parameters: parameters, urlComponents: urlComponents)
        else {
            print("Error - could not create recipe url from string")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        set(headers: getDefaultHeaders(), urlRequest: &urlRequest)

        return BaseRequest(urlRequest)
    }

    func parseResponse(data: Data, statusCode: Int) throws -> [GalleryModel] {
        return try defaultParseResponse(data: data, statusCode: statusCode)
    }
}
