//
//  TestAuthHelper.swift
//  AmakaFlowCompanionUITests
//
//  Helper for configuring app with test credentials (AMA-232)
//

import XCTest

/// Helper for setting up test authentication
enum TestAuthHelper {

    /// Configure the app with test credentials for UI testing
    /// - Parameter app: The XCUIApplication to configure
    static func configureApp(_ app: XCUIApplication) {
        // Launch arguments for test mode
        app.launchArguments = [
            "--uitesting",      // Enables UI testing mode (disables animations)
            "--skip-pairing"    // Bypasses QR/short code pairing flow
        ]

        // Environment variables with test credentials
        var environment: [String: String] = [:]
        environment["TEST_ACCOUNT_TOKEN"] = TestCredentials.pairingToken
        environment["TEST_USER_ID"] = TestCredentials.userId
        environment["TEST_USER_EMAIL"] = TestCredentials.userEmail
        environment["TEST_USER_NAME"] = TestCredentials.userName
        environment["API_BASE_URL"] = TestCredentials.apiBaseURL
        app.launchEnvironment = environment
    }

    /// Configure app for staging environment testing
    /// - Parameter app: The XCUIApplication to configure
    static func configureAppForStaging(_ app: XCUIApplication) {
        configureApp(app)
        // Override to use staging API
        app.launchEnvironment["API_BASE_URL"] = "https://mapper-api.staging.amakaflow.com"
    }

    /// Configure app for local development testing
    /// - Parameter app: The XCUIApplication to configure
    static func configureAppForLocal(_ app: XCUIApplication) {
        configureApp(app)
        // Override to use local API
        app.launchEnvironment["API_BASE_URL"] = "http://localhost:8001"
    }
}
