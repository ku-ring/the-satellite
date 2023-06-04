import XCTest
@testable import Satellite

final class SatelliteTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Tests `GET "https://cat-fact.herokuapp.com/facts/random?animal_type=cat&amount=2"`
    /// - SeeAlso: [API Reference](https://alexwohlbruck.github.io/cat-facts/docs/endpoints/facts.html)
    func test_getTwoCatFacts() async throws {
        let satellite = Satellite(host: "cat-fact.herokuapp.com")
        let catFacts: [CatFact] = try await satellite.response(
            for: "facts/random",
            httpMethod: .get,
            queryItems: [
                URLQueryItem(name: "animal_type", value: "cat"),
                URLQueryItem(name: "amount", value: "2")
            ]
        )
        XCTAssertEqual(catFacts.count, 2)
        catFacts.forEach {
            XCTAssertFalse($0.text.isEmpty)
        }
    }
    
    func test_globalPrintingSystem() async throws {
        let satellite = Satellite(host: "cat-fact.herokuapp.com")
        satellite._startGPS()
        let _: [CatFact] = try await satellite.response(
            for: "facts/random",
            httpMethod: .get,
            queryItems: [
                URLQueryItem(name: "animal_type", value: "cat"),
                URLQueryItem(name: "amount", value: "2")
            ]
        )
        XCTAssertFalse(satellite._gpsLogs.isEmpty)
    }
}

struct CatFact: Codable {
    let text: String
}
