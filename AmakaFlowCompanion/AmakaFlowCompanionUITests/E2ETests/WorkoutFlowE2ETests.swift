//
//  WorkoutFlowE2ETests.swift
//  AmakaFlowCompanionUITests
//
//  End-to-end tests for complete workout flows (AMA-232)
//  Tests the full workout lifecycle from start to completion
//

import XCTest

final class WorkoutFlowE2ETests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Setup & Teardown

    override func setUpWithError() throws {
        // Stop immediately when a failure occurs
        continueAfterFailure = false

        // Initialize app with test configuration
        app = XCUIApplication()
        TestAuthHelper.configureApp(app)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Test Cases

    /// Test that the app launches in authenticated state with test credentials
    @MainActor
    func testAppLaunchesAuthenticated() throws {
        app.launch()

        // Wait for the main content view to appear (not the pairing view)
        // The ContentView should have a tab bar or main navigation
        let tabBar = app.tabBars.firstMatch
        let exists = tabBar.waitForExistence(timeout: 10)

        XCTAssertTrue(exists, "App should launch directly to main content view with test credentials")

        // Take screenshot for verification
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Authenticated Launch State"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Test navigating to the workouts list
    @MainActor
    func testNavigateToWorkoutsList() throws {
        app.launch()

        // Wait for app to load
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 10), "Tab bar should appear")

        // Look for workouts tab or navigation element
        // Note: Update these identifiers based on actual app UI
        let workoutsTab = app.tabBars.buttons["Workouts"]
        if workoutsTab.exists {
            workoutsTab.tap()
        }

        // Verify workouts list is visible
        // Wait for content to load (API call)
        sleep(2)

        // Take screenshot
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Workouts List"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Test selecting a workout from the list
    @MainActor
    func testSelectWorkout() throws {
        app.launch()

        // Wait for app to load
        sleep(3)

        // Navigate to workouts if needed
        let workoutsTab = app.tabBars.buttons["Workouts"]
        if workoutsTab.exists && !workoutsTab.isSelected {
            workoutsTab.tap()
        }

        // Wait for workouts to load
        sleep(2)

        // Find and tap first workout cell
        // Note: Update based on actual UI implementation
        let workoutCells = app.cells
        if workoutCells.count > 0 {
            workoutCells.element(boundBy: 0).tap()

            // Wait for workout detail to load
            sleep(1)

            // Take screenshot of workout detail
            let screenshot = app.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "Workout Detail"
            attachment.lifetime = .keepAlways
            add(attachment)
        } else {
            XCTFail("No workout cells found - API may not have returned workouts")
        }
    }

    /// Test starting a workout (basic flow without Watch)
    @MainActor
    func testStartWorkoutBasicFlow() throws {
        app.launch()

        // Wait for app to load
        sleep(3)

        // Navigate to workouts
        let workoutsTab = app.tabBars.buttons["Workouts"]
        if workoutsTab.exists && !workoutsTab.isSelected {
            workoutsTab.tap()
        }

        sleep(2)

        // Select first workout
        let workoutCells = app.cells
        guard workoutCells.count > 0 else {
            XCTFail("No workout cells found")
            return
        }
        workoutCells.element(boundBy: 0).tap()

        sleep(1)

        // Look for "Start Workout" button
        let startButton = app.buttons["Start Workout"]
        if startButton.waitForExistence(timeout: 5) {
            startButton.tap()

            // Wait for workout player to appear
            sleep(2)

            // Take screenshot of workout in progress
            let screenshot = app.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "Workout In Progress"
            attachment.lifetime = .keepAlways
            add(attachment)
        } else {
            // Take screenshot to debug
            let screenshot = app.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "Start Button Not Found"
            attachment.lifetime = .keepAlways
            add(attachment)

            XCTFail("Start Workout button not found")
        }
    }

    // MARK: - Performance Tests

    /// Measure app launch time
    @MainActor
    func testAppLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }

    /// Measure time to load workouts list
    @MainActor
    func testWorkoutsListLoadPerformance() throws {
        let measureOptions = XCTMeasureOptions()
        measureOptions.iterationCount = 3

        measure(options: measureOptions) {
            app.launch()

            // Navigate to workouts
            let workoutsTab = app.tabBars.buttons["Workouts"]
            if workoutsTab.waitForExistence(timeout: 10) {
                workoutsTab.tap()
            }

            // Wait for cells to appear (indicates loading complete)
            let _ = app.cells.firstMatch.waitForExistence(timeout: 10)

            // Terminate for next iteration
            app.terminate()
        }
    }
}
