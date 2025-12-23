//
//  AmakaFlowCompanionApp.swift
//  AmakaFlowCompanion
//
//  Main app entry point for AmakaFlow Companion iOS app
//

import SwiftUI

@main
struct AmakaFlowCompanionApp: App {
    @StateObject private var workoutsViewModel = WorkoutsViewModel()
    @StateObject private var watchConnectivity = WatchConnectivityManager.shared
    @StateObject private var garminConnectivity = GarminConnectManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutsViewModel)
                .environmentObject(watchConnectivity)
                .environmentObject(garminConnectivity)
                .preferredColorScheme(.dark) // Force dark mode
                .task {
                    // Initialize WatchConnectivity asynchronously (non-blocking)
                    watchConnectivity.activate()
                }
                .onOpenURL { url in
                    // Handle Garmin Connect IQ callbacks
                    _ = garminConnectivity.handleURL(url)
                }
        }
    }
}
