# Fix Duplicate Info.plist Build Error

## Problem
You're seeing build errors:
- ❌ "Multiple commands produce 'Info.plist'" for AmakaFlowWatch Watch App
- ❌ "duplicate output file 'Info.plist'" for the same target

## Why This Happens
This occurs when Xcode tries to process the same Info.plist file multiple times. Common causes:
1. **Info.plist file exists AND is configured in target settings** (double configuration)
2. **Info.plist is in "Copy Bundle Resources" build phase** (shouldn't be there)
3. **Multiple Info.plist files are referenced**

## Solution: Choose One Method

You have two options:

### Option A: Use Info.plist File (Recommended)

If you have an `Info.plist` file in your project:

1. **Keep the Info.plist file**
2. **Remove Info.plist from Build Settings**:
   - Select **AmakaFlowWatch Watch App** target
   - Go to **Build Settings** tab
   - Make sure **"All"** is selected (not "Basic")
   - Search for: `info.plist`
   - Find **"Info.plist File"** setting
   - **Clear the value** (double-click and delete the path, leave it empty)
   - Press **Enter**

3. **Remove Info.plist from Copy Bundle Resources**:
   - Select **AmakaFlowWatch Watch App** target
   - Go to **Build Phases** tab
   - Expand **"Copy Bundle Resources"** section
   - Look for `Info.plist` in the list
   - If it's there, select it and click **"-"** to remove it

### Option B: Use Target Settings (Alternative)

If you don't want to use the Info.plist file:

1. **Delete the Info.plist file** (if it exists):
   - In Project Navigator, find `Info.plist` in **"AmakaFlowWatch Watch App"** folder
   - Right-click → **Delete** → Choose **"Move to Trash"** or **"Remove Reference"**

2. **Use the Info tab instead**:
   - Select **AmakaFlowWatch Watch App** target
   - Go to **Info** tab
   - Add all your keys there (usage descriptions, etc.)

## Step-by-Step Fix (Option A - Recommended)

### Step 1: Check Build Settings

1. **Select AmakaFlowWatch Watch App** target
2. **Go to Build Settings** tab
3. **Make sure "All" is selected** (not "Basic")
4. **Search for**: `info.plist`
5. **Find "Info.plist File"** setting
6. **Check the value**:
   - If it shows: `AmakaFlowWatch Watch App/Info.plist` → **Clear it** (delete the value)
   - If it's empty → Good, continue to Step 2

### Step 2: Check Build Phases

1. **Select AmakaFlowWatch Watch App** target
2. **Go to Build Phases** tab
3. **Expand "Copy Bundle Resources"** section
4. **Look for `Info.plist`** in the list
5. **If found**, select it and click **"-"** (minus button) to remove it
6. **If not found**, continue to Step 3

### Step 3: Verify Info.plist File Exists

1. **In Project Navigator**, check if `Info.plist` exists in **"AmakaFlowWatch Watch App"** folder
2. **If it exists** and has your keys (HealthKit usage descriptions, etc.) → ✅ Good, keep it
3. **If it doesn't exist** → You might need to create one or use the Info tab

### Step 4: Clean Build Folder

1. In Xcode menu: **Product → Clean Build Folder** (or **Shift + Cmd + K**)
2. **Build again** (Cmd + B)
3. The error should be gone

## Quick Checklist

- [ ] Info.plist File setting in Build Settings is **empty** (or points to correct file)
- [ ] Info.plist is **NOT** in "Copy Bundle Resources" build phase
- [ ] Info.plist file exists in Project Navigator (if using Option A)
- [ ] Clean build folder after making changes
- [ ] Build again to verify

## Alternative: If Still Not Working

If the error persists:

1. **Check for duplicate Info.plist files**:
   - Search in Project Navigator for "Info.plist"
   - Make sure there's only ONE in the "AmakaFlowWatch Watch App" folder
   - Remove any duplicates

2. **Check target membership**:
   - Select the Info.plist file
   - In File Inspector (right sidebar), check **Target Membership**
   - Should only have **"AmakaFlowWatch Watch App"** checked
   - Uncheck any other targets

3. **Verify file location**:
   - Make sure Info.plist is physically in the **"AmakaFlowWatch Watch App"** folder
   - Not in parent folders or other targets

## Summary

The error happens because Xcode is trying to process Info.plist twice. The fix is to:
- ✅ Use Info.plist file (keep file, clear Build Settings path)
- ✅ Remove Info.plist from Copy Bundle Resources (if present)
- ✅ Clean build folder
- ✅ Rebuild


