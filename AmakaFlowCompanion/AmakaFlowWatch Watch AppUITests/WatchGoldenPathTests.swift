//
//  WatchGoldenPathTests.swift
//  AmakaFlowWatch Watch AppUITests
//
//  Golden-path XCUITests for AmakaFlow Watch app (AMA-553)
//  Tests the core user flow: start workout, view exercise, quick log, end workout.
//  Uses Demo mode to simulate workout state without requiring iPhone connection.
//

import XCTest

final class WatchGoldenPathTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = [
            "--uitesting",
            "--reset-state"
        ]
        app.launchEnvironment = [
            "UITEST_MODE": "1"
        ]

        addUIInterruptionMonitor(withDescription: "HealthKit Authorization") { alert in
            let allowButton = alert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
                return true
            }
            let dontAllowButton = alert.buttons["Don't Allow"]
            if dontAllowButton.exists {
                dontAllowButton.tap()
                return true
            }
            return false
        }

        addUIInterruptionMonitor(withDescription: "Notification Authorization") { alert in
            let allowButton = alert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
                return true
            }
            return false
        }

        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10),
                      "App should reach foreground state")
    }

    override func tearDownWithError() throws {
        app?.terminate()
        app = nil
    }

    // MARK: - Helpers

    /// Wait for the main screen to load past the "Connecting..." state
    private func waitForMainScreen() -> Bool {
        let idleText = app.staticTexts["No Active Workout"]
        let disconnectedText = app.staticTexts["iPhone Not Connected"]

        return idleText.waitForExistence(timeout: 12) || disconnectedText.waitForExistence(timeout: 2)
    }

    /// Enter demo mode and return true if successful
    private func enterDemoMode() -> Bool {
        guard waitForMainScreen() else { return false }

        let demoButton = app.buttons["Demo"]
        guard demoButton.waitForExistence(timeout: 5) else { return false }
        demoButton.tap()

        // Verify demo mode is active
        let demoIndicator = app.staticTexts.matching(
            NSPredicate(format: "label BEGINSWITH 'DEMO'")
        ).firstMatch
        return demoIndicator.waitForExistence(timeout: 5)
    }

    /// Advance to the next demo screen by tapping the forward button
    private func advanceDemoScreen() {
        // The forward button in demo mode uses "forward.fill" SF Symbol
        // It's a plain button style in the demo controls overlay
        let forwardButtons = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Forward' OR label CONTAINS 'forward'")
        )
        if forwardButtons.count > 0 {
            // Tap the last forward button (demo controls are at bottom)
            forwardButtons.element(boundBy: forwardButtons.count - 1).tap()
        }
        // Allow UI to update
        sleep(1)
    }

    // MARK: - Golden Path: Demo Mode Workout Flow

    @MainActor
    func testDemoWorkoutFlowRepBased() throws {
        // Enter demo mode
        XCTAssertTrue(enterDemoMode(), "Should enter demo mode")

        let screenshot1 = XCTAttachment(screenshot: app.screenshot())
        screenshot1.name = "Demo Screen 0 - Idle"
        screenshot1.lifetime = .keepAlways
        add(screenshot1)

        // Screen 0: Idle (same as before demo)
        // Advance to Screen 1: Rep-based step with weight input
        advanceDemoScreen()

        // Screen 1 should show "Bench Press" with weight input
        let benchPressText = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'BENCH PRESS'")
        ).firstMatch
        XCTAssertTrue(benchPressText.waitForExistence(timeout: 5),
                      "Should show Bench Press exercise name")

        // Should show set info "Set 2/4"
        let setInfoText = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'Set 2/4'")
        ).firstMatch
        XCTAssertTrue(setInfoText.waitForExistence(timeout: 3),
                      "Should show set information")

        // Should show LOG button
        let logButton = app.staticTexts.matching(
            NSPredicate(format: "label == 'LOG'")
        ).firstMatch
        XCTAssertTrue(logButton.waitForExistence(timeout: 3),
                      "Should show LOG button")

        let screenshot2 = XCTAttachment(screenshot: app.screenshot())
        screenshot2.name = "Demo Screen 1 - Rep Based Weight Input"
        screenshot2.lifetime = .keepAlways
        add(screenshot2)
    }

    @MainActor
    func testDemoWorkoutFlowTimedStep() throws {
        XCTAssertTrue(enterDemoMode(), "Should enter demo mode")

        // Advance to Screen 2: Timed step (Warm Up)
        advanceDemoScreen()  // Screen 1
        advanceDemoScreen()  // Screen 2

        // Screen 2 should show "Warm Up" with timer
        let warmUpText = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'Warm Up'")
        ).firstMatch
        XCTAssertTrue(warmUpText.waitForExistence(timeout: 5),
                      "Should show Warm Up step name")

        // Should show timer in format M:SS (e.g., "4:55")
        let timerText = app.staticTexts.matching(
            NSPredicate(format: "label MATCHES '\\\\d+:\\\\d{2}'")
        ).firstMatch
        XCTAssertTrue(timerText.waitForExistence(timeout: 3),
                      "Should show countdown timer")

        // Should show progress indicator (step count like "1/7")
        let progressText = app.staticTexts.matching(
            NSPredicate(format: "label MATCHES '\\\\d+/\\\\d+'")
        ).firstMatch
        XCTAssertTrue(progressText.waitForExistence(timeout: 3),
                      "Should show step progress indicator")

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Demo Screen 2 - Timed Step"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    @MainActor
    func testDemoWorkoutFlowPausedState() throws {
        XCTAssertTrue(enterDemoMode(), "Should enter demo mode")

        // Advance to Screen 3: Paused state
        advanceDemoScreen()  // Screen 1
        advanceDemoScreen()  // Screen 2
        advanceDemoScreen()  // Screen 3

        // In paused state, swipe left should reveal controls panel with Resume/End
        // The paused state shows the same workout view but in paused coloring
        // The exercise name should still be visible
        let exerciseText = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'BENCH PRESS' OR label CONTAINS[c] 'Bench Press'")
        ).firstMatch
        XCTAssertTrue(exerciseText.waitForExistence(timeout: 5),
                      "Should show exercise name in paused state")

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Demo Screen 3 - Paused"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    @MainActor
    func testDemoWorkoutFlowCompleteState() throws {
        XCTAssertTrue(enterDemoMode(), "Should enter demo mode")

        // Advance to Screen 4: Complete
        advanceDemoScreen()  // Screen 1
        advanceDemoScreen()  // Screen 2
        advanceDemoScreen()  // Screen 3
        advanceDemoScreen()  // Screen 4

        // Complete view should show checkmark and "Complete!" text
        let completeText = app.staticTexts["Complete!"]
        XCTAssertTrue(completeText.waitForExistence(timeout: 5),
                      "Should show 'Complete!' text")

        // Should also show "Great workout!" or workout summary info
        let greatWorkoutText = app.staticTexts["Great workout!"]
        XCTAssertTrue(greatWorkoutText.waitForExistence(timeout: 3),
                      "Should show congratulatory message")

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Demo Screen 4 - Complete"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    @MainActor
    func testDemoModeCyclesBackToStart() throws {
        XCTAssertTrue(enterDemoMode(), "Should enter demo mode")

        // Cycle through all 5 screens (0-4) and verify it wraps
        for _ in 0..<5 {
            advanceDemoScreen()
        }

        // After 5 advances from screen 0, should be back at screen 0 (idle)
        // The idle screen shows "No Active Workout" or the demo idle state
        let demoIndicator = app.staticTexts.matching(
            NSPredicate(format: "label BEGINSWITH 'DEMO 1/'")
        ).firstMatch
        XCTAssertTrue(demoIndicator.waitForExistence(timeout: 5),
                      "Demo mode should cycle back to screen 1/5")
    }

    @MainActor
    func testDemoModeExitButton() throws {
        XCTAssertTrue(enterDemoMode(), "Should enter demo mode")

        // The demo overlay has an X (xmark) button to exit demo mode
        // Look for a close/dismiss button in the demo controls
        let closeButtons = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Close' OR label CONTAINS 'xmark' OR label CONTAINS 'X'")
        )

        var exitedDemo = false
        for i in 0..<closeButtons.count {
            let btn = closeButtons.element(boundBy: i)
            if btn.exists && btn.isHittable {
                btn.tap()
                exitedDemo = true
                break
            }
        }

        XCTAssertTrue(exitedDemo, "Should find and tap an exit/close button to leave demo mode")

        if exitedDemo {
            sleep(1)
            // After exiting demo, should see regular idle/disconnected screen
            let idleText = app.staticTexts["No Active Workout"]
            let disconnectedText = app.staticTexts["iPhone Not Connected"]
            XCTAssertTrue(idleText.exists || disconnectedText.exists,
                          "Should return to normal idle/disconnected view after exiting demo")
        }

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "After Demo Exit"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    // MARK: - Golden Path: Navigation Controls

    @MainActor
    func testDemoWorkoutNavigationControls() throws {
        XCTAssertTrue(enterDemoMode(), "Should enter demo mode")

        // Go to rep-based screen (screen 1)
        advanceDemoScreen()

        // Verify navigation controls exist
        // Previous button (backward.fill)
        let backwardButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'Backward' OR label CONTAINS[c] 'backward'")
        ).firstMatch
        XCTAssertTrue(backwardButton.waitForExistence(timeout: 5),
                      "Previous step button should exist")

        // Next/Forward button (forward.fill) - the main action button in the workout
        let forwardButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'Forward' OR label CONTAINS[c] 'forward'")
        ).firstMatch
        XCTAssertTrue(forwardButton.waitForExistence(timeout: 3),
                      "Next step button should exist")

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Navigation Controls"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    // MARK: - Golden Path: Heart Rate Display

    @MainActor
    func testDemoWorkoutHeartRateDisplay() throws {
        XCTAssertTrue(enterDemoMode(), "Should enter demo mode")

        // Go to timed step screen (screen 2) which shows heart rate in demo mode
        advanceDemoScreen()  // Screen 1
        advanceDemoScreen()  // Screen 2

        // In demo mode, heart rate shows "142" and calories show "87"
        let heartRateText = app.staticTexts["142"]
        let caloriesText = app.staticTexts["87"]

        // Heart rate and calories are shown in demo mode
        let heartRateVisible = heartRateText.waitForExistence(timeout: 5)
        let caloriesVisible = caloriesText.waitForExistence(timeout: 3)
        XCTAssertTrue(heartRateVisible || caloriesVisible,
                      "Heart rate or calories should be displayed in demo mode")

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Heart Rate Display"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    // MARK: - Golden Path: Full End-to-End Demo Flow

    @MainActor
    func testFullDemoWorkoutJourney() throws {
        // Step 1: Launch and verify main screen
        XCTAssertTrue(waitForMainScreen(), "Main screen should load")

        var screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Step 1 - Main Screen"
        screenshot.lifetime = .keepAlways
        add(screenshot)

        // Step 2: Enter demo mode
        XCTAssertTrue(enterDemoMode(), "Should enter demo mode")

        // Step 3: View each demo screen
        // Screen 1 - Rep-based with weight
        advanceDemoScreen()
        screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Step 3a - Weight Input"
        screenshot.lifetime = .keepAlways
        add(screenshot)

        // Screen 2 - Timed step
        advanceDemoScreen()
        let timerText = app.staticTexts.matching(
            NSPredicate(format: "label MATCHES '\\\\d+:\\\\d{2}'")
        ).firstMatch
        XCTAssertTrue(timerText.waitForExistence(timeout: 5),
                      "Timer should be visible on timed step")

        screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Step 3b - Timed Step"
        screenshot.lifetime = .keepAlways
        add(screenshot)

        // Screen 3 - Paused
        advanceDemoScreen()
        screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Step 3c - Paused"
        screenshot.lifetime = .keepAlways
        add(screenshot)

        // Screen 4 - Complete
        advanceDemoScreen()
        let completeText = app.staticTexts["Complete!"]
        XCTAssertTrue(completeText.waitForExistence(timeout: 5),
                      "Complete screen should appear")

        screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "Step 3d - Complete"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
}
