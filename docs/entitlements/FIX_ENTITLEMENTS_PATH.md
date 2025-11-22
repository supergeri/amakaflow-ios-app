# Fix Entitlements File Path Error

## Problem
```
Build input file cannot be found: '/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlowCompanion/ AmakaFlowWatch Watch App/AmakFlowWatch.entitlements'
```

**Notice the extra space** after `AmakaFlowCompanion/` in the path - this is causing the file not to be found.

## Solution: Fix the Path in Build Settings

### Step 1: Check the Actual File Location

1. **In Project Navigator**, find the entitlements file:
   - Look for `AmakFlowWatch.entitlements` 
   - It should be in the **"AmakaFlowWatch Watch App"** folder

2. **Verify the file exists**:
   - The file should be at: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlowCompanion/AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
   - (No space after "AmakaFlowCompanion/")

### Step 2: Fix the Path in Build Settings

1. **Select "AmakaFlowWatch" target** (not "AmakaFlowWatch Watch App"):
   - Click the blue project icon at top of Project Navigator
   - In TARGETS, click **"AmakaFlowWatch"** (not the "Watch App" one)

2. **Go to Build Settings tab**

3. **Make sure "All" is selected** (not "Basic")

4. **Search for**: `code signing entitlements`

5. **Find "Code Signing Entitlements"** setting

6. **Check the current path**:
   - If it shows a path with a space (e.g., `AmakaFlowCompanion/ AmakaFlowWatch Watch App/...`)
   - Or if it's incorrect

7. **Fix the path**:
   - **Double-click** the value field
   - **Type the correct path**: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
   - **NO space** after "AmakaFlowCompanion/" (if path includes it)
   - Press **Enter**

### Step 3: Alternative - Use File Browser

If typing the path doesn't work:

1. **Click the folder icon** next to the "Code Signing Entitlements" field
2. **Navigate to**: `AmakaFlowWatch Watch App` folder
3. **Select**: `AmakFlowWatch.entitlements`
4. **Click "Open"**

### Step 4: Clean and Rebuild

1. **Clean Build Folder**: Product → Clean Build Folder (Shift + Cmd + K)
2. **Build**: Press Cmd + B
3. **Error should be resolved!**

## Alternative: Check File Reference

If the path keeps having issues, check the file reference:

1. **In Project Navigator**, select `AmakFlowWatch.entitlements`
2. **File Inspector** (right sidebar) → **"Location"** field
3. **Should show**: `Relative to Group` or `Relative to Project`
4. **Full Path** should show the correct path without extra spaces

## Troubleshooting

### "Code Signing Entitlements" setting is missing:
- Make sure you're on **"AmakaFlowWatch"** target (not "AmakaFlowWatch Watch App")
- Make sure **"All"** is selected in Build Settings (not "Basic")

### Path still wrong:
- Try removing the entitlements file from Build Settings
- Then add it back using the folder browser

### File doesn't exist:
- Check if `AmakFlowWatch.entitlements` actually exists in the folder
- If missing, you may need to recreate it or re-add it to the project

## Summary

- ❌ **Problem**: Path has extra space: `AmakaFlowCompanion/ AmakaFlowWatch...`
- ✅ **Fix**: Update "Code Signing Entitlements" path to: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
- 📍 **Location**: AmakaFlowWatch target → Build Settings → Code Signing Entitlements


