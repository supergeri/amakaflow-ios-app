# AmakaFlow Companion - Swift Implementation Guide

## 🎯 Quick Start

### Step 1: Create Xcode Project
1. Open Xcode 15+
2. File → New → Project
3. Select **iOS App** template
4. Configure:
   - Product Name: `AmakaFlowCompanion` (no spaces for bundle identifier)
   - Display Name: `AmakaFlow Companion` (shown to users)
   - Team: Your Apple Developer account
   - Organization Identifier: `com.yourcompany.amakaflow`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Include Tests: Optional

### Step 2: Add watchOS Target
1. File → New → Target
2. Select **watchOS → App**
3. Product Name: `AmakaFlowWatch`
4. Supports: **Watch App Only** (not companion app)
5. Minimum watchOS: **10.0** (for WorkoutKit)

### Step 3: Project Structure Setup
Copy the Swift files into your Xcode project:

```
AmakaFlow/
├── AmakaFlowApp.swift
├── Models/
│   └── Workout.swift
├── ViewModels/
│   └── WorkoutsViewModel.swift
├── Views/
│   ├── WorkoutsView.swift
│   ├── WorkoutDetailView.swift
│   ├── SettingsView.swift
│   └── Components/
│       ├── WorkoutCard.swift
│       ├── IntervalRow.swift
│       └── ScheduleCalendarSheet.swift
├── Services/
│   ├── WatchConnectivityManager.swift
│   ├── CalendarManager.swift
│   └── WorkoutKitManager.swift (optional)
└── Theme/
    └── Theme.swift

AmakaFlowWatch/
├── AmakaFlowWatchApp.swift
├── WatchWorkoutManager.swift
└── WorkoutListView.swift
```

### Step 4: Configure Capabilities

#### iOS Target Capabilities
1. Select your project → iOS target → **Signing & Capabilities**
2. Add capabilities:
   - **HealthKit**
   - **Background Modes** (for workout tracking)

#### watchOS Target Capabilities
1. Select watchOS target → **Signing & Capabilities**
2. Add capabilities:
   - **HealthKit**
   - **Workout Processing**

### Step 5: Update Info.plist

#### iOS Info.plist
Add these keys:
```xml
<key>NSCalendarsUsageDescription</key>
<string>AmakaFlow Companion schedules your workouts to your calendar with reminders</string>

<key>NSHealthShareUsageDescription</key>
<string>AmakaFlow Companion needs access to read your workout data</string>

<key>NSHealthUpdateUsageDescription</key>
<string>AmakaFlow Companion needs access to save your completed workouts</string>

<key>NSCalendarsWriteOnlyAccessUsageDescription</key>
<string>AmakaFlow Companion creates calendar events for your scheduled workouts</string>
```

#### watchOS Info.plist
Add these keys:
```xml
<key>NSHealthShareUsageDescription</key>
<string>AmakaFlow Companion needs access to track your workouts</string>

<key>NSHealthUpdateUsageDescription</key>
<string>AmakaFlow Companion saves your workout data to Health</string>
```

### Step 6: Add Frameworks

#### iOS Target
1. Select project → iOS target → **General**
2. Frameworks, Libraries, and Embedded Content → **+**
3. Add:
   - `EventKit.framework`
   - `HealthKit.framework`
   - `WatchConnectivity.framework`

#### watchOS Target
1. Select watchOS target → **General**
2. Add:
   - `WorkoutKit.framework` (watchOS 10+)
   - `HealthKit.framework`
   - `WatchConnectivity.framework`

---

## 🏗️ Architecture Overview

### iOS App Flow
```
User opens app
  ↓
WorkoutsView (Tab 1)
  ├── Upcoming Workouts (saved)
  └── Incoming Workouts (from backend)
  ↓
User taps workout
  ↓
WorkoutDetailView
  ├── Step-by-step breakdown
  ├── [Start on Apple Watch] → WatchConnectivityManager → Apple Watch
  └── [Schedule to Calendar] → CalendarManager → EventKit
```

### watchOS App Flow
```
User opens Watch app
  ↓
WorkoutListView
  ├── Shows workouts sent from iPhone
  └── Empty state if no workouts
  ↓
User selects workout
  ↓
WorkoutDetailWatchView
  ├── Shows intervals
  └── [Start Workout] → WorkoutKit → HealthKit
```

---

## 🔧 Key Implementation Details

### 1. WorkoutKit Integration (watchOS 10+)

WorkoutKit allows you to create structured workout plans that appear in the Apple Watch Workout app.

**Basic WorkoutKit Usage:**
```swift
import WorkoutKit

// Create workout composition
let composition = WorkoutComposition(
    activity: .run,
    displayName: "Interval Run",
    warmup: nil,
    blocks: [
        .work(goal: .time(300), target: .heartRate(zone: 2)),
        .work(goal: .distance(400), target: .pace(120...140)),
        .rest(goal: .time(120))
    ],
    cooldown: nil
)

// Preview workout
let preview = try await composition.preview()

// Schedule workout (launches Workout app)
try await composition.schedule()
```

