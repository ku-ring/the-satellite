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

public class Satellite {
    private static var radio = Radio(apiKey: "", domain: "")
    
    public static var key: String { radio.apiKey }
    
    // MARK: Setting up
    public static func setup(key: String, domain: String) {
        Self.radio = Radio(apiKey: key, domain: domain)
    }
    
    public static func response<RequestType: Request & Respondable>(from request: RequestType) async throws -> RequestType.ResponseType {
        try await Self.radio.response(from: request)
    }
    
    public static func send(_ request: Request & RequestableOnly) async throws {
        try await Self.radio.send(request)
    }
    
    public static func send<RequestType: Request & Respondable>(_ request: RequestType, willReceiveOn publisher: PassthroughSubject<RequestType.ResponseType, Error>) {
        Self.radio.send(request, willReceiveOn: publisher)
    }
}
