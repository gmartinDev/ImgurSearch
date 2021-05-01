//
//  ApiHandler.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

import Foundation

typealias ApiHandler = RequestHandler & ResponseHandler

// MARK: - Request Handler
protocol RequestHandler {
    associatedtype RequestDataType
    
    func makeRequest(from parameters: RequestDataType) -> Request?
}

extension RequestHandler {
    func set(headers: [String: String] = [:], urlRequest: inout URLRequest) {
        if !headers.isEmpty {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
    }
    
    func set(parameters: [String: String] = [:], urlComponents: URLComponents) -> URL? {
        var urlComponents = urlComponents
        guard !parameters.isEmpty else {
            return urlComponents.url
        }
        
        for parameter in parameters {
            let queryItem = URLQueryItem(name: parameter.key, value: parameter.value)
            urlComponents.queryItems?.append(queryItem)
        }
        return urlComponents.url
    }
}

// MARK: - Response Handler
protocol ResponseHandler {
    associatedtype ResponseDataType
    
    func parseResponse(data: Data, statusCode: Int) throws -> ResponseDataType
}

extension ResponseHandler {
    func defaultParseResponse<T: Codable>(data: Data, statusCode: Int) throws -> T {
        let jsonDecoder = JSONDecoder()
        
//        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        guard let genericResponseModel = try? jsonDecoder.decode(ImgurModelGeneric<T>.self, from: data) else {
            //If failed to parse try to decode error
            guard let errorModel = try? jsonDecoder.decode(ImgurModelGeneric<ImgurErrorModel>.self, from: data) else {
                print("Json could not decode data to specified model")
                throw ApiError.parseError
            }
            
            print("Json failed to parse to object - error was decoded")
            throw ApiError.unknownError(error: errorModel.data.error)
        }
        
        guard (200..<300) ~= statusCode  else {
            print("Request has invalid http status code: \(statusCode)")
            throw ApiError.invalidStatus(statusCode: statusCode)
        }
        
        return genericResponseModel.data
    }
}
