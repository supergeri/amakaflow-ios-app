//
//  ContentView.swift
//  AmakaFlowCompanion
//
//  Main content view for AmakaFlow Companion iOS app
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .workouts
    
    enum Tab {
        case workouts
        case settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WorkoutsView()
                .tag(Tab.workouts)
            
            SettingsView()
                .tag(Tab.settings)
        }
        .tint(Theme.Colors.accentBlue)
    }
}

#Preview {
    ContentView()
        .environmentObject(WorkoutsViewModel())
        .environmentObject(WatchConnectivityManager.shared)
}
