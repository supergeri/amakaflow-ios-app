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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutsViewModel)
                .environmentObject(watchConnectivity)
                .preferredColorScheme(.dark) // Force dark mode
                .task {
                    // Initialize WatchConnectivity asynchronously (non-blocking)
                    watchConnectivity.activate()
                }
        }
    }
}
