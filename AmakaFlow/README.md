# AmakaFlow Companion - Swift Implementation Guide

## Project Structure

```
AmakaFlow/
├── AmakaFlow.xcodeproj
├── AmakaFlow/                          # iOS App
│   ├── AmakaFlowApp.swift             # App entry point
│   ├── Models/
│   │   ├── Workout.swift              # Workout data models
│   │   └── WorkoutInterval.swift      # Interval types
│   ├── ViewModels/
│   │   ├── WorkoutsViewModel.swift    # Workouts logic
│   │   └── SettingsViewModel.swift    # Settings logic
│   ├── Views/
│   │   ├── WorkoutsView.swift         # Main workouts screen
│   │   ├── WorkoutDetailView.swift    # Workout detail screen
│   │   ├── SettingsView.swift         # Settings screen
│   │   └── Components/
│   │       ├── WorkoutCard.swift
│   │       ├── IntervalRow.swift
│   │       └── ScheduleCalendarSheet.swift
│   ├── Services/
│   │   ├── WatchConnectivityManager.swift  # Watch sync
│   │   ├── CalendarManager.swift           # EventKit integration
│   │   └── WorkoutKitManager.swift         # WorkoutKit wrapper
│   └── Theme/
│       └── Theme.swift                     # Design system colors
│
└── AmakaFlowWatch/                     # watchOS App
    ├── AmakaFlowWatchApp.swift
    ├── Views/
    │   ├── WorkoutListView.swift
    │   └── WorkoutRunnerView.swift
    └── Services/
        └── WatchWorkoutManager.swift
```

## Setup Steps

### 1. Create Xcode Project
1. Open Xcode → Create New Project
2. Choose "iOS App" template
3. Product Name: "AmakaFlowCompanion" (Display Name: "AmakaFlow Companion")
4. Interface: SwiftUI
5. Language: Swift
6. Add watchOS target: File → New → Target → watchOS App

### 2. Required Capabilities & Frameworks
- **iOS Target:**
  - EventKit (Calendar access)
  - HealthKit (Workout data)
  - WatchConnectivity (Watch sync)
  
- **watchOS Target:**
  - WorkoutKit (iOS 17+/watchOS 10+)
  - HealthKit
  - WatchConnectivity

### 3. Info.plist Permissions
Add to iOS Info.plist:
```xml
<key>NSCalendarsUsageDescription</key>
<string>AmakaFlow Companion needs calendar access to schedule your workouts</string>
<key>NSHealthShareUsageDescription</key>
<string>AmakaFlow Companion needs access to save workout data</string>
<key>NSHealthUpdateUsageDescription</key>
<string>AmakaFlow Companion needs access to record workout metrics</string>
```

### 4. Key Implementation Notes

**WorkoutKit (watchOS 10+):**
- Use `WorkoutKit` framework to create custom workout plans
- Structure intervals using `WorkoutStep` types
- Send workout to Watch via WatchConnectivity

**Calendar Integration:**
- Use EventKit's `EKEventStore`
- Request calendar access permission
- Create events with reminders

**Watch Connectivity:**
- Use WCSession for bidirectional communication
- Send workout definitions from iPhone to Watch
- Transfer large data via `transferUserInfo`

## Design System (Theme.swift)

```swift
// Colors from Figma reference
Background: #0D0D0F
Accent Blue: #3A8BFF
Accent Green: #4EDF9B
Typography: Inter (SF Pro as fallback)
```

## Deployment Targets
- iOS: 17.0+
- watchOS: 10.0+
- Xcode: 15.0+
