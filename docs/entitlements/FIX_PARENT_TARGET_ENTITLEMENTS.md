# Fix Parent Target Entitlements Error

## Problem

The error says **"AmakaFlowWatch 1 issue"** - this is the **parent target**, not the "AmakaFlowWatch Watch App" target.

The error shows a path with an extra space:
```
'/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlowCompanion/ AmakaFlowWatch Watch App/...'
```

Notice the **space after "AmakaFlowCompanion/"** - this is the issue.

## Solution: Check Parent "AmakaFlowWatch" Target

The **"AmakaFlowWatch Watch App"** target is correct ✅, but the parent **"AmakaFlowWatch"** target might have a wrong path or shouldn't have entitlements at all.

### Step 1: Select Parent Target

1. **Click the blue project icon** at top of Project Navigator
2. In TARGETS, find and click **"AmakaFlowWatch"** (not "AmakaFlowWatch Watch App")
   - This is the parent target (usually used for WatchKit Extension, if it exists)

### Step 2: Check Build Settings

1. **Go to Build Settings tab**
2. **Make sure "All" is selected** (not "Basic")
3. **Search for**: `code signing entitlements`
4. **Find "Code Signing Entitlements"**

### Step 3: Fix or Clear the Path

**Option A: Clear the Path (Recommended)**

The parent "AmakaFlowWatch" target might not need its own entitlements file:

1. **Double-click** the "Code Signing Entitlements" value field
2. **Delete/clear the path** (make it empty)
3. **Press Enter**

**Option B: Set the Correct Path**

If the parent target needs entitlements:

1. **Double-click** the "Code Signing Entitlements" value field
2. **Set it to**: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
3. **Make sure there's NO space** after "AmakaFlowCompanion/" in the path
4. **Press Enter**

### Step 4: Verify "AmakaFlowWatch Watch App" Target

Make sure the app target is still correct:

1. **Select "AmakaFlowWatch Watch App" target**
2. **Build Settings → Code Signing Entitlements**
3. **Should show**: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements` ✅

### Step 5: Clean and Rebuild

1. **Clean Build Folder**: Product → Clean Build Folder (Shift + Cmd + K)
2. **Build**: Press Cmd + B
3. **Error should be resolved!**

## Summary

- ✅ **"AmakaFlowWatch Watch App" target**: Path is correct
- ❌ **"AmakaFlowWatch" parent target**: Has wrong path or shouldn't have one
- ✅ **Fix**: Clear the entitlements path for the parent target (or fix the path)

The parent target probably doesn't need its own entitlements - only the app target needs it.


