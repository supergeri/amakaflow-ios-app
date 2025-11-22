# Check Target Membership - Fix Blank Detail Screen

## Problem: Console Shows No Errors, But Screen is Blank

The console logs show no errors, which means the app isn't crashing. The blank screen is likely because **files aren't included in the target**, so they're not compiled/running.

## Solution: Verify Target Membership

### Step 1: Check WorkoutDetailView.swift

1. **In Project Navigator**, find `WorkoutDetailView.swift`
   - Location: `AmakaFlow/Views/WorkoutDetailView.swift`
2. **Click the file** to select it
3. **Open File Inspector** (right sidebar, or press **Option+Cmd+1**)
4. **Look for "Target Membership"** section
5. **Check** ✅ **"AmakaFlowCompanion"** (iOS app target)
   - If unchecked, **check it** ✅
6. **Also check** ✅ **"AmakaFlowWatch Watch App"** (if you want watch support)

### Step 2: Check IntervalRow.swift

1. **Find** `IntervalRow.swift`
   - Location: `AmakaFlow/Views/Components/IntervalRow.swift`
2. **Select it**
3. **File Inspector** → **Target Membership**
4. **Check** ✅ **"AmakaFlowCompanion"**

### Step 3: Check ScheduleCalendarSheet.swift

1. **Find** `ScheduleCalendarSheet.swift`
   - Location: `AmakaFlow/Views/Components/ScheduleCalendarSheet.swift`
2. **Select it**
3. **File Inspector** → **Target Membership**
4. **Check** ✅ **"AmakaFlowCompanion"**

### Step 4: Check All Required Files

Verify these files are in **"AmakaFlowCompanion"** target:

**Models:**
- ✅ `Workout.swift` (`AmakaFlow/Models/Workout.swift`)
- ✅ `ScheduledWorkout` (if separate file)

**Views:**
- ✅ `WorkoutDetailView.swift`
- ✅ `WorkoutHeaderCard` (inside WorkoutDetailView.swift)
- ✅ `IntervalRow.swift`
- ✅ `ScheduleCalendarSheet.swift`
- ✅ `WorkoutCard.swift`
- ✅ `WorkoutsView.swift`
- ✅ `SettingsView.swift`

**Services:**
- ✅ `CalendarManager.swift`
- ✅ `WorkoutKitConverter.swift`
- ✅ `WatchConnectivityManager.swift`

**Utilities:**
- ✅ `Theme.swift`
- ✅ `WorkoutHelpers` (if separate file)

### Step 5: Check Build Settings

Sometimes files are in the project but not in "Compile Sources":

1. **Select "AmakaFlowCompanion" target** (blue project icon → TARGETS → AmakaFlowCompanion)
2. **Build Phases** tab
3. **Expand "Compile Sources"**
4. **Verify** all Swift files are listed
5. **If missing**, click **"+"** and add them

### Step 6: Clean and Rebuild

After adding files to target:

1. **Product → Clean Build Folder** (Shift + Cmd + K)
2. **Wait for "Clean Succeeded"**
3. **Product → Build** (Cmd + B)
4. **Check Issue Navigator** for errors
   - If you see errors like "Cannot find 'WorkoutHeaderCard' in scope", those files are missing from target
5. **Product → Run** (Cmd + R)

## Quick Test

After fixing target membership, try this:

1. **Tap on a workout** in the list
2. **Check console** - should still show no errors
3. **Screen should now show content** instead of blank

## Visual Guide

**File Inspector → Target Membership:**
```
┌─────────────────────────┐
│ File Inspector          │
├─────────────────────────┤
│ Identity and Type       │
│ Location: Relative      │
│                         │
│ Target Membership       │
│ □ AmakaFlowCompanion    │ ← Check this!
│ □ AmakaFlowWatch...     │
│                         │
│ Text Settings           │
└─────────────────────────┘
```

## What to Look For

✅ **Good**: Checkbox is checked for "AmakaFlowCompanion"
❌ **Bad**: Checkbox is unchecked (file not in target)

## Why This Happens

When you add files to an Xcode project, they might:
1. Be added to the project but **not to any target**
2. Be added to the wrong target (e.g., watchOS instead of iOS)
3. Have been moved or renamed, breaking the target membership

**Target Membership** determines which targets (iOS app, watchOS app, tests) a file is compiled for.

## Still Blank After Fixing?

If it's still blank after verifying target membership:

1. **Check console** for new errors (there might be runtime errors now)
2. **Try the minimal test view** (see `DEBUG_BLANK_SCREEN.md`)
3. **Verify workout data** - check if `workout.intervals` has data
4. **Check if view is actually being created** - add breakpoint in `WorkoutDetailView.init`

The most common cause of a blank screen with no console errors is **missing target membership**!


