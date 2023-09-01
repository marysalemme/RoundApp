//
//  SavingsViewModelTests.swift
//  RoundAppTests
//
//  Created by Mary Salemme on 28/08/2023.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import RoundApp

final class SavingsViewModelTests: XCTestCase {
    
    var sut: SavingsViewModel!
    var mockRepository: StarlingRepositoryType!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUpWithError() throws {
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        mockRepository = MockStarlingRepository()
        sut = SavingsViewModel(roundUpAmount: 12345, accountID: "asdhas-asdhaskd-asjdgajsd", repository: mockRepository)
    }
    
    func testScreenTitle() {
        let driver = sut.screenTitle.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first(), "Saving Goals")
    }
    
    func testLoadSavingGoals() {
//        let loadingViewDriver = sut.showLoadingView.asObservable().subscribe(on: scheduler)
        let textDriver = sut.savingsGoalTitle.asObservable().subscribe(on: scheduler)
        let totalSavedDriver = sut.savingsGoalTotalSaved.asObservable().subscribe(on: scheduler)
        sut.loadSavingGoals()
//        XCTAssertEqual(try emptyViewDriver.toBlocking(timeout: 1).first(), false)
        XCTAssertEqual(try textDriver.toBlocking(timeout: 1).first(), "Round Up")
        XCTAssertEqual(try totalSavedDriver.toBlocking(timeout: 1).first(), "GBP 0/2000")
    }
    
    func testLoadSavingGoalsWhenNoGoals() {
        mockRepository = MockStarlingRepositoryEmptyData()
        sut = SavingsViewModel(roundUpAmount: 12345, accountID: "asdhas-asdhaskd-asjdgajsd", repository: mockRepository)
        sut.loadSavingGoals()
        let emptyViewDriver = sut.showEmptyView.asObservable().subscribe(on: scheduler)
        let textDriver = sut.emptyViewText.asObservable().subscribe(on: scheduler)
        let buttonTextDriver = sut.emptyViewButtonTitle.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try emptyViewDriver.toBlocking(timeout: 1).first(), true)
        XCTAssertEqual(try textDriver.toBlocking(timeout: 1).first(), "You have no saving goals")
        XCTAssertEqual(try buttonTextDriver.toBlocking(timeout: 1).first(), "Create a new saving goal")
    }
    
    func testCreateNewSavingGoal() {
        mockRepository = MockStarlingRepositoryEmptyData()
        sut = SavingsViewModel(roundUpAmount: 12345, accountID: "asdhas-asdhaskd-asjdgajsd", repository: mockRepository)
        sut.loadSavingGoals()
        let emptyViewDriver = sut.showEmptyView.asObservable().subscribe(on: scheduler)
        let textDriver = sut.savingsGoalTitle.asObservable().subscribe(on: scheduler)
        let totalSavedDriver = sut.savingsGoalTotalSaved.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try emptyViewDriver.toBlocking(timeout: 1).first(), true)
        sut.createNewSavingsGoal()
        XCTAssertEqual(try emptyViewDriver.toBlocking(timeout: 1).first(), false)
        XCTAssertEqual(try textDriver.toBlocking(timeout: 1).first(), "Round Up")
        XCTAssertEqual(try totalSavedDriver.toBlocking(timeout: 1).first(), "GBP 0/2000")
    }
    
    func testAddMoneyToSavingGoal() {
        sut.loadSavingGoals()
        let textDriver = sut.savingsGoalTotalSaved.asObservable().subscribe(on: scheduler)
        sut.addRoundUpMoney()
        XCTAssertEqual(try textDriver.toBlocking(timeout: 1).first(), "GBP 120/2000")
    }
}
