//
//  StarlingAPITests.swift
//  RoundAppTests
//
//  Created by Mary Salemme on 18/08/2023.
//

import XCTest
@testable import RoundApp

final class StarlingAPITests: XCTestCase {
    var sut: StarlingAPIClient!
    
    override func setUpWithError() throws {
        sut = StarlingAPIClient()
    }
    
    func testAppendHeadersMutatesRequest() {
        let url = URL(string: "www.google.com")!
        var request = URLRequest(url: url)

        sut.appendHeaders(to: &request)
        
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "User-Agent"), "RoundApp")
    }
    
    func testComposeURLReturnsExpectedURLForAccountsEndpoint() throws {
        let url = try sut.composeURL(for: .accounts)
        let expectedURL = URL(string: "https://api-sandbox.starlingbank.com/api/v2/accounts")
        XCTAssertEqual(url, expectedURL)
    }
}
