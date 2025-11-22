# Fix watchOS Minimum Deployment Target

## Problem
When selecting minimum deployments for AmakaFlowWatch, you're seeing **iOS versions** (iOS 26, 18, 17, etc.) instead of **watchOS versions** (watchOS 10.0, 11.0, etc.).

## Why This Is Happening

This could happen if:
1. You're looking at the **iOS target** instead of the watchOS target
2. The watchOS target's SDK is set incorrectly
3. There's a configuration issue with the target

## Solution: Verify and Fix

### Step 1: Verify You're on the Correct Target

1. **Look at the target name** at the top of the General tab
2. Make sure it says **"AmakaFlowWatch Watch App"** (not "AmakaFlowCompanion")
3. **Check the "Supported Destinations"** section:
   - Should show: **"Apple Watch"** with SDK **"watchOS"**
   - ❌ If it shows "iPhone" with SDK "iOS", you're on the wrong target!

### Step 2: Check "Supported Destinations"

In the **General** tab, look for **"Supported Destinations"** section:

✅ **Correct for watchOS**:
```
Destination | SDK
------------|-----
Apple Watch | watchOS
```

❌ **Wrong (iOS target)**:
```
Destination | SDK
------------|-----
iPhone      | iOS
```

### Step 3: Fix Minimum Deployments

If you're on the **correct target** ("AmakaFlowWatch Watch App") but still seeing iOS versions:

1. **In "Minimum Deployments"** section:
   - Look for a field that says **"watchOS"** (not "iOS")
   - If it says "iOS", there might be a dropdown to change it

2. **If you see "iOS" in Minimum Deployments**:
   - Click the **+** button next to "iOS"
   - Or look for a dropdown/selector to add **"watchOS"**
   - Select **"watchOS"**
   - Set the version to: **"10.0"** (or **"11.0"** for WorkoutKit support)

3. **If you only see "iOS" with no way to change it**:
   - You might be on the wrong target
   - Go back to TARGETS section and select **"AmakaFlowWatch Watch App"** (not "AmakaFlowWatch" or "AmakaFlowCompanion")

### Step 4: Set Correct watchOS Version

Once you see **watchOS versions** in the dropdown:

**Option A: Minimum Support (watchOS 10.0)**
- Select **"watchOS 10.0"** (supports more devices)
- ✅ Works for most watchOS features
- ❌ Doesn't support WorkoutKit (requires watchOS 11.0+)

**Option B: WorkoutKit Support (watchOS 11.0)**
- Select **"watchOS 11.0"** (for WorkoutKit support)
- ✅ Supports WorkoutKit framework
- ❌ Only works on Apple Watch Series 6 and later with watchOS 11.0+

**Recommended**: Use **watchOS 11.0** if you need WorkoutKit, otherwise **watchOS 10.0** for broader device support.

## Visual Guide

### What You Should See for watchOS Target:

```
Minimum Deployments:
┌──────────┬─────────┐
│ watchOS  │ 11.0    │ ← Should show watchOS, not iOS
└──────────┴─────────┘
```

### What You're Currently Seeing (Wrong):

```
Minimum Deployments:
┌──────────┬─────────┐
│ iOS      │ 17.0    │ ← This is wrong for watchOS!
└──────────┴─────────┘
```

## Troubleshooting

### Still seeing iOS versions:
- ✅ **Make absolutely sure** you're on **"AmakaFlowWatch Watch App"** target
- ✅ Check **"Supported Destinations"** shows "Apple Watch" with "watchOS" SDK
- ✅ If still wrong, try selecting a different target and then back to "AmakaFlowWatch Watch App"

### Can't find watchOS option:
- The target might not be configured as watchOS
- Try going to **Build Settings** tab
- Search for: `iOS Deployment Target` or `watchOS Deployment Target`
- Look for a setting that shows the correct SDK

### Target says "iOS" in Build Settings:
- Go to **Build Settings** tab
- Search for: `Supported Platforms`
- Should show: `watchOS` (not `iOS`)
- If it shows `iOS`, the target might be misconfigured

## Quick Checklist

- [ ] Target name is **"AmakaFlowWatch Watch App"**
- [ ] "Supported Destinations" shows **"Apple Watch"** with **"watchOS"** SDK
- [ ] "Minimum Deployments" shows **"watchOS"** (not "iOS")
- [ ] Deployment target is set to **"10.0"** or **"11.0"** (not iOS version)

## Next Steps

After fixing the deployment target:
1. ✅ Continue with Step 7: Add frameworks to the watchOS target
2. ✅ Build the project to verify everything works
3. ✅ Move to Step 8: Configure minimum deployment targets for both targets


