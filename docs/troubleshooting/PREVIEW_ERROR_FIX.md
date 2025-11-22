# Fix: "Cannot preview in this file" - Active scheme does not build this file

## What This Error Means

The error "Active scheme does not build this file" means:
- The Swift file you're trying to preview isn't included in the active target
- The file needs to be added to the **AmakaFlowCompanion** target in Xcode
- The preview canvas can't compile because the file isn't part of the build

## Solution

### Step 1: Add Files to Target

The Swift files from `AmakaFlow/` folder need to be added to the Xcode project and included in the target:

1. **In Xcode Project Navigator**, find the Swift file that's showing the error (e.g., `WorkoutDetailView.swift`)
2. **Select the file** in Project Navigator
3. **Open the File Inspector** (right sidebar, or press **Option+Cmd+1**)
4. **Under "Target Membership"**, check ✅ **AmakaFlowCompanion**
5. Repeat for all Swift files that need previews

### Step 2: Add All Files at Once (Easier)

Instead of doing this file-by-file, add all files to the target:

1. **Select the `AmakaFlow` folder** in Project Navigator (or individual files)
2. **Right-click** → **Get Info** (or press **Cmd+I**)
3. **Under "Target Membership"**, check ✅ **AmakaFlowCompanion** for:
   - All `.swift` files in `AmakaFlow/` folder
   - Models, Views, ViewModels, Services, Theme files

### Step 3: Verify Target Membership

To check if a file is in the target:
1. Select the file
2. Open **File Inspector** (right sidebar)
3. Under **Target Membership**, you should see:
   - ✅ **AmakaFlowCompanion** checked
   - ❌ Not checked = file won't build/preview

### Step 4: Check Active Scheme

1. **At the top of Xcode**, next to the device selector
2. Make sure **AmakaFlowCompanion** scheme is selected (not Tests or Watch)
3. Scheme should show: **AmakaFlowCompanion** → **iPhone Simulator**

### Step 5: Build Once

1. **Product → Build** (or **Cmd+B**)
2. Fix any build errors that appear
3. Once build succeeds, try preview again

## Quick Fix Checklist

- [ ] Files are added to Xcode project (in Project Navigator)
- [ ] Files have **Target Membership** set to **AmakaFlowCompanion**
- [ ] **Active scheme** is set to **AmakaFlowCompanion** (not Tests)
- [ ] Project **builds successfully** (Cmd+B)
- [ ] No **import errors** or missing dependencies

## Common Causes

1. **Files not added to project**: Files exist in folder but not in Xcode
2. **Target membership not set**: Files aren't included in the build
3. **Wrong scheme selected**: Preview is trying to use Test scheme
4. **Build errors**: Files have compilation errors preventing preview
5. **Missing dependencies**: Imports (like WorkoutKitSync) aren't resolved

## If Preview Still Doesn't Work

1. **Clean Build Folder**: Product → Clean Build Folder (Cmd+Shift+K)
2. **Restart Xcode**: Quit completely and reopen
3. **Check for build errors**: Product → Build (Cmd+B) and fix any errors
4. **Verify imports**: Make sure all `import` statements are valid
5. **Check deployment target**: Should be iOS 17.0 (we fixed this earlier)

