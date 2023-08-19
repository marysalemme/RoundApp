//
//  DateExtensionsTests.swift
//  RoundAppTests
//
//  Created by Mary Salemme on 19/08/2023.
//

import XCTest
@testable import RoundApp

final class DateExtensionsTests: XCTestCase {

    func testFormatDateToString() {
        let date = Date(timeIntervalSince1970: 1692463232)
        let expectedString = "19/08/23 17:40"
        XCTAssertEqual(date.formatToString(), expectedString)
    }
}
