import XCTest
@testable import Satellite

final class SatelliteTests: XCTestCase {
    enum SatelliteTestsError: Error, CustomStringConvertible {
        case noURLRequest

        var description: String {
            switch self {
            case .noURLRequest: return "There is no URL request created"
            }
        }
    }


    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssert(true)
    }

    func test_requestURL() throws {
        let info = SatelliteInfo()
        let feedback = Feedback(
            id: UUID().uuidString, 
            content: UUID().uuidString
        )
        let encodedFeedbackData = try JSONEncoder().encode(feedback)
        let request = FeedbackRequest(feedback: feedback)
        let urlRequest = try request.urlRequest(
            for: info.host,
            scheme: info.scheme,
            apiKey: info.apiKey
        )
        XCTAssertEqual((urlRequest.httpMethod ?? ""), "POST")
        XCTAssertEqual((urlRequest.httpBody ?? Data()), encodedFeedbackData)
    }

    func test_responsePublisher() {
        XCTAssert(true)
    }

    func test_response() {
        XCTAssert(true)
    }
}

import Foundation

struct SatelliteInfo {
    let host: String
    let scheme: Satellite.URLScheme
    let apiKey: String
    
    init(host: String = "ku-ring.com", scheme: Satellite.URLScheme = .https, apiKey: String = "") {
        self.host = host
        self.scheme = scheme
        self.apiKey = apiKey
    }
}

struct Feedback: Codable {
    let id: String
    let content: String
}

struct FeedbackRequest: Request, RequestableOnly {
    var version: Satellite.Version = .version("v1")
    var httpMethod: Satellite.Method = .post
    let path = "feedback"
    let queryItems: [URLQueryItem]? = nil

    // MARK: Data (HTTP Body)
    let feedback: Feedback

    init(feedback: Feedback) {
        self.feedback = feedback
    }

    func urlRequest(for host: String, scheme: Satellite.URLScheme, apiKey: String) throws -> URLRequest {
        var urlRequest = try defaultURLRequest(host: host, scheme: scheme, apiKey: apiKey)
        urlRequest.httpBody = try JSONEncoder().encode(feedback)
        return urlRequest
    }
}
