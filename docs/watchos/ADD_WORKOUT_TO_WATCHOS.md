# Add Workout.swift to watchOS Target

## Problem
All the "Cannot find type 'Workout' in scope" errors mean `Workout.swift` is NOT in the watchOS target.

## Solution: Add Workout.swift to watchOS Target

### Method 1: Check Target Membership (Easiest)

1. **In Project Navigator** (left sidebar):
   - Find `Workout.swift` 
   - It's in the `AmakaFlow/Models/` folder (or wherever you see it)

2. **Select `Workout.swift`** (click on it)

3. **Open File Inspector** (right sidebar):
   - Click the **File Inspector** tab (document icon)
   - Or press **Option + Cmd + 1**

4. **Scroll down** to find **"Target Membership"** section

5. **Check the targets**:
   - ✅ **AmakaFlowCompanion** (iOS) - should already be checked
   - ✅ **AmakaFlowWatch Watch App** (watchOS) - **CHECK THIS ONE** ✅

6. **If "AmakaFlowWatch Watch App" is not listed**:
   - The file might need to be re-added
   - Use Method 2 below

### Method 2: Re-add File to Target (If Method 1 Doesn't Work)

1. **Remove the file from project** (don't delete it):
   - Right-click on `Workout.swift` in Project Navigator
   - Select **"Delete"**
   - Choose **"Remove Reference"** (NOT "Move to Trash")

2. **Re-add the file with watchOS target**:
   - Right-click on **"AmakaFlowWatch Watch App"** folder in Project Navigator
   - Select **"Add Files to 'AmakaFlowCompanion'..."**
   - Navigate to: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlow/Models/`
   - Select `Workout.swift`
   - **Options at bottom**:
     - ✅ Check **"AmakaFlowWatch Watch App"** target
     - ✅ Also check **"AmakaFlowCompanion"** target (if not already)
     - Uncheck "Copy items if needed"
   - Click **"Add"**

### Method 3: Add via Build Phases (Alternative)

1. **Select "AmakaFlowWatch Watch App" target**
2. **Go to "Build Phases" tab**
3. **Expand "Compile Sources" section**
4. **Click "+" button**
5. **Find and select** `Workout.swift`
6. **Click "Add"**

## Verify It's Added

After adding, verify:

1. **Select `Workout.swift`** in Project Navigator
2. **File Inspector → Target Membership**:
   - Should show:
     - ✅ **AmakaFlowCompanion** (checked)
     - ✅ **AmakaFlowWatch Watch App** (checked) ← This is what was missing!

## Clean and Rebuild

After adding to target:

1. **Clean Build Folder**: 
   - Product → Clean Build Folder (Shift + Cmd + K)

2. **Build**:
   - Press **Cmd + B**

3. **Errors should disappear**! ✅

## Quick Checklist

- [ ] `Workout.swift` is selected
- [ ] File Inspector → Target Membership shows both targets checked:
  - [ ] ✅ AmakaFlowCompanion (iOS)
  - [ ] ✅ AmakaFlowWatch Watch App (watchOS)
- [ ] Clean build folder
- [ ] Rebuild project
- [ ] Errors are resolved

## Why This Happens

- `Workout.swift` was originally added to iOS target only
- watchOS files (`WatchWorkoutManager`, `WorkoutListView`) need access to `Workout` type
- watchOS target needs `Workout.swift` in its "Compile Sources" build phase
- Adding to target membership includes it in the build

## Next Steps

After fixing this:
1. ✅ All "Cannot find type 'Workout'" errors should be gone
2. ✅ Build should succeed
3. ✅ You can continue with testing the app


