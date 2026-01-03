//
//  AmakaFlowCompanionUITestsLaunchTests.swift
//  AmakaFlowCompanionUITests
//
//  Launch tests for AmakaFlow Companion (AMA-232)
//

import XCTest

/// Tests for app launch states and screenshots
final class AmakaFlowCompanionUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Test launch with test credentials and capture screenshot
    @MainActor
    func testLaunchWithTestCredentials() throws {
        let app = XCUIApplication()
        TestAuthHelper.configureApp(app)
        app.launch()

        // Wait for main content to load
        sleep(2)

        // Capture screenshot of authenticated state
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - Authenticated"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Test launch without credentials (should show pairing view)
    @MainActor
    func testLaunchWithoutCredentials() throws {
        let app = XCUIApplication()
        // Launch without test configuration to see pairing flow
        app.launch()

        // Wait for UI to appear
        sleep(2)

        // Capture screenshot of pairing state
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - Pairing Required"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
