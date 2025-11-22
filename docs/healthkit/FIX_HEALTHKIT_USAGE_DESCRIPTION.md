# Fix NSHealthUpdateUsageDescription Error

## Problem

Build succeeds but runtime error:
```
Thread 1: "NSHealthUpdateUsageDescription must be set in the app's Info.plist in order to request write authorization for the following types: HKWorkoutTypeIdentifier"
```

## Solution

The Info.plist file already has the key, but Xcode might not be reading it correctly. Let's verify the setup:

### Step 1: Verify Info.plist Path in Build Settings

1. **Select "AmakaFlowWatch Watch App" target** in TARGETS
2. **Go to Build Settings tab**
3. **Switch to "All" view** (not "Basic")
4. **Search for**: `info.plist`
5. **Find "Info.plist File"**

**Should show**: `AmakaFlowWatch Watch App/Info.plist` ✅

If it's empty or different:
1. **Double-click** the value field
2. **Set it to**: `AmakaFlowWatch Watch App/Info.plist`
3. **Press Enter**

### Step 2: Verify Info.plist Content

The Info.plist file should have:

```xml
<key>NSHealthShareUsageDescription</key>
<string>AmakaFlow Companion needs access to read your workout data from Health</string>

<key>NSHealthUpdateUsageDescription</key>
<string>AmakaFlow Companion needs permission to save workout data (HKWorkoutTypeIdentifier) to Health</string>
```

✅ This has already been updated in the file.

### Step 3: Clean Build Folder

Sometimes Xcode caches old Info.plist values:

1. **Product → Clean Build Folder** (Shift + Cmd + K)
2. **Wait for cleanup to complete**

### Step 4: Delete Derived Data (if needed)

If cleaning doesn't help:

1. **Xcode → Settings** (or **Preferences**)
2. **Locations tab**
3. **Click the arrow** next to "Derived Data" path
4. **Close Xcode**
5. **Delete the folder** for your project
6. **Reopen Xcode and rebuild**

### Step 5: Verify in Info Tab (Alternative Method)

You can also add the keys via Xcode's Info tab:

1. **Select "AmakaFlowWatch Watch App" target**
2. **Go to Info tab**
3. **Click the "+" button** next to "Custom iOS Target Properties"
4. **Type**: `NSHealthUpdateUsageDescription`
5. **Set value**: `AmakaFlow Companion needs permission to save workout data (HKWorkoutTypeIdentifier) to Health`
6. **Repeat for** `NSHealthShareUsageDescription` if not already there

### Step 6: Rebuild and Test

1. **Product → Clean Build Folder** (Shift + Cmd + K)
2. **Build**: Press Cmd + B
3. **Run**: Press Cmd + R
4. **Error should be resolved!**

## Why This Happens

Sometimes Xcode doesn't recognize Info.plist keys if:
- The Info.plist path in Build Settings is incorrect
- Derived data is stale
- The format of the Info.plist file is slightly off
- The keys were added manually but Xcode hasn't refreshed

The most common fix is **cleaning the build folder** and **verifying the Info.plist path in Build Settings**.


