//
//  TestAuthHelper.swift
//  AmakaFlowCompanionUITests
//
//  Helper for configuring app launch with test authentication (AMA-232)
//

import XCTest

/// Configures XCUIApplication for E2E testing with auth bypass
enum TestAuthHelper {

    /// Configure app with test credentials to bypass pairing flow
    /// - Parameter app: The XCUIApplication instance to configure
    static func configureApp(_ app: XCUIApplication) {
        // Launch arguments to trigger test mode in the app
        app.launchArguments = [
            "--uitesting",
            "--skip-pairing"
        ]

        // Environment variables with test credentials
        app.launchEnvironment = [
            "TEST_JWT": TestCredentials.pairingToken,
            "TEST_USER_ID": TestCredentials.userId,
            "TEST_USER_EMAIL": TestCredentials.userEmail,
            "TEST_API_BASE_URL": TestCredentials.apiBaseURL
        ]
    }

    /// Wait for the app to finish loading and show main content
    /// - Parameters:
    ///   - app: The XCUIApplication instance
    ///   - timeout: Maximum time to wait for main content
    /// - Returns: True if main content appeared within timeout
    @discardableResult
    static func waitForMainContent(_ app: XCUIApplication, timeout: TimeInterval = 10) -> Bool {
        // Look for elements that indicate we're past the pairing screen
        // The app shows a tab bar with Home, Workouts, etc. when paired
        let tabBar = app.tabBars.firstMatch

        // Wait for tab bar to appear - this is the primary indicator
        if tabBar.waitForExistence(timeout: timeout) {
            return true
        }

        // Fallback: look for Home tab content elements
        let homeContent = app.staticTexts["Today's Workouts"]
        if homeContent.waitForExistence(timeout: 2) {
            return true
        }

        return false
    }

    /// Wait for a specific element to appear
    /// - Parameters:
    ///   - element: The XCUIElement to wait for
    ///   - timeout: Maximum time to wait
    /// - Returns: True if element appeared within timeout
    @discardableResult
    static func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
        element.waitForExistence(timeout: timeout)
    }

    /// Dismiss any system dialogs that may appear (HealthKit, notifications, etc.)
    static func dismissSystemDialogs(_ app: XCUIApplication) {
        // Handle HealthKit authorization
        let healthKitAlert = app.alerts.containing(NSPredicate(format: "label CONTAINS 'Health'")).firstMatch
        if healthKitAlert.waitForExistence(timeout: 2) {
            // Look for Allow button
            let allowButton = healthKitAlert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
            }
        }

        // Handle notification permission
        let notificationAlert = app.alerts.containing(NSPredicate(format: "label CONTAINS 'Notifications'")).firstMatch
        if notificationAlert.waitForExistence(timeout: 1) {
            let allowButton = notificationAlert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
            }
        }
    }
}
