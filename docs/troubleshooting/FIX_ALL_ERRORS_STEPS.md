# Fix All Build Errors - Complete Steps

## Current Errors

1. ❌ **Deployment Target**: "Compiling for iOS 17.0, but module 'WorkoutKitSync' has a minimum deployment target of iOS 18.0"
2. ❌ **WKPlanDTO Initialization**: "Extra arguments" and "Missing argument" errors

## Solution Summary

I've fixed the WorkoutKitSync package to add public initializers. Now you need to:

1. ✅ **Update iOS Deployment Target to 18.0** (CRITICAL - do this first)
2. ✅ **Rebuild WorkoutKitSync package** (if needed)
3. ✅ **Clean and rebuild project**

## Step 1: Update iOS Deployment Target to 18.0

### In Xcode:

1. **Select AmakaFlowCompanion target**:
   - Click the blue project icon at top of Project Navigator
   - In TARGETS, click **"AmakaFlowCompanion"** (iOS target)

2. **Go to General tab**:
   - Click **"General"** tab

3. **Update Minimum Deployments**:
   - Find **"Minimum Deployments"** section
   - Find **"iOS"** in the list
   - Click the **dropdown** or **double-click the version number**
   - Change from **"17.0"** to **"18.0"**
   - Press **Enter**

### Verify:
- Should now show: **iOS: 18.0** ✅

## Step 2: Update WorkoutKitSync Package

I've added public initializers to the WorkoutKitSync package. The package needs to be rebuilt:

1. **In Xcode**, the package should automatically rebuild
2. **Or**, if you have the package open in another window, build it there

The changes I made:
- ✅ Added `public init(...)` to `WKPlanDTO`
- ✅ Added `public init(...)` to `Schedule`
- ✅ Added `public init(...)` to `Target`
- ✅ Added `public init(...)` to `Step`
- ✅ Added `public init(...)` to `Load`

## Step 3: Clean and Rebuild

1. **Clean Build Folder**:
   - Product → Clean Build Folder (Shift + Cmd + K)

2. **Build**:
   - Press **Cmd + B**

3. **Check errors**:
   - Deployment target error should be gone ✅
   - WKPlanDTO initialization errors should be gone ✅

## What Was Fixed

### 1. Deployment Target Mismatch
- **Before**: iOS 17.0, but WorkoutKitSync needs 18.0+
- **After**: iOS 18.0 ✅

### 2. Missing Initializers
- **Before**: WKPlanDTO only had `Decodable` initializer
- **After**: Added public memberwise initializers ✅

### 3. WorkoutKitConverter API
- **Already correct**: Uses `WorkoutKitSync.default.save(dto, scheduleAt: nil)` ✅

## Summary

1. ✅ **Update iOS deployment target to 18.0** (do this in Xcode)
2. ✅ **WorkoutKitSync package updated** with public initializers (already done)
3. ✅ **Clean and rebuild** the project
4. ✅ **Errors should be resolved!**

## If Errors Persist

### "WorkoutKitSync module not found" after update:
- Close and reopen Xcode
- Clean build folder again
- Build WorkoutKitSync package first (if it's a separate project)

### "Package dependency outdated":
- In Xcode, go to **Package Dependencies** tab
- Click **"Update to Latest Package Versions"** or refresh

### Still seeing WKPlanDTO errors:
- Make sure the WorkoutKitSync package was rebuilt with the new initializers
- Check that the package path is correct in Xcode


