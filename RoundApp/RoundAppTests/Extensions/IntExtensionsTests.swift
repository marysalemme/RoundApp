//
//  IntExtensionsTests.swift
//  RoundAppTests
//
//  Created by Mary Salemme on 19/08/2023.
//

import XCTest
@testable import RoundApp

final class IntExtensionsTests: XCTestCase {

    func testToDecimal() {
        let minorUnit = 2350
        let expectedDecimal = Decimal(floatLiteral: 23.50)
        XCTAssertEqual(minorUnit.toDecimal(), expectedDecimal)
    }
}
