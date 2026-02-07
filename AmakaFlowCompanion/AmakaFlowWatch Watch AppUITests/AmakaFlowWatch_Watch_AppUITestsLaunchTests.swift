//
//  AmakaFlowWatch_Watch_AppUITestsLaunchTests.swift
//  AmakaFlowWatch Watch AppUITests
//
//  Launch tests with meaningful verifications for AmakaFlow Watch app (AMA-553)
//

import XCTest

final class AmakaFlowWatch_Watch_AppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = [
            "--uitesting",
            "--reset-state"
        ]
        app.launchEnvironment = [
            "UITEST_MODE": "1"
        ]
        app.launch()

        // Verify the app is running
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10),
                      "App should reach foreground state")

        // Wait for main screen to load past any connecting state
        let idleText = app.staticTexts["No Active Workout"]
        let disconnectedText = app.staticTexts["iPhone Not Connected"]
        let connectingText = app.staticTexts["Connecting..."]

        // Either we see connecting (which will resolve) or we're already on the main screen
        if connectingText.waitForExistence(timeout: 2) {
            // Wait for connecting to resolve
            _ = idleText.waitForExistence(timeout: 10) || disconnectedText.waitForExistence(timeout: 2)
        }

        // Verify we're showing a meaningful state, not a blank screen
        let hasMainContent = idleText.exists
            || disconnectedText.exists
            || app.buttons["Demo"].exists
            || app.buttons["Refresh"].exists
            || app.buttons["Retry"].exists
        XCTAssertTrue(hasMainContent, "Launch screen should show main content (not blank)")

        // Capture screenshot
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchWithDemoMode() throws {
        let app = XCUIApplication()
        app.launchArguments = [
            "--uitesting",
            "--reset-state"
        ]
        app.launchEnvironment = [
            "UITEST_MODE": "1"
        ]
        app.launch()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))

        // Wait for main screen
        let idleText = app.staticTexts["No Active Workout"]
        let disconnectedText = app.staticTexts["iPhone Not Connected"]
        _ = idleText.waitForExistence(timeout: 12) || disconnectedText.waitForExistence(timeout: 2)

        // Enter demo mode if available
        let demoButton = app.buttons["Demo"]
        if demoButton.waitForExistence(timeout: 5) {
            demoButton.tap()
            sleep(1)

            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "Launch - Demo Mode"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
