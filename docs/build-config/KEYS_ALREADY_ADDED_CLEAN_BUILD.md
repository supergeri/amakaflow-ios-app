# Keys Already Added - Clean Build Fix

## Problem

The Info tab already shows both HealthKit usage description keys, but you're still getting the runtime error. This usually means:

1. **Build cache is stale** - Xcode is using old build artifacts
2. **Derived data is cached** - Old Info.plist values are cached
3. **App bundle is outdated** - The built app doesn't have the latest Info.plist

## Solution: Clean Everything and Rebuild

### Step 1: Clean Build Folder

1. **Product → Clean Build Folder** (or press **Shift + Cmd + K**)
2. Wait for "Clean Succeeded" message

### Step 2: Delete Derived Data (Recommended)

This clears Xcode's cache completely:

1. **Xcode → Settings** (or **Xcode → Preferences** on older versions)
   - Or press **Cmd + ,** (comma)
2. **Click "Locations" tab**
3. **Find "Derived Data"** section
4. **Click the arrow icon** (→) next to the Derived Data path
   - This opens the Derived Data folder in Finder
5. **Close Xcode completely** (Cmd + Q)
6. **In Finder, delete the folder** that contains your project name
   - Look for a folder like `AmakaFlowCompanion-xxxxx` or similar
   - You can delete the entire DerivedData folder if you want (will affect all projects)
7. **Reopen Xcode**

### Step 3: Update Description Text (Optional but Recommended)

Your current description might need to be more specific. Let's update it:

1. In the **Info tab**, find **"Privacy - Health Update Usage Description"**
2. **Double-click** the value field
3. **Update the text to**:
   ```
   AmakaFlow Companion needs permission to save workout data (HKWorkoutTypeIdentifier) to Health
   ```
4. Press **Enter**

4. **Double-click** "Privacy - Health Share Usage Description"
5. **Update the text to**:
   ```
   AmakaFlow Companion needs access to read your workout data from Health
   ```
6. Press **Enter**

### Step 4: Rebuild Everything

1. **Product → Clean Build Folder** again (Shift + Cmd + K)
2. **Product → Build** (Cmd + B)
3. Wait for build to succeed
4. **Product → Run** (Cmd + R)
5. **Or stop the simulator and run again**

### Step 5: If Still Failing - Verify Info.plist Path

Make sure Xcode knows where the Info.plist file is:

1. **Select "AmakaFlowWatch Watch App" target**
2. **Go to Build Settings tab**
3. **Switch to "All" view** (not "Basic")
4. **Search for**: `info.plist`
5. **Find "Info.plist File" (INFOPLIST_FILE)**
6. **Should show**: `AmakaFlowWatch Watch App/Info.plist`

If it's empty or different:
- **Double-click** the value
- **Set to**: `AmakaFlowWatch Watch App/Info.plist`
- Press **Enter**

### Step 6: Verify in Actual Info.plist File

Check that the file on disk has the correct values:

1. In Project Navigator, find **"AmakaFlowWatch Watch App"** folder
2. **Right-click** `Info.plist` file
3. **Select "Open As" → "Source Code"** (or just double-click if it opens in a plain text editor)
4. **Verify** you see:
   ```xml
   <key>NSHealthShareUsageDescription</key>
   <string>AmakaFlow Companion needs access to read your workout data from Health</string>
   <key>NSHealthUpdateUsageDescription</key>
   <string>AmakaFlow Companion needs permission to save workout data (HKWorkoutTypeIdentifier) to Health</string>
   ```

## Why This Happens

Even though the keys are in the Info tab, Xcode might be:
- Using cached build artifacts
- Not properly merging Info.plist values
- Using an old app bundle from a previous build

**Cleaning Derived Data** forces Xcode to rebuild everything from scratch, ensuring the latest Info.plist values are included in the app bundle.

## Quick Checklist

- ✅ Keys are visible in Info tab (already done)
- ⬜ Clean Build Folder
- ⬜ Delete Derived Data
- ⬜ Update description text (make it more specific)
- ⬜ Rebuild
- ⬜ Verify Info.plist path in Build Settings
- ⬜ Test again

The **most important step** is **deleting Derived Data** - this usually fixes it!


