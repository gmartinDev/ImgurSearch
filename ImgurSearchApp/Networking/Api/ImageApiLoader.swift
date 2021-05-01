//
//  ImageApiLoader.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

import Foundation

class ImageApiLoader<T: ApiHandler> {
    private let request: T
    private let session: URLSession
    private var currentTask: URLSessionDataTask?
    
    init(apiRequest: T, urlSession: URLSession = .shared) {
        request = apiRequest
        session = urlSession
    }
    
    func loadRequest(requestData: T.RequestDataType, completion: @escaping (Swift.Result<T.ResponseDataType, ApiError>) -> Void) {
        
        guard let requestUrl = request.makeRequest(from: requestData)?.urlRequest else {
            print("Could not create request url")
            completion(.failure(.serviceError))
            return
        }
        
        if let task = currentTask {
            task.cancel()
        }
        
        currentTask = session.dataTask(with: requestUrl) { (data, response, error) in
            guard let data = data else {
                let error = error?.localizedDescription ?? "error: \(requestUrl.debugDescription)"
                completion(.failure(.networkErrror(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("could not retriece status code from response")
                completion(.failure(.networkErrror(error: "Unknown status code")))
                return
            }
            
            do {
                let parsedResponse = try self.request.parseResponse(data: data, statusCode: httpResponse.statusCode)
                completion(.success(parsedResponse))
            } catch {
                if let apiErr = error as? ApiError {
                    completion(.failure(apiErr))
                } else {
                    completion(.failure(.unknownError(error: error.localizedDescription)))
                }
            }
        }
        currentTask?.resume()
    }
}