**Limitations:**
- Cannot pre-schedule workouts for future dates (use Calendar instead)
- User must manually start workout from Watch
- Requires watchOS 10.0+

### 2. Calendar Integration (EventKit)

**Request Permission:**
```swift
let eventStore = EKEventStore()
let granted = try await eventStore.requestFullAccessToEvents()
```

**Create Event:**
```swift
let event = EKEvent(eventStore: eventStore)
event.title = "Full Body Strength Workout"
event.startDate = scheduledDate
event.endDate = scheduledDate.addingTimeInterval(1890) // duration
event.calendar = eventStore.defaultCalendarForNewEvents

// Add reminder
let alarm = EKAlarm(relativeOffset: -15 * 60) // 15 min before
event.addAlarm(alarm)

try eventStore.save(event, span: .thisEvent)
```

### 3. Watch Connectivity

**iPhone Side:**
```swift
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()
    private var session: WCSession?
    
    func activate() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sendWorkout(_ workout: Workout) async {
        guard let session = session, session.isReachable else { return }
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(workout)
        let dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        session.sendMessage(
            ["action": "receiveWorkout", "workout": dict],
            replyHandler: { reply in
                print("✅ Workout sent")
            }
        )
    }
}
```

**Watch Side:**
```swift
func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
    if let workoutDict = message["workout"] as? [String: Any] {
        let data = try JSONSerialization.data(withJSONObject: workoutDict)
        let workout = try JSONDecoder().decode(Workout.self, from: data)
        
        DispatchQueue.main.async {
            self.workouts.append(workout)
        }
        
        replyHandler(["status": "received"])
    }
}
```

---

## 🎨 Design System Implementation

The app uses a custom dark theme matching Figma specifications:

```swift
// Colors
Theme.Colors.background     // #0D0D0F
Theme.Colors.accentBlue     // #3A8BFF
Theme.Colors.accentGreen    // #4EDF9B
Theme.Colors.textPrimary    // White
Theme.Colors.textSecondary  // #9CA3AF

// Typography
Theme.Typography.largeTitle // 32pt, bold
Theme.Typography.title1     // 24pt, semibold
Theme.Typography.body       // 15pt, regular

// Spacing
Theme.Spacing.lg            // 24pt
Theme.CornerRadius.xl       // 20pt
```

**Usage:**
```swift
Text("Workouts")
    .font(Theme.Typography.largeTitle)
    .foregroundColor(Theme.Colors.textPrimary)

VStack(spacing: Theme.Spacing.lg) {
    // content
}
.background(Theme.Colors.surface)
.cornerRadius(Theme.CornerRadius.xl)
```

---

## 🧪 Testing

### Test Calendar Integration
```swift
// Add test button in SettingsView
Button("Test Calendar") {
    Task {
        let manager = CalendarManager()
        let testWorkout = Workout(...)
        try await manager.scheduleWorkout(
            workout: testWorkout,
            date: Date().addingTimeInterval(3600),
            time: "14:00"
        )
    }
}
```

### Test Watch Connectivity
1. Run iOS app on iPhone/Simulator
2. Run watchOS app on Watch/Simulator
3. Check console logs for "⌚️" messages
4. Tap "Start on Apple Watch" in iOS app
5. Verify workout appears in Watch app

---

## 📱 Deployment

### Requirements
- **iOS:** 17.0+
- **watchOS:** 10.0+ (for WorkoutKit)
- **Xcode:** 15.0+
- **Apple Developer Account:** Required for HealthKit entitlements

### App Store Submission
1. HealthKit requires app review before submission
2. Provide clear usage descriptions in Info.plist
3. Test on physical devices (HealthKit doesn't work in Simulator)
4. Include screenshots showing workout scheduling and Watch integration

---

## 🚀 Next Steps

1. **Backend Integration:**
   - Replace mock data with API calls
   - Add authentication (Clerk SDK for Swift)
   - Sync workouts from coach/training plans

2. **Enhanced Features:**
   - Local persistence (CoreData/SwiftData)
   - Workout history and analytics
   - Custom interval builder
   - Form guidance videos

3. **Watch Enhancements:**
   - Live workout metrics display
   - Haptic feedback for interval changes
   - Complications for quick access

---

## 📚 Resources

- [WorkoutKit Documentation](https://developer.apple.com/documentation/workoutkit)
- [EventKit Guide](https://developer.apple.com/documentation/eventkit)
- [WatchConnectivity](https://developer.apple.com/documentation/watchconnectivity)
- [HealthKit](https://developer.apple.com/documentation/healthkit)

---

## ⚠️ Important Notes

1. **WorkoutKit Limitation:** You cannot pre-schedule workouts to Apple Fitness like Garmin. WorkoutKit creates structured workout plans that users must manually start.

2. **Calendar Approach:** This is the Apple-approved way to schedule workouts with reminders.

3. **Testing:** HealthKit features require physical devices - they don't work in Simulator.

4. **Permissions:** Always request permissions before accessing Calendar or HealthKit.

5. **Watch App:** Must be standalone (not companion app) for watchOS 10+.
