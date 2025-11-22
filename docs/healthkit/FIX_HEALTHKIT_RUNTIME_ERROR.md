# Fix NSHealthUpdateUsageDescription Runtime Error

## Problem

Info.plist file has the key, but runtime still crashes with:
```
"NSHealthUpdateUsageDescription must be set in the app's Info.plist"
```

This means Xcode isn't reading the Info.plist file correctly or it's not being bundled.

## Solution: Add via Info Tab (Most Reliable Method)

Sometimes manually editing the Info.plist file doesn't get picked up. Adding it via Xcode's Info tab is more reliable:

### Step 1: Open Info Tab

1. **Click the blue project icon** at top of Project Navigator
2. Under **TARGETS**, click **"AmakaFlowWatch Watch App"** (not parent "AmakaFlowWatch")
3. **Click the "Info" tab** (next to "General", "Signing & Capabilities", etc.)

### Step 2: Add HealthKit Usage Descriptions

1. In the Info tab, you'll see **"Custom watchOS Target Properties"** section
2. **Click the "+" button** to add a new key

3. **Add `NSHealthShareUsageDescription`:**
   - Type: `NSHealthShareUsageDescription`
   - Value: `AmakaFlow Companion needs access to read your workout data from Health`
   - Type: **String**
   - Press **Enter**

4. **Add `NSHealthUpdateUsageDescription`:**
   - Click **"+"** again
   - Type: `NSHealthUpdateUsageDescription`
   - Value: `AmakaFlow Companion needs permission to save workout data to Health`
   - Type: **String**
   - Press **Enter**

### Step 3: Verify in Info Tab

You should now see both keys listed:
```
Custom watchOS Target Properties
├─ NSHealthShareUsageDescription: "AmakaFlow Companion needs access..."
└─ NSHealthUpdateUsageDescription: "AmakaFlow Companion needs permission..."
```

### Step 4: Clean and Rebuild

1. **Product → Clean Build Folder** (Shift + Cmd + K)
2. **Product → Build** (Cmd + B)
3. **Product → Run** (Cmd + R)

## Alternative: Verify Info.plist Path in Build Settings

If adding via Info tab doesn't work, check the Build Settings:

### Step 1: Check Info.plist Path

1. Select **"AmakaFlowWatch Watch App" target**
2. Go to **Build Settings tab**
3. Switch to **"All" view** (not "Basic")
4. Search for: `info.plist`
5. Find **"Info.plist File"** (INFOPLIST_FILE)

**Should show**: `AmakaFlowWatch Watch App/Info.plist`

If it's empty or different:
- **Double-click** the value
- **Set to**: `AmakaFlowWatch Watch App/Info.plist`
- Press **Enter**

### Step 2: Verify File Exists

1. In Project Navigator, expand **"AmakaFlowWatch Watch App"** folder
2. **Verify** `Info.plist` file is listed there
3. **Right-click** `Info.plist` → **Show in Finder**
4. **Verify** the file exists at that location

### Step 3: Check Target Membership

1. **Select** `Info.plist` file in Project Navigator
2. Open **File Inspector** (right sidebar, or **Option+Cmd+1**)
3. Under **Target Membership**, verify **"AmakaFlowWatch Watch App"** is checked ✅

## Why This Happens

Xcode sometimes doesn't recognize Info.plist changes when:
1. **File is edited manually** instead of via Info tab
2. **Info.plist path in Build Settings is incorrect**
3. **File isn't included in the target's bundle**
4. **Derived data is stale** and needs cleaning

## Recommended Fix Order

1. ✅ **Try Info Tab method first** (most reliable)
2. ✅ **Clean Build Folder**
3. ✅ **Verify Info.plist path in Build Settings**
4. ✅ **Delete Derived Data** (if still failing)
5. ✅ **Restart Xcode** (last resort)

The **Info Tab method** usually fixes it because Xcode manages the Info.plist internally when you add keys through the UI.


