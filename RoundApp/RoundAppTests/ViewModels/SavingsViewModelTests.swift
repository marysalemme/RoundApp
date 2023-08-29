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
        sut = SavingsViewModel(accountID: "asdhas-asdhaskd-asjdgajsd", repository: mockRepository)
    }
    
    func testScreenTitle() {
        let driver = sut.screenTitle.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first(), "Saving Goals")
    }
    
    func testEmptyView() {
        mockRepository = MockStarlingRepositoryEmptyData()
        sut = SavingsViewModel(accountID: "asdhas-asdhaskd-asjdgajsd", repository: mockRepository)
        sut.loadSavingGoals()
        let emptyViewDriver = sut.showEmptyView.asObservable().subscribe(on: scheduler)
        let textDriver = sut.emptyViewText.asObservable().subscribe(on: scheduler)
        let buttonTextDriver = sut.emptyViewButtonTitle.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try emptyViewDriver.toBlocking(timeout: 1).first(), true)
        XCTAssertEqual(try textDriver.toBlocking(timeout: 1).first(), "You have no saving goals")
        XCTAssertEqual(try buttonTextDriver.toBlocking(timeout: 1).first(), "Create a new saving goal")
    }
    
    func testSavingGoals() {
        sut.createNewSavingGoal()
        let driver = sut.savingsGoals.asObservable().subscribe(on: scheduler)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first()?.count, 1)
        XCTAssertEqual(try driver.toBlocking(timeout: 1).first()?.first?.name, "Round Up")
    }
}
