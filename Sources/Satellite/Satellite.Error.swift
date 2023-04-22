//
//  Satellite.Error.swift
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

extension Satellite {
    /// The enumeration that defines error cases used in ``Satellite``
    public enum Error: Swift.Error, CustomStringConvertible {
        case urlIsInvalid
        case requestIsInvalid
        case requestIsFailed
        case responseHasNoData
        case responseIsFailedDecoding
        case statusCode(_ statusCode: Int)
        
        /// The description of the error
        public var description: String {
            switch self {
            case .urlIsInvalid: return "URL is invalid"
            case .requestIsInvalid: return "URL request is invalid"
            case .requestIsFailed: return "Request is failed"
            case .responseHasNoData: return "Response has no data"
            case .responseIsFailedDecoding: return "Response is failed decoding"
            case .statusCode(let code): return "Status code: \(code)"
            }
        }
    }
}
