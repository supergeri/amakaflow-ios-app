# watchOS HealthKit Setup - Capabilities Not Supported

## Problem
When trying to add HealthKit capability to the **AmakaFlowWatch** target, you see:
- "No matches"
- "Capabilities are not supported for 'AmakaFlowWatch'"

## Why This Happens
**watchOS targets do NOT support the Capabilities UI panel** in Xcode. This is a known limitation. You must configure HealthKit manually through entitlements and Info.plist files.

## Solution: Manual HealthKit Configuration for watchOS

### Step 1: Create Entitlements File (if it doesn't exist)

1. **Click the blue project icon** at top of Project Navigator
2. Find **TARGETS** section → Click **"AmakaFlowWatch"**
3. Go to **Signing & Capabilities** tab
4. Look at **"Code Signing Entitlements"** field:
   - If it shows a path (e.g., `AmakaFlowWatch/AmakaFlowWatch.entitlements`), skip to Step 2
   - If it's empty, continue below

5. **Create entitlements file**:
   - In Project Navigator, right-click on **AmakaFlowWatch Watch App** folder
   - Select **New File...**
   - Choose **Property List** (under "Resource")
   - Name it: `AmakaFlowWatch.entitlements`
   - ✅ Make sure **AmakaFlowWatch** target is checked
   - Click **Create**

### Step 2: Add HealthKit Entitlement

1. Open `AmakaFlowWatch.entitlements` file in Project Navigator
2. You'll see an empty property list editor

**Option A: Using Xcode's Property List Editor**
- Click the **+** button
- Type: `com.apple.developer.healthkit`
- Press Enter
- The value type will default to Boolean
- The value will default to **YES** (checkmark ✅)

**Option B: Right-click → "Open As" → "Source Code"**
- Switch to XML view
- Add this XML:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.developer.healthkit</key>
	<true/>
</dict>
</plist>
```

### Step 3: Link Entitlements File to Target

1. Select **AmakaFlowWatch** target
2. Go to **Build Settings** tab
3. Search for: `Code Signing Entitlements`
4. Set the value to: `AmakaFlowWatch/AmakaFlowWatch.entitlements`
   - (Or the correct path to your entitlements file)

### Step 4: Add HealthKit Usage Descriptions to Info.plist

1. Select **AmakaFlowWatch** target
2. Go to **Info** tab
3. Click **+** to add new keys
4. Add these two keys:

**Key 1:**
- Key: `NSHealthShareUsageDescription`
- Type: String
- Value: `AmakaFlow Companion needs access to track your workouts`

**Key 2:**
- Key: `NSHealthUpdateUsageDescription`
- Type: String
- Value: `AmakaFlow Companion saves your workout data to Health`

### Step 5: Verify Setup

1. **Entitlements**: Open `AmakaFlowWatch.entitlements` → Should show `com.apple.developer.healthkit = YES`
2. **Build Settings**: Code Signing Entitlements should point to your entitlements file
3. **Info.plist**: Should have both `NSHealthShareUsageDescription` and `NSHealthUpdateUsageDescription`

## Visual Guide

### What You'll See:
```
Project Navigator:
├── AmakaFlowWatch Watch App
│   ├── AmakaFlowWatch.entitlements ← HealthKit entitlement here
│   └── Info.plist ← Usage descriptions here
```

### Entitlements File Structure:
```
com.apple.developer.healthkit = YES ✅
```

### Info.plist Structure:
```
NSHealthShareUsageDescription = "AmakaFlow Companion needs access..."
NSHealthUpdateUsageDescription = "AmakaFlow Companion saves your..."
```

## Important Notes

- ✅ **The "Capabilities" panel will ALWAYS show "No matches" for watchOS** - this is normal, ignore it
- ✅ **You MUST use the entitlements file** - the UI panel won't work
- ✅ **Both entitlement and Info.plist are required** - one without the other won't work
- ✅ **Usage descriptions are mandatory** - the app will crash if missing

## Alternative: If Entitlements File Already Exists

If your project already has an entitlements file:
1. Open it
2. Add the `com.apple.developer.healthkit` key with value `true`
3. Make sure the Build Settings point to this file
4. Add usage descriptions to Info.plist

## Troubleshooting

**"HealthKit is not available" error:**
- Check that entitlements file is linked in Build Settings
- Verify `com.apple.developer.healthkit` is set to `true`
- Make sure you're testing on a physical Apple Watch (HealthKit doesn't work in simulator)

**"Missing usage description" crash:**
- Add both `NSHealthShareUsageDescription` and `NSHealthUpdateUsageDescription` to Info.plist
- Rebuild the app

**Entitlements file not found:**
- Check the path in Build Settings → Code Signing Entitlements
- Make sure the file is added to the AmakaFlowWatch target


