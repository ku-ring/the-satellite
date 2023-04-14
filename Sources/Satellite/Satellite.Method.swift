//
//  Satellite.Method.swift
//  
//
//  Created by Jaesung Lee on 2023/04/14.
//

import Foundation

extension Satellite {
    public enum Method: CustomStringConvertible {
        case post
        case get
        case delete
        case put
        
        public var description: String {
            switch self {
            case .post: return "POST"
            case .get: return "GET"
            case .delete: return "DELETE"
            case .put: return "PUT"
            }
        }
    }
}
