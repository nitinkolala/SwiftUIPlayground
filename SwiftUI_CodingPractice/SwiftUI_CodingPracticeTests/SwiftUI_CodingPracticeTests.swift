//
//  SwiftUI_CodingPracticeTests.swift
//  SwiftUI_CodingPracticeTests
//
//  Created by Nitin on 21/11/26.
//

import XCTest
@testable import SwiftUI_CodingPractice

// Unit tests for the Counter logic behind the counter screen.
@MainActor
final class CounterTests: XCTestCase {

    // MARK: - Initial state

    func testStartsAtZero() {
        let counter = Counter()
        XCTAssertEqual(counter.value, 0)
    }

    func testCannotResetWhenStartingAtZero() {
        let counter = Counter()
        XCTAssertFalse(counter.canReset)
    }

    // MARK: - increment

    func testIncrementAddsOne() {
        var counter = Counter()
        counter.increment()
        XCTAssertEqual(counter.value, 1)
    }

    func testIncrementManyTimesAccumulates() {
        var counter = Counter()
        for _ in 0..<5 {
            counter.increment()
        }
        XCTAssertEqual(counter.value, 5)
    }

    func testCanResetAfterIncrement() {
        var counter = Counter()
        counter.increment()
        XCTAssertTrue(counter.canReset)
    }

    // MARK: - decrement

    func testDecrementSubtractsOne() {
        var counter = Counter()
        counter.increment()
        counter.increment()
        counter.decrement()
        XCTAssertEqual(counter.value, 1)
    }

    func testDecrementBackToZeroDisablesReset() {
        var counter = Counter()
        counter.increment()
        counter.decrement()
        XCTAssertEqual(counter.value, 0)
        XCTAssertFalse(counter.canReset)
    }

    func testDecrementBelowZeroAllowsNegativeValue() {
        // Current behavior: the minus button is not clamped at zero.
        var counter = Counter()
        counter.decrement()
        XCTAssertEqual(counter.value, -1)
    }

    func testCanResetWhenNegative() {
        // Reset is enabled for any non-zero value, including negative ones.
        var counter = Counter()
        counter.decrement()
        XCTAssertTrue(counter.canReset)
    }

    // MARK: - reset

    func testResetSetsValueToZero() {
        var counter = Counter()
        counter.increment()
        counter.increment()
        counter.increment()
        counter.reset()
        XCTAssertEqual(counter.value, 0)
    }

    func testResetFromNegativeSetsValueToZero() {
        var counter = Counter()
        counter.decrement()
        counter.decrement()
        counter.reset()
        XCTAssertEqual(counter.value, 0)
    }

    func testResetAtZeroKeepsValueAtZero() {
        var counter = Counter()
        counter.reset()
        XCTAssertEqual(counter.value, 0)
        XCTAssertFalse(counter.canReset)
    }

    func testResetDisablesResetUntilChangedAgain() {
        var counter = Counter()
        counter.increment()
        counter.reset()
        XCTAssertFalse(counter.canReset)
    }

    // MARK: - Sequences

    func testMixedIncrementAndDecrementReachesExpectedValue() {
        var counter = Counter()
        // + + - + => 2
        counter.increment()
        counter.increment()
        counter.decrement()
        counter.increment()
        XCTAssertEqual(counter.value, 2)
    }

    func testCounterWorksNormallyAfterReset() {
        var counter = Counter()
        counter.increment()
        counter.increment()
        counter.reset()
        counter.increment()
        XCTAssertEqual(counter.value, 1)
        XCTAssertTrue(counter.canReset)
    }
}
