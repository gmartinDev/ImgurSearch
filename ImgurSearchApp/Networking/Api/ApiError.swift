//
//  ApiError.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//
import Foundation

enum ApiError: Error {
    case networkErrror(error: String)
    case invalidStatus(statusCode: Int)
    case serviceError
    case parseError
    case unknownError(error: String)
}

extension ApiError: LocalizedError {
    var localizedDescription: String? {
        switch self {
        case let .networkErrror(error):
            return "Network Error: \(error)"
        case let .invalidStatus(statusCode):
            return "Invalid status code: \(statusCode)"
        case .serviceError:
            return "A service error occurred"
        case .parseError:
            return "An error occurred during parsing"
        case let .unknownError(error):
            return "Error: \(error)"
        }
    }
}
