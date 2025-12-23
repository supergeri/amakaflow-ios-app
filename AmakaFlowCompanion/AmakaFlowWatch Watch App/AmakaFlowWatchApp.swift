//
//  AmakaFlowWatchApp.swift
//  AmakaFlowWatch Watch App
//
//  Main entry point for AmakaFlowWatch Watch App
//

import SwiftUI

@main
struct AmakaFlowWatchApp: App {
    @StateObject private var workoutManager = WatchWorkoutManager()
    @StateObject private var connectivityBridge = WatchConnectivityBridge.shared

    var body: some Scene {
        WindowGroup {
            WatchRemoteView(bridge: connectivityBridge)
                .environmentObject(workoutManager)
                .environmentObject(connectivityBridge)
        }
    }
}
