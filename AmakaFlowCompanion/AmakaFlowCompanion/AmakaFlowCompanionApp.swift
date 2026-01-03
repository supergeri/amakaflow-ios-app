//
//  AmakaFlowCompanionApp.swift
//  AmakaFlowCompanion
//
//  Main app entry point for AmakaFlow Companion iOS app
//

import SwiftUI
import Sentry

@main
struct AmakaFlowCompanionApp: App {
    @ObservedObject private var pairingService = PairingService.shared
    @StateObject private var workoutsViewModel = WorkoutsViewModel()
    @StateObject private var watchConnectivity = WatchConnectivityManager.shared
    @StateObject private var garminConnectivity = GarminConnectManager.shared

    init() {
        // Configure for UI testing if launch arguments present (AMA-232)
        #if DEBUG
        configureForUITesting()
        #endif

        // Initialize Sentry error tracking (AMA-225)
        SentrySDK.start { options in
            options.dsn = "https://7fa7415e248b5a064d84f74679719797@o951666.ingest.us.sentry.io/4510638875017216"

            // Adds IP for users
            options.sendDefaultPii = true

            // Performance monitoring (reduce in production)
            options.tracesSampleRate = 1.0

            // Profiling
            options.configureProfiling = {
                $0.sessionSampleRate = 1.0
                $0.lifecycle = .trace
            }

            // Screenshots and view hierarchy for debugging
            options.attachScreenshot = true
            options.attachViewHierarchy = true

            // Enable experimental logging
            options.experimental.enableLogs = true
        }
    }

    // MARK: - UI Testing Configuration (AMA-232)

    #if DEBUG
    /// Configure app for UI testing by injecting test credentials
    private func configureForUITesting() {
        let arguments = ProcessInfo.processInfo.arguments
        let environment = ProcessInfo.processInfo.environment

        // Check for UI testing mode
        if arguments.contains("--uitesting") {
            // Disable animations for faster, more reliable tests
            UIView.setAnimationsEnabled(false)
            print("[E2E] UI Testing mode enabled - animations disabled")
        }

        // Check for pairing bypass
        if arguments.contains("--skip-pairing") {
            print("[E2E] Skip pairing mode enabled")

            // Get test credentials from launch environment
            if let token = environment["TEST_ACCOUNT_TOKEN"] {
                // Store JWT token in keychain (bypasses QR/short code flow)
                if KeychainHelper.shared.save(token, for: "jwt_token") {
                    print("[E2E] Test JWT token injected successfully")
                } else {
                    print("[E2E] WARNING: Failed to inject test JWT token")
                }

                // Store test user profile if provided
                if let userId = environment["TEST_USER_ID"],
                   let email = environment["TEST_USER_EMAIL"],
                   let name = environment["TEST_USER_NAME"] {
                    let profile = UserProfile(
                        id: userId,
                        email: email,
                        name: name,
                        avatarUrl: nil
                    )
                    if let profileData = try? JSONEncoder().encode(profile) {
                        _ = KeychainHelper.shared.save(profileData, for: "user_profile")
                        print("[E2E] Test user profile injected: \(email)")
                    }
                }

                // Force the pairing service to recognize the injected state
                // This needs to happen on next run loop to ensure PairingService.shared is initialized
                DispatchQueue.main.async {
                    PairingService.shared.isPaired = true
                    print("[E2E] Pairing service marked as paired")
                }
            } else {
                print("[E2E] WARNING: --skip-pairing specified but TEST_ACCOUNT_TOKEN not provided")
            }
        }

        // Override API base URL if provided
        if let apiBaseURL = environment["API_BASE_URL"] {
            print("[E2E] API base URL override: \(apiBaseURL)")
            // Note: This requires adding support in AppEnvironment or using a different mechanism
        }
    }
    #endif

    var body: some Scene {
        WindowGroup {
            Group {
                if pairingService.isPaired {
                    ContentView()
                        .environmentObject(workoutsViewModel)
                        .environmentObject(watchConnectivity)
                        .environmentObject(garminConnectivity)
                        .environmentObject(pairingService)
                        .task {
                            // Load workouts from API
                            await workoutsViewModel.loadWorkouts()

                            // Initialize WatchConnectivity asynchronously (non-blocking)
                            watchConnectivity.activate()

                            // Auto-reconnect to saved Garmin device if available
                            if garminConnectivity.savedDeviceInfo != nil && !garminConnectivity.isConnected {
                                garminConnectivity.connectToSavedDevice()
                            }
                        }
                        .refreshable {
                            await workoutsViewModel.refreshWorkouts()
                        }
                        .onOpenURL { url in
                            // Handle Garmin Connect IQ callbacks
                            print("⌚ [APP] onOpenURL received: \(url.absoluteString)")
                            print("⌚ [APP] URL scheme: \(url.scheme ?? "nil")")
                            print("⌚ [APP] URL host: \(url.host ?? "nil")")
                            print("⌚ [APP] URL path: \(url.path)")
                            print("⌚ [APP] URL query: \(url.query ?? "nil")")
                            let handled = garminConnectivity.handleURL(url)
                            print("⌚ [APP] URL handled: \(handled)")
                        }
                } else {
                    PairingView()
                        .environmentObject(pairingService)
                }
            }
            .preferredColorScheme(.dark) // Force dark mode
        }
    }
}
