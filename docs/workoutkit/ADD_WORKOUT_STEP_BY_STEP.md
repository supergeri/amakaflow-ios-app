# Step-by-Step: Add Workout.swift to watchOS Target

## Visual Guide

### What You're Looking At
- **Left Sidebar (Project Navigator)**: Shows your files
- **Right Sidebar**: Shows file details (File Inspector) or targets
- **Workout file**: Visible in your project navigator (flame icon 🔥)

## Step 1: Select the Workout File

1. **Look at the left sidebar** (Project Navigator)
2. **Find the file named `Workout`** (it has a flame icon 🔥)
3. **Click once on `Workout`** to select it
   - It should be highlighted/selected after clicking

## Step 2: Open File Inspector

**In the right sidebar**, you should see tabs at the top. Look for:

1. **Click the first tab** (leftmost tab in the right sidebar)
   - It looks like a **document icon** 📄
   - This is the **"File Inspector"** tab

**OR**

1. **After selecting `Workout`**, press **Option + Cmd + 1**
   - This keyboard shortcut opens File Inspector

## Step 3: Find Target Membership

1. **In the File Inspector** (right sidebar), **scroll down**
2. **Look for a section called "Target Membership"**
   - It has a heading "Target Membership"
   - Below it, you'll see checkboxes with target names

## Step 4: Check the watchOS Target

1. **In the "Target Membership" section**, you'll see:
   - ☑️ **AmakaFlowCompanion** (already checked - iOS target)
   - ☐ **AmakaFlowWatch Watch App** (NOT checked - this is what we need!)

2. **Click the empty checkbox** next to **"AmakaFlowWatch Watch App"**
   - It should get a checkmark ✅
   - Now it should look like:
     - ✅ AmakaFlowCompanion
     - ✅ AmakaFlowWatch Watch App

3. **That's it!** The file is now added to the watchOS target

## Visual Representation

### Before (Wrong):
```
Target Membership:
☑️ AmakaFlowCompanion
☐ AmakaFlowWatch Watch App   ← Click this checkbox!
```

### After (Correct):
```
Target Membership:
☑️ AmakaFlowCompanion
☑️ AmakaFlowWatch Watch App   ← Now checked! ✅
```

## Step 5: Verify and Rebuild

1. **Verify**: Make sure both checkboxes are checked ✅
2. **Clean Build**: Product → Clean Build Folder (Shift + Cmd + K)
3. **Build**: Press Cmd + B
4. **Errors should be gone!** ✅

## Troubleshooting

### "I don't see File Inspector tab"
- **Look at the right sidebar** - there are multiple tabs at the top
- The **leftmost tab** is File Inspector (document icon 📄)
- Click it to open

### "I don't see Target Membership section"
- **Scroll down** in the File Inspector
- It's below sections like "Identity and Type", "Text Settings", etc.
- Keep scrolling - it's there!

### "Target Membership is empty or doesn't show watchOS target"
- The file might not be properly added to the project
- Try: Right-click on `Workout` → Select **"Get Info"** or **"Show in Finder"**
- Or try adding it via Build Phases (see Alternative Method below)

### "I see Target Membership but watchOS target isn't in the list"
- The watchOS target might not exist or has a different name
- Check the **TARGETS** section in the right sidebar
- Look for **"AmakaFlowWatch Watch App"** in the targets list
- If it's not there, the target might need to be created first

## Alternative Method: Build Phases

If Target Membership doesn't work:

1. **Select "AmakaFlowWatch Watch App" target** (in TARGETS section, right sidebar)
2. **Click "Build Phases" tab** (top of center area)
3. **Expand "Compile Sources"** (click the arrow)
4. **Click "+" button** (bottom of Compile Sources list)
5. **Find and select `Workout.swift`** in the file browser
6. **Click "Add"**
7. **Clean and rebuild**

## Quick Checklist

- [ ] Selected `Workout` file in Project Navigator
- [ ] Opened File Inspector (document icon tab, or Option + Cmd + 1)
- [ ] Scrolled to "Target Membership" section
- [ ] ✅ Checked "AmakaFlowWatch Watch App" checkbox
- [ ] Both targets are now checked:
  - [ ] ✅ AmakaFlowCompanion
  - [ ] ✅ AmakaFlowWatch Watch App
- [ ] Clean build folder
- [ ] Rebuild project
- [ ] Errors are resolved

## What This Does

- ✅ Adds `Workout.swift` to the watchOS target's "Compile Sources"
- ✅ Makes `Workout` type available to `WatchWorkoutManager` and `WorkoutListView`
- ✅ Fixes all "Cannot find type 'Workout' in scope" errors


