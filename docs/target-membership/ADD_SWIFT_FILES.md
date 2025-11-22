# Step 6: Add Swift Files to Xcode Project

## Current Status
✅ HealthKit setup complete for both iOS and watchOS targets
✅ Swift files are ready in `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlow/`

## Next: Add Files to Project

### Part 1: Add iOS Swift Files (AmakaFlowCompanion target)

#### Step 1: Add Main Files

1. **Right-click** on **"AmakaFlowCompanion"** folder in Project Navigator (left sidebar)
2. Select **"Add Files to 'AmakaFlowCompanion'..."**
3. **Navigate to**: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlow/`
4. **Select these files**:
   - `AmakaFlowApp.swift`
   - `Theme.swift`
5. **Options at bottom of dialog**:
   - ✅ **IMPORTANT**: Under "Add to targets", check ✅ **AmakaFlowCompanion** (iOS target)
   - **Uncheck** "Copy items if needed" (files are already in the right place)
   - **Uncheck** "AmakaFlowWatch" if it's checked
6. Click **"Add"**

#### Step 2: Add Models

1. **Right-click** on **"AmakaFlowCompanion"** folder again
2. Select **"Add Files to 'AmakaFlowCompanion'..."**
3. **Navigate to**: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlow/Models/`
4. **Select**:
   - `Workout.swift`
5. **Options**:
   - ✅ Check **AmakaFlowCompanion** target
   - Uncheck "Copy items if needed"
6. Click **"Add"**

#### Step 3: Add ViewModels

1. **Right-click** on **"AmakaFlowCompanion"** folder
2. Select **"Add Files to 'AmakaFlowCompanion'..."**
3. **Navigate to**: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlow/ViewModels/`
4. **Select**:
   - `WorkoutsViewModel.swift`
5. **Options**:
   - ✅ Check **AmakaFlowCompanion** target
   - Uncheck "Copy items if needed"
6. Click **"Add"**

#### Step 4: Add Views

1. **Right-click** on **"AmakaFlowCompanion"** folder
2. Select **"Add Files to 'AmakaFlowCompanion'..."**
3. **Navigate to**: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlow/Views/`
4. **Select all** `.swift` files:
   - `WorkoutsView.swift`
   - `WorkoutDetailView.swift`
   - `SettingsView.swift`
5. **Options**:
   - ✅ Check **AmakaFlowCompanion** target
   - Uncheck "Copy items if needed"
6. Click **"Add"**

#### Step 5: Add View Components

1. **Right-click** on **"AmakaFlowCompanion"** folder
2. Select **"Add Files to 'AmakaFlowCompanion'..."**
3. **Navigate to**: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlow/Views/Components/`
4. **Select all** `.swift` files:
   - `IntervalRow.swift`
   - `ScheduleCalendarSheet.swift`
   - `WorkoutCard.swift`
5. **Options**:
   - ✅ Check **AmakaFlowCompanion** target
   - Uncheck "Copy items if needed"
6. Click **"Add"**

#### Step 6: Add Services

1. **Right-click** on **"AmakaFlowCompanion"** folder
2. Select **"Add Files to 'AmakaFlowCompanion'..."**
3. **Navigate to**: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlow/Services/`
4. **Select all** `.swift` files:
   - `APIService.swift`
   - `AuthService.swift`
   - `CalendarManager.swift`
   - `WatchConnectivityManager.swift`
   - `WorkoutKitConverter.swift`
5. **Options**:
   - ✅ Check **AmakaFlowCompanion** target
   - Uncheck "Copy items if needed"
6. Click **"Add"**

### Part 2: Add watchOS Swift Files (AmakaFlowWatch target)

1. **Right-click** on **"AmakaFlowWatch Watch App"** folder in Project Navigator
2. Select **"Add Files to 'AmakaFlowCompanion'..."**
3. **Navigate to**: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlowWatch/`
4. **Select all** `.swift` files:
   - `AmakaFlowWatchApp.swift`
   - `WatchWorkoutManager.swift`
   - `WorkoutListView.swift`
5. **Options**:
   - ✅ **IMPORTANT**: Check ✅ **AmakaFlowWatch** target (watchOS only)
   - **Uncheck** "AmakaFlowCompanion" if it's checked
   - Uncheck "Copy items if needed"
6. Click **"Add"**

### Part 3: Delete Default Xcode Files (Optional)

If Xcode created default files that conflict with your files, you may want to remove them:

1. **Delete** `ContentView.swift` (if you have your own view files)
2. **Keep** `AmakaFlowCompanionApp.swift` (or replace with `AmakaFlowApp.swift` if that's your main app file)
3. **Delete** any default `Item.swift` if it's not needed

⚠️ **Before deleting**, make sure your added files work first!

### Part 4: Verify Target Membership

After adding all files, verify they're in the correct targets:

1. **Select any Swift file** in Project Navigator
2. **Open File Inspector** (right sidebar, or press **Option + Cmd + 1**)
3. **Scroll down** to **"Target Membership"** section
4. **Verify**:
   - iOS files should have ✅ **AmakaFlowCompanion** checked
   - watchOS files should have ✅ **AmakaFlowWatch** checked
5. **If not checked**, check the appropriate target manually

## Quick Checklist

### iOS Files (AmakaFlowCompanion target):
- [ ] `AmakaFlowApp.swift`
- [ ] `Theme.swift`
- [ ] `Models/Workout.swift`
- [ ] `ViewModels/WorkoutsViewModel.swift`
- [ ] `Views/WorkoutsView.swift`
- [ ] `Views/WorkoutDetailView.swift`
- [ ] `Views/SettingsView.swift`
- [ ] `Views/Components/IntervalRow.swift`
- [ ] `Views/Components/ScheduleCalendarSheet.swift`
- [ ] `Views/Components/WorkoutCard.swift`
- [ ] `Services/APIService.swift`
- [ ] `Services/AuthService.swift`
- [ ] `Services/CalendarManager.swift`
- [ ] `Services/WatchConnectivityManager.swift`
- [ ] `Services/WorkoutKitConverter.swift`

### watchOS Files (AmakaFlowWatch target):
- [ ] `AmakaFlowWatchApp.swift`
- [ ] `WatchWorkoutManager.swift`
- [ ] `WorkoutListView.swift`

## Next Steps

After adding all files:
1. **Build the project**: Press **Cmd + B**
2. **Fix any errors** that appear (imports, target membership, etc.)
3. **Test on simulator** or device
4. **Verify all functionality** works

## Troubleshooting

### "Cannot find type" errors:
- Check that files are added to the correct target
- Verify Target Membership in File Inspector
- Make sure imports are correct

### "Duplicate symbol" errors:
- You might have added files twice
- Or default Xcode files conflict with your files
- Delete duplicate files or default files

### Build errors:
- Check that all required frameworks are linked
- Verify package dependencies are added (WorkoutKitSync)
- Make sure Info.plist files have all required keys


