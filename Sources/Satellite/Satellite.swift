/**
 MIT License

 Copyright (c) 2023 Kuring

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Combine
import Foundation

/// The main class responsible for API communication.
public class Satellite {
    /// URL Scheme such as `http` or `https`. See ``Satellite/Scheme``
    public let scheme: Scheme
    /// The host domain such as `apple.com` or `icloud.com`.
    public let host: String
    
    /// The base URL that is a combination of ``scheme`` and ``host``.
    /// `https://apple.com`
    public var baseURL: String {
        "\(scheme.rawValue)://\(host)"
    }
    
    /// Creates a new ``Satellite`` instance.
    /// - Parameters:
    ///    - host: The host domain such as `apple.com`
    ///    - scheme: The URL scheme such as `http`. The default value is `https`
    public init(host: String, scheme: Scheme = .https) {
        self.host = host
        self.scheme = scheme
    }
    
    /// Creates a new URL request and returns the response asyncronously.
    /// - Parameters:
    ///    - uri: The URI. e.g., "search/user". If you need to add `/api` or `/v1`, please explict together.
    ///    - httpMethod: ``Satellite/HTTPMethod`` object.
    ///    - queryItems: (Optional) The array of `URLQueryItem` objects.
    ///    - httpBody: (Optional) The object that conforms to `Encodable`.
    /// - Returns: The object that is an expected response which conforms to `Decodable`.
    public func response<ResponseType: Decodable>(
        for uri: String,
        httpMethod: Satellite.HTTPMethod,
        queryItems: [URLQueryItem]? = nil,
        httpBody: (any Encodable)? = nil
    ) async throws -> ResponseType {
        guard var components = URLComponents(string: "\(baseURL)/\(uri)") else {
            throw Satellite.Error.urlIsInvalid
        }
        if let queryItems {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw Satellite.Error.urlIsInvalid
        }
        var urlRequest = URLRequest(url: url, timeoutInterval: 5.0)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = httpMethod.rawValue
        if let httpBody = httpBody {
            urlRequest.httpBody = try JSONEncoder().encode(httpBody)
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Satellite.Error.responseHasNoData
        }
        guard (200..<300) ~= httpResponse.statusCode else {
            throw Satellite.Error.statusCode(httpResponse.statusCode)
        }
        guard let output = try? JSONDecoder().decode(ResponseType.self, from: data) else {
            throw Satellite.Error.responseIsFailedDecoding
        }
        return output
    }

    /// Creates a new URL request and returns the publisher that sends response object as its value.
    /// - Parameters:
    ///    - uri: The URI. e.g., "search/user". If you need to add `/api` or `/v1`, please explict together.
    ///    - httpMethod: ``Satellite/HTTPMethod`` object.
    ///    - queryItems: (Optional) The array of `URLQueryItem` objects.
    ///    - httpBody: (Optional) The object that conforms to `Encodable`.
    /// - Returns: `AnyPublisher` that publishes the response which conforms to `Decodable`.
    public func responsePublisher<ResponseType: Decodable>(
        for uri: String,
        httpMethod: HTTPMethod,
        queryItems: [URLQueryItem]? = nil,
        httpBody: (any Encodable)? = nil
    ) throws -> AnyPublisher<ResponseType, Swift.Error> {
        guard var components = URLComponents(string: "\(baseURL)/\(uri)") else {
            throw Satellite.Error.urlIsInvalid
        }
        if let queryItems {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw Satellite.Error.urlIsInvalid
        }
        var urlRequest = URLRequest(url: url, timeoutInterval: 5.0)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = httpMethod.rawValue
        if let httpBody = httpBody {
            urlRequest.httpBody = try JSONEncoder().encode(httpBody)
        }
        let publisher = URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw Satellite.Error.requestIsFailed
                }
                guard (200..<300) ~= httpResponse.statusCode else {
                    throw Satellite.Error.statusCode(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: ResponseType.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        return publisher
    }
}
