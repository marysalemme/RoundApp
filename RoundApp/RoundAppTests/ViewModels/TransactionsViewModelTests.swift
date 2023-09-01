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
    
    func testErrorWhenGettingAccount() {
        mockRepository = MockStarlingRepositoryAccountError()
        sut = TransactionsViewModel(repository: mockRepository)
        sut.loadAccountTransactions()
        let driver = sut.errorMessage.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first(), "Primary account not found")
    }
    
    func testErrorWhenGettingTransactions() {
        mockRepository = MockStarlingRepositoryTransactionsError()
        sut = TransactionsViewModel(repository: mockRepository)
        sut.loadAccountTransactions()
        let driver = sut.errorMessage.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first(), "Invalid response")
    }
    
    func testRoundUpSectionWhenRoundUpAmountExists() {
        sut.loadAccountTransactions()
        let roundUpAmountDriver = sut.totalRoundUpAmount.asObservable().subscribe(on: scheduler)
        let showRoundUpSection = sut.showRoundUpSection.asObservable().subscribe(on: scheduler)
        XCTAssertTrue(try showRoundUpSection.toBlocking(timeout: 1).first()!)
        XCTAssertEqual(try roundUpAmountDriver.toBlocking(timeout: 1).first(), "1.72 GBP")
    }
    
    func testRoundUpSectionWhenRoundUpAmountIsZero() {
        mockRepository = MockStarlingRepositoryZeroRoundUp()
        sut = TransactionsViewModel(repository: mockRepository)
        sut.loadAccountTransactions()
        let roundUpAmountDriver = sut.totalRoundUpAmount.asObservable().subscribe(on: scheduler)
        let showRoundUpSection = sut.showRoundUpSection.asObservable().subscribe(on: scheduler)
        XCTAssertFalse(try showRoundUpSection.toBlocking(timeout: 1).first()!)
        XCTAssertNil(try roundUpAmountDriver.toBlocking(timeout: 1).first()!)
    }
    
    func testRoundUpSectionWhenNoTransactions() {
        mockRepository = MockStarlingRepositoryEmptyData()
        sut = TransactionsViewModel(repository: mockRepository)
        sut.loadAccountTransactions()
        let roundUpAmountDriver = sut.totalRoundUpAmount.asObservable().subscribe(on: scheduler)
        let showRoundUpSection = sut.showRoundUpSection.asObservable().subscribe(on: scheduler)
        XCTAssertFalse(try showRoundUpSection.toBlocking(timeout: 1).first()!)
        XCTAssertNil(try roundUpAmountDriver.toBlocking(timeout: 1).first()!)
    }
    
    func testAddToSavingsButtonTitle() {
        sut.loadAccountTransactions()
        let driver = sut.addToSavingsButtonTitle.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first(), "Add to Savings Goal")
    }
}
