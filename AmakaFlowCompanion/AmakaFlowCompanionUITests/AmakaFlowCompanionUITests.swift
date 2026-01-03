//
//  AmakaFlowCompanionUITests.swift
//  AmakaFlowCompanionUITests
//
//  Base UI tests for AmakaFlow Companion (AMA-232)
//

import XCTest

/// Base UI tests for app functionality
final class AmakaFlowCompanionUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        TestAuthHelper.configureApp(app)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Basic App Tests

    /// Test that app launches successfully with test credentials
    @MainActor
    func testAppLaunches() throws {
        app.launch()

        // App should launch without crashing
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
    }

    /// Test that app shows main content (not pairing) with injected credentials
    @MainActor
    func testAppShowsMainContent() throws {
        app.launch()

        // Wait for main UI to appear
        // With test credentials, we should NOT see the pairing view
        let pairingTitle = app.staticTexts["Pair with AmakaFlow"]
        let isPairingVisible = pairingTitle.waitForExistence(timeout: 3)

        XCTAssertFalse(isPairingVisible, "Pairing view should not be shown with test credentials")
    }

    /// Measure app launch performance with test credentials
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let testApp = XCUIApplication()
            TestAuthHelper.configureApp(testApp)
            testApp.launch()
        }
    }
}
