//
//  TransactionsViewModelTests.swift
//  RoundAppTests
//
//  Created by Mary Salemme on 19/08/2023.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import RoundApp

final class TransactionsViewModelTests: XCTestCase {
    
    var sut: TransactionsViewModel!
    var mockRepository: StarlingRepositoryType!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUpWithError() throws {
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        mockRepository = MockStarlingRepository()
        sut = TransactionsViewModel(repository: mockRepository)
    }
    
    func testScreenTitle() {
        sut.loadAccountTransactions()
        let driver = sut.screenTitle.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first(), "Personal Account")
    }
    
    func testTransactions() {
        sut.loadAccountTransactions()
        let driver = sut.transactions.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first()?.count, 5)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first()?.first?.amount.minorUnits, 2300)
    }
    
    func testRoundUpSectionTitle() {
        sut.loadAccountTransactions()
        let driver = sut.roundUpSectionTitle.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first(), "Weekly Round Up Amount")
    }
    
    func testTotalRoundUpAmount() {
        sut.loadAccountTransactions()
        let driver = sut.totalRoundUpAmount.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first(), "1.72 GBP")
    }
    
    func testTotalRoundUpAmountWhenNoTransactions() {
        mockRepository = MockStarlingRepositoryEmptyData()
        sut = TransactionsViewModel(repository: mockRepository)
        sut.loadAccountTransactions()
        let driver = sut.totalRoundUpAmount.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first(), "0 GBP")
    }
}
