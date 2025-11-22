# Fix Code Signing Entitlements Path

## Problem

In Build Settings, "Code Signing Entitlements" shows:
- ❌ Current: `AmakaFlowWatch Watch App` (just the folder name)
- ✅ Should be: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements` (path to the file)

The error says the file cannot be found because the path is incomplete.

## Solution: Update the Path

### Step 1: Fix the Path Value

1. **You're already on the correct target** ✅ ("AmakaFlowWatch Watch App")
2. **You're already on Build Settings tab** ✅
3. **You've already searched for "code signing"** ✅

### Step 2: Update "Code Signing Entitlements"

1. **Find "Code Signing Entitlements"** in the list (should be visible now)
2. **Double-click** the value field that shows `AmakaFlowWatch Watch App`
3. **Replace it with**: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
4. **Press Enter**

### Step 3: Use File Browser (Alternative)

If typing doesn't work:

1. **Click the folder icon** (📁) next to the "Code Signing Entitlements" field
2. **Navigate to**: `AmakaFlowWatch Watch App` folder
3. **Select**: `AmakFlowWatch.entitlements` file
4. **Click "Open"**

### Step 4: Verify

After updating, the field should show:
- ✅ `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`

**NOT**:
- ❌ `AmakaFlowWatch Watch App` (just folder name)

### Step 5: Clean and Rebuild

1. **Clean Build Folder**: Product → Clean Build Folder (Shift + Cmd + K)
2. **Build**: Press Cmd + B
3. **Error should be resolved!**

## Visual Guide

### Before (Wrong):
```
Code Signing Entitlements
  = AmakaFlowWatch Watch App  ❌ (just folder name)
```

### After (Correct):
```
Code Signing Entitlements
  = AmakaFlowWatch Watch App/AmakFlowWatch.entitlements  ✅ (full path to file)
```

## Summary

- ❌ **Problem**: Path only shows folder name, not the file path
- ✅ **Fix**: Update to `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
- 📍 **Location**: AmakaFlowWatch Watch App target → Build Settings → Code Signing Entitlements


