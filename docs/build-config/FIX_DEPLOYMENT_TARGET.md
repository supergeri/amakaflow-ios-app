# Fix Deployment Target Error

## Problem
```
"Compiling for iOS 17.0, but module 'WorkoutKitSync' has a minimum deployment target of iOS 18.0"
```

**WorkoutKitSync requires iOS 18.0+**, but your iOS target is set to **iOS 17.0**.

## Solution: Update iOS Deployment Target to 18.0

### Step 1: Select iOS Target

1. **Click the blue project icon** at top of Project Navigator
2. In the main editor, find **TARGETS** section
3. **Click "AmakaFlowCompanion"** (iOS target, not watchOS)

### Step 2: Go to General Tab

1. **Click "General" tab** (top of editor area)

### Step 3: Update Minimum Deployment

1. **Find "Minimum Deployments"** section
2. **Find "iOS"** in the list
3. **Click the dropdown** next to iOS
4. **Select "iOS 18.0"** (or the latest available version)

**OR**

If you see a text field:
1. **Double-click the version number** (should show "17.0")
2. **Type**: `18.0`
3. **Press Enter**

### Step 4: Verify

1. **Check the "Minimum Deployments"** section now shows:
   - **iOS**: `18.0` ✅

## Why This Is Required

- **WorkoutKitSync package** requires iOS 18.0+ / watchOS 11.0+
- **Your iOS target** was set to 17.0
- **Mismatch causes** build errors

## After Fixing

1. ✅ **Clean Build Folder**: Product → Clean Build Folder (Shift + Cmd + K)
2. ✅ **Build**: Press Cmd + B
3. ✅ **Deployment target error should be gone**

## Summary

- ❌ **Problem**: iOS deployment target is 17.0, but WorkoutKitSync needs 18.0+
- ✅ **Fix**: Update iOS deployment target to 18.0
- 📍 **Location**: AmakaFlowCompanion target → General tab → Minimum Deployments


