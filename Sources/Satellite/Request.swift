//
//  Request.swift
//  
//
//  Created by Jaesung Lee on 2023/04/14.
//

import Foundation

public protocol Request {
    var version: Satellite.Version { get }
    var httpMethod: Satellite.Method { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }

    func urlRequest(for host: String, scheme: Satellite.URLScheme, apiKey: String) throws -> URLRequest

    func defaultURLRequest(host: String, scheme: Satellite.URLScheme, apiKey: String) throws -> URLRequest
}

extension Request {
    func urlRequest(for host: String, scheme: Satellite.URLScheme, apiKey: String) throws -> URLRequest {
        try defaultURLRequest(host: host, scheme: scheme, apiKey: apiKey)
    }

    func defaultURLRequest(host: String, scheme: Satellite.URLScheme, apiKey: String) throws -> URLRequest {
        guard var components = URLComponents(string: "\(scheme.description)\(host)/\(path)") else {
            throw Satellite.NetworkError.urlIsInvalid
        }
        if let queryItems {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw Satellite.NetworkError.urlIsInvalid
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = httpMethod.description
        urlRequest.timeoutInterval = 5.0
        return urlRequest 
    }
}

public protocol Respondable {
    associatedtype ResponseType: Response
}

public protocol RequestableOnly { }

