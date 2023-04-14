//
//  Satellite.Error.swift
//  
//
//  Created by Jaesung Lee on 2023/04/14.
//

import Foundation

extension Satellite {
    public enum NetworkError: Error, CustomStringConvertible {
        case apiKeyIsEmpty
        case requestIsInvalid
        case responseHasNoData
        case requestIsFailed
        case responseIsFailedToDecode
        case statusCode(_ statusCode: Int)
        
        public var description: String {
            switch self {
            case .apiKeyIsEmpty: return "API key is empty"
            case .requestIsInvalid: return "URL request is invalid"
            case .responseHasNoData: return "Response has no data"
            case .requestIsFailed: return "Request is failed"
            case .responseIsFailedToDecode: return "Response is failed decoding"
            case .statusCode(let statusCode): return "Status code: \(statusCode)"
            }
        }
    }
}
