//
//  AmakaFlowCompanionApp.swift
//  AmakaFlowCompanion
//
//  Main app entry point for AmakaFlow Companion iOS app
//

import SwiftUI

@main
struct AmakaFlowCompanionApp: App {
    @ObservedObject private var pairingService = PairingService.shared

    init() {
        // Initialize error tracking (AMA-225)
        SentryService.shared.initialize()
    }
    @StateObject private var workoutsViewModel = WorkoutsViewModel()
    @StateObject private var watchConnectivity = WatchConnectivityManager.shared
    @StateObject private var garminConnectivity = GarminConnectManager.shared

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
