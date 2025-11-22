# Fix Build Errors

## Current Errors

1. ❌ **"'main' attribute can only apply to one type in a module"** - Multiple `@main` files
2. ❌ **"Cannot find type 'Workout' in scope"** - Model files not in watchOS target
3. ❌ **Missing 'Combine' import** - Need to import Combine
4. ❌ **Multiple watchOS targets** - Duplicate targets or files

## Fix 1: Remove Duplicate Main Files

### Problem
You have multiple files with `@main` attribute:
- `AmakaFlowWatchApp` 
- `AmakaFlowWatchApp 2`

Only ONE file can have `@main` per target.

### Solution

1. **In Project Navigator**, find these files:
   - `AmakaFlowWatchApp.swift` (should be the one)
   - `AmakaFlowWatchApp 2.swift` (duplicate - needs to be removed or have `@main` removed)

2. **Check both files**:
   - Open each file
   - Look for `@main` attribute above the `@EntryPoint` or `App` struct
   - Keep only ONE file with `@main`

3. **Fix the duplicate**:
   - **Option A**: Delete the duplicate file (`AmakaFlowWatchApp 2.swift`)
   - **Option B**: Remove `@main` from one of them if you need both files

## Fix 2: Add Model Files to watchOS Target

### Problem
`WatchWorkoutManager` and `WorkoutListView` can't find:
- `Workout`
- `WorkoutSport`
- `WorkoutInterval`
- `WorkoutActivity`

This means `Workout.swift` model file is NOT added to the watchOS target.

### Solution

1. **In Project Navigator**, find `Workout.swift` (in `AmakaFlow/Models/` folder)

2. **Select the file** and check Target Membership:
   - Click on `Workout.swift`
   - Look at **File Inspector** (right sidebar)
   - Scroll down to **"Target Membership"**
   - ✅ **Check "AmakaFlowWatch Watch App"** target
   - The file should have BOTH targets checked:
     - ✅ AmakaFlowCompanion (iOS)
     - ✅ AmakaFlowWatch Watch App (watchOS)

3. **If Target Membership doesn't show the watchOS target**:
   - Select `Workout.swift`
   - Right-click → **Get Info** (or press Cmd + I)
   - Or check File Inspector → Target Membership
   - Manually check **"AmakaFlowWatch Watch App"**

## Fix 3: Add Missing Import to WatchWorkoutManager

### Problem
`WatchWorkoutManager` needs `Combine` import for `ObservableObject`.

### Solution

1. **Open** `WatchWorkoutManager.swift`
2. **At the top of the file**, add:
   ```swift
   import Combine
   ```
3. **Save** the file (Cmd + S)

## Fix 4: Clean Up Duplicate Targets

### Problem
You have multiple watchOS targets:
- AmakaFlowWatch
- AmakaFlowWatch Watch App ✅ (this is the correct one)
- AmakaFlowWatch Watch App Extension
- AmakaFlowWatch Watch App 2 ❌ (duplicate?)

### Solution

1. **In TARGETS list**, check which targets actually exist
2. **"AmakaFlowWatch Watch App"** should be your main watchOS app target
3. **If "AmakaFlowWatch Watch App 2" is a duplicate**:
   - Right-click on it → **Delete**
   - Choose **"Delete Target"** (not just "Remove Reference")

4. **If "AmakaFlowWatch Watch App Extension"** was created by mistake:
   - You might not need it if you're not using a WatchKit Extension
   - Keep it if it's required by your app architecture

## Step-by-Step Fix Order

### Step 1: Remove Duplicate Main Files
1. Find duplicate `AmakaFlowWatchApp` files
2. Remove `@main` from one or delete duplicate
3. Keep only ONE `@main` file

### Step 2: Add Workout Model to watchOS Target
1. Select `Workout.swift`
2. File Inspector → Target Membership
3. ✅ Check "AmakaFlowWatch Watch App"
4. Save

### Step 3: Add Combine Import
1. Open `WatchWorkoutManager.swift`
2. Add `import Combine` at top
3. Save

### Step 4: Clean and Rebuild
1. **Product → Clean Build Folder** (Shift + Cmd + K)
2. **Build again** (Cmd + B)
3. Check if errors are resolved

## Quick Checklist

- [ ] Only ONE `@main` file in watchOS target
- [ ] `Workout.swift` is added to **AmakaFlowWatch Watch App** target
- [ ] `WatchWorkoutManager.swift` has `import Combine`
- [ ] Duplicate targets removed (if any)
- [ ] Clean build folder
- [ ] Rebuild project

## Next Steps After Fixing

1. ✅ Build the project (Cmd + B)
2. ✅ Fix any remaining errors
3. ✅ Test on simulator or device
4. ✅ Continue with remaining setup steps


