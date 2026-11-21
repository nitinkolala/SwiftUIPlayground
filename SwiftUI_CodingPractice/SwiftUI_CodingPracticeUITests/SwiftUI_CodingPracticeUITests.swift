//
//  SwiftUI_CodingPracticeUITests.swift
//  SwiftUI_CodingPracticeUITests
//
//  Created by Nitin on 21/11/26.
//

import XCTest

// UI tests for the counter screen in ContentView.
// They drive the real app, so they check what the user sees: labels and enabled state.
final class SwiftUI_CodingPracticeUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Helpers

    /// The counter label whose text matches the given value, e.g. "Count: 2".
    private func countLabel(_ value: Int) -> XCUIElement {
        app.staticTexts["Count: \(value)"]
    }

    private var plusButton: XCUIElement { app.buttons["+"] }
    private var minusButton: XCUIElement { app.buttons["-"] }
    private var resetButton: XCUIElement { app.buttons["Reset"] }

    // MARK: - Initial state

    @MainActor
    func testInitialStateShowsZeroAndDisablesReset() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5), "Counter should start at 0")
        XCTAssertTrue(plusButton.isEnabled)
        XCTAssertTrue(minusButton.isEnabled)
        XCTAssertFalse(resetButton.isEnabled, "Reset should be disabled when count is 0")
    }

    // MARK: - Plus button

    @MainActor
    func testPlusButtonIncrementsCount() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5))

        plusButton.tap()

        XCTAssertTrue(countLabel(1).waitForExistence(timeout: 2), "One tap on + should show Count: 1")
    }

    @MainActor
    func testPlusButtonEnablesReset() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5))
        XCTAssertFalse(resetButton.isEnabled)

        plusButton.tap()

        XCTAssertTrue(countLabel(1).waitForExistence(timeout: 2))
        XCTAssertTrue(resetButton.isEnabled, "Reset should be enabled once count is non-zero")
    }

    // MARK: - Minus button

    @MainActor
    func testMinusButtonDecrementsCount() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5))
        plusButton.tap()
        plusButton.tap()
        XCTAssertTrue(countLabel(2).waitForExistence(timeout: 2))

        minusButton.tap()

        XCTAssertTrue(countLabel(1).waitForExistence(timeout: 2), "Minus from 2 should show Count: 1")
    }

    @MainActor
    func testMinusToZeroDisablesReset() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5))
        plusButton.tap()
        XCTAssertTrue(countLabel(1).waitForExistence(timeout: 2))
        XCTAssertTrue(resetButton.isEnabled)

        minusButton.tap()

        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 2))
        XCTAssertFalse(resetButton.isEnabled, "Reset should be disabled again at 0")
    }

    // MARK: - Reset button

    @MainActor
    func testResetSetsCountToZero() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5))
        plusButton.tap()
        plusButton.tap()
        plusButton.tap()
        XCTAssertTrue(countLabel(3).waitForExistence(timeout: 2))

        resetButton.tap()

        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 2), "Reset should bring count back to 0")
        XCTAssertFalse(resetButton.isEnabled)
    }

    @MainActor
    func testResetIsDisabledWhenCountIsZero() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5))
        XCTAssertFalse(resetButton.isEnabled)
    }

    @MainActor
    func testResetThenIncrementAgainWorks() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5))
        plusButton.tap()
        plusButton.tap()
        XCTAssertTrue(countLabel(2).waitForExistence(timeout: 2))

        resetButton.tap()
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 2))

        plusButton.tap()
        XCTAssertTrue(countLabel(1).waitForExistence(timeout: 2), "Counter should work normally after Reset")
        XCTAssertTrue(resetButton.isEnabled)
    }

    // MARK: - Sequences

    @MainActor
    func testRepeatedPlusTapsAccumulate() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5))

        for _ in 0..<5 {
            plusButton.tap()
        }

        XCTAssertTrue(countLabel(5).waitForExistence(timeout: 2), "Five taps on + should show Count: 5")
    }

    @MainActor
    func testMixedPlusAndMinusTapsReachExpectedValue() throws {
        XCTAssertTrue(countLabel(0).waitForExistence(timeout: 5))

        // + + - + => 2
        plusButton.tap()
        plusButton.tap()
        minusButton.tap()
        plusButton.tap()

        XCTAssertTrue(countLabel(2).waitForExistence(timeout: 2), "+, +, -, + should leave the count at 2")
    }

    // MARK: - Launch

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
