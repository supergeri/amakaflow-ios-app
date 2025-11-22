# Fix Blank Workout Detail Screen

## Problem: Blank Screen When Clicking on Workout

When you tap a workout, the detail screen appears blank/black.

## Fixes Applied

### 1. ✅ Added Missing Environment Object
- **Issue**: `WorkoutDetailView` needs `WorkoutsViewModel` as environment object
- **Fix**: Added `.environmentObject(viewModel)` when presenting the sheet

### 2. ✅ Added Safety Check for Empty Intervals
- **Issue**: View might crash if workout has no intervals
- **Fix**: Added check to show message if intervals are empty

## Additional Troubleshooting

### Check 1: Verify Files Are in Target

Make sure these files are included in **AmakaFlowCompanion** target:

1. **Select file** in Project Navigator
2. **File Inspector** (Option+Cmd+1)
3. **Target Membership** → Check ✅ **"AmakaFlowCompanion"**

Required files:
- ✅ `WorkoutDetailView.swift`
- ✅ `WorkoutHeaderCard` (inside WorkoutDetailView.swift)
- ✅ `IntervalRow.swift`
- ✅ `ScheduleCalendarSheet.swift`
- ✅ `WorkoutKitConverter.swift`
- ✅ `CalendarManager.swift`

### Check 2: Verify Workout Data

The workout might have invalid data. Check console for errors:

1. **Run app** (Cmd + R)
2. **Open Console** (View → Debug Area → Show Debug Area)
3. **Tap on a workout**
4. **Look for errors** like:
   - "Cannot find 'IntervalRow' in scope"
   - "Cannot find 'WorkoutHeaderCard' in scope"
   - "Fatal error: Array index out of range"

### Check 3: Test with Simple View

Temporarily replace `WorkoutDetailView` body with a simple test:

```swift
var body: some View {
    NavigationStack {
        VStack {
            Text("Workout: \(workout.name)")
                .foregroundColor(.white)
                .padding()
            
            Text("Intervals: \(workout.intervals.count)")
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}
```

If this shows, the issue is with the view rendering. If it's still blank, it's a navigation/presentation issue.

### Check 4: Verify Sheet Presentation

The sheet might not be presenting. Check:

1. **Is `showingDetail` being set?**
   - Add `print("Showing detail: \(showingDetail)")` in `WorkoutsView`
   - Add `print("Selected workout: \(selectedWorkout?.name ?? "nil")")` 

2. **Is the workout valid?**
   - Add `print("Workout intervals: \(workout.intervals.count)")` in `WorkoutDetailView.init`

### Check 5: Check for Crashes

1. **Run app** with breakpoints
2. **Set breakpoint** at start of `WorkoutDetailView.body`
3. **Tap workout**
4. **Does it hit the breakpoint?**
   - ✅ Yes → View is being created, issue is in rendering
   - ❌ No → View isn't being created, issue is in presentation

## Common Causes

1. ❌ **Missing environment object** (FIXED ✅)
2. ❌ **Files not in target** (check Target Membership)
3. ❌ **Crash during rendering** (check console)
4. ❌ **Empty intervals array** (FIXED ✅)
5. ❌ **Missing dependencies** (Theme, Workout model, etc.)

## Quick Test

1. **Clean Build Folder** (Shift + Cmd + K)
2. **Build** (Cmd + B)
3. **Check for errors**
4. **Run** (Cmd + R)
5. **Tap workout**
6. **Check console** for errors

If still blank, check the **Issue Navigator** for build errors and verify all files are in the target.


