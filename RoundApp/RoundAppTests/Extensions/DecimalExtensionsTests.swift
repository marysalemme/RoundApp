//
//  DecimalExtensionsTests.swift
//  RoundAppTests
//
//  Created by Mary Salemme on 20/08/2023.
//

import XCTest
@testable import RoundApp

final class DecimalExtensionsTests: XCTestCase {
    func testRoundedUpReturnsExpectedResult() {
        let decimal = Decimal(1.15)
        let expected = Decimal(2)
        XCTAssertEqual(decimal.roundedUp(), expected)
    }
}
