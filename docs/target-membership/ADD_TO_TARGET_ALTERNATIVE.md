# Alternative: Add Entitlements File to Target

## Problem
Xcode only shows "Move to Trash" option (no "Remove Reference"), or Target Membership checkbox isn't working.

## Solution: Use Build Phases Method

### Step 1: Cancel the Delete Dialog
- Click **"Cancel"** on the dialog box
- Don't delete the file!

### Step 2: Add File to Target via Build Phases

1. **Select** the **AmakaFlowWatch** target:
   - Click the blue project icon at top of Project Navigator
   - Find **TARGETS** section
   - Click **"AmakaFlowWatch"**

2. **Go to Build Phases tab**:
   - Click the **"Build Phases"** tab (next to Build Settings)

3. **Find "Copy Bundle Resources"**:
   - Look for a section called **"Copy Bundle Resources"**
   - Click the arrow to expand it (if collapsed)

4. **Add the entitlements file**:
   - Click the **+** button at the bottom of the "Copy Bundle Resources" section
   - In the file browser that appears, find and select:
     - `AmakFlowWatch.entitlements`
     - (Should be in "AmakaFlowWatch Watch App" folder)
   - Click **"Add"**

5. **Verify**:
   - You should now see `AmakFlowWatch.entitlements` in the "Copy Bundle Resources" list
   - This ensures the file is included in the build

### Step 3: Set Path in Build Settings (Still Required)

1. **Select** **AmakaFlowWatch** target
2. **Go to Build Settings** tab
3. **Make sure "All" is selected** (not "Basic")
4. **Search for**: `code signing entitlements`
5. **Find** "Code Signing Entitlements"
6. **Double-click** the empty value field
7. **Type**: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
   - (Use the exact folder name where your file is)
8. **Press Enter**

### Step 4: Verify Setup

✅ **Checklist:**
- [ ] File is in Build Phases → Copy Bundle Resources
- [ ] Build Settings → Code Signing Entitlements has the path set
- [ ] Entitlements file contains `com.apple.developer.healthkit = true`

### Step 5: Test Build

1. Press **Cmd + B** to build the project
2. **If there are no errors**, it's working!
3. **If you see errors**, check the path in Build Settings matches the actual file location

## Alternative Method 2: Drag and Drop (If Build Phases Doesn't Work)

1. **In Project Navigator**, select `AmakFlowWatch.entitlements`
2. **Drag** it onto the **"AmakaFlowWatch"** target in the TARGETS list
3. Xcode should ask if you want to add it to the target
4. Click **"Finish"** or **"Add"**

## Alternative Method 3: Check File Inspector Again

Sometimes the checkbox appears after the file is in Build Phases:

1. **Select** `AmakFlowWatch.entitlements` in Project Navigator
2. **Look at File Inspector** (right sidebar)
3. **Scroll down** to "Target Membership"
4. **Try clicking** in different areas - sometimes a checkbox appears after Build Phases is updated

## Why This Works

- **Build Phases → Copy Bundle Resources**: Ensures the file is included in the build
- **Build Settings → Code Signing Entitlements**: Tells Xcode where to find the entitlements for signing
- **Both are needed** for the entitlements to work properly

## Important Notes

✅ **Don't delete the file** - just add it to Build Phases
✅ **The path in Build Settings must match** the actual file location
✅ **Even if Target Membership shows "No Targets"**, if it's in Build Phases and Build Settings is set, it should work

## Troubleshooting

### "Copy Bundle Resources" section not visible:
- Make sure you're on the **Build Phases** tab
- Expand all sections by clicking the arrows

### File not found in Build Phases browser:
- The file might be outside the project folder
- Try navigating to: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlowCompanion/AmakaFlowWatch Watch App/`

### Build errors after setting up:
- Check the path in Build Settings matches exactly (including folder name)
- Try clicking the folder icon next to the path field to browse to the file
- Make sure the file actually exists at that path


