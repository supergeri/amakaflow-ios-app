# Fix Entitlements File Path Error

## Problem
```
Build input file cannot be found: '/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlowCompanion/ AmakaFlowWatch Watch App/AmakFlowWatch.entitlements'
```

**Notice**: There's an extra space in the path after `AmakaFlowCompanion/`.

The file **exists** at the correct location:
- ✅ File exists: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlowCompanion/AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
- ❌ Build Settings path has an extra space or wrong target reference

## Solution: Fix the Path in Build Settings

The error is for **"AmakaFlowWatch"** target. This might be a parent target that references the watchOS app's entitlements incorrectly.

### Option 1: Fix AmakaFlowWatch Target (Parent Target)

1. **Select "AmakaFlowWatch" target**:
   - Click the blue project icon at top of Project Navigator
   - In TARGETS, click **"AmakaFlowWatch"** (not "AmakaFlowWatch Watch App")

2. **Go to Build Settings tab**

3. **Make sure "All" is selected** (not "Basic")

4. **Search for**: `code signing entitlements`

5. **Find "Code Signing Entitlements"** setting

6. **Check the path**:
   - If it shows a path with a space or incorrect path
   - **Clear the value** (delete it) - this target might not need its own entitlements file

7. **OR set it correctly**:
   - If it needs to point to the watchOS app's entitlements:
   - **Clear it** - the watchOS app should handle its own entitlements

### Option 2: Remove Entitlements from Wrong Target

The **"AmakaFlowWatch"** target (parent) might not need its own entitlements file. The **"AmakaFlowWatch Watch App"** target should handle entitlements.

1. **Select "AmakaFlowWatch" target**
2. **Build Settings → Code Signing Entitlements**
3. **Clear the value** (delete the path)
4. **Press Enter**

The watchOS app target ("AmakaFlowWatch Watch App") should have its own entitlements configured, not the parent target.

### Option 3: Check Build Settings for Both Targets

1. **AmakaFlowWatch target** (parent):
   - Should **NOT** have "Code Signing Entitlements" set
   - Or should be **empty**

2. **AmakaFlowWatch Watch App target** (actual app):
   - Should have "Code Signing Entitlements" set to: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`

## Step-by-Step Fix

### Step 1: Check "AmakaFlowWatch" Target

1. **Select "AmakaFlowWatch" target**
2. **Build Settings → Code Signing Entitlements**
3. **Clear the path** (make it empty)
4. **Press Enter**

### Step 2: Verify "AmakaFlowWatch Watch App" Target

1. **Select "AmakaFlowWatch Watch App" target**
2. **Build Settings → Code Signing Entitlements**
3. **Should show**: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
4. **If empty or wrong**, set it to: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`

### Step 3: Clean and Rebuild

1. **Clean Build Folder**: Product → Clean Build Folder (Shift + Cmd + K)
2. **Build**: Press Cmd + B
3. **Error should be resolved!**

## Summary

- ❌ **Problem**: "AmakaFlowWatch" target (parent) has wrong entitlements path
- ✅ **Fix**: Clear the "Code Signing Entitlements" path for "AmakaFlowWatch" target
- ✅ **Verify**: "AmakaFlowWatch Watch App" target has correct path
- 📍 **Location**: AmakaFlowWatch target → Build Settings → Code Signing Entitlements


