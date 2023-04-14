//
//  Sputnik.swift
//  
//
//  Created by Jaesung Lee on 2023/04/14.
//
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

import Foundation

class Radio {
    let host: String
    let scheme: Satellite.URLScheme
    let apiKey: String
    
    var cancellables: Set<AnyCancellable> = []
    
    init(host: String, scheme: Satellite.URLScheme = .https, apiKey: String = "") {
        self.host = host
        self.scheme = scheme
        self.apiKey = apiKey
    }
    
    func response<RequestType: Request & Respondable>(from request: RequestType) async throws -> RequestType.ResponseType {
        if apiKey.isEmpty {
            throw Satellite.NetworkError.apiKeyIsEmpty
        }
        var urlRequest = try request.urlRequest(for: host, scheme: scheme, apiKey: apiKey)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Satellite.NetworkError.requestIsFailed
        }
        guard (200..<300) ~= httpResponse.statusCode else {
            throw Satellite.NetworkError.statusCode(httpResponse.statusCode)
        }
        guard let output = try? JSONDecoder().decode(RequestType.ResponseType.self, from: data) else {
            throw Satellite.NetworkError.responseIsFailedToDecode
        }
        return output
    }
    
    func send(_ request: Request & RequestableOnly) async throws {
        if apiKey.isEmpty {
            throw Satellite.NetworkError.apiKeyIsEmpty
        }
        var urlRequest = try request.urlRequest(for: host, scheme: scheme, apiKey: apiKey)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Satellite.NetworkError.requestIsFailed
        }
        guard (200..<300) ~= httpResponse.statusCode else {
            throw Satellite.NetworkError.statusCode(httpResponse.statusCode)
        }
        return
    }
}

import Combine

extension Radio {
    func send<RequestType: Request & Respondable>(_ request: RequestType, willReceiveOn publisher: PassthroughSubject<RequestType.ResponseType, Error>) {
        if apiKey.isEmpty {
            publisher.send(completion: .failure(Satellite.NetworkError.apiKeyIsEmpty))
            return
        }
        guard var urlRequest = try? request.urlRequest(for: host, scheme: scheme, apiKey: apiKey) else {
            publisher.send(completion: .failure(Satellite.NetworkError.requestIsInvalid))
            return
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw Satellite.NetworkError.requestIsFailed
                }
                guard (200..<300) ~= httpResponse.statusCode else {
                    throw Satellite.NetworkError.statusCode(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: RequestType.ResponseType.self, decoder: JSONDecoder())
            .sink { completion in
                publisher.send(completion: completion)
            } receiveValue: { response in
                publisher.send(response)
            }
            .store(in: &cancellables)
        return
    }
}
