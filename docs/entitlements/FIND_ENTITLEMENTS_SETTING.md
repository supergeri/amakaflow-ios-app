# Finding "Code Signing Entitlements" in Xcode Build Settings

## Problem
You don't see "Code Signing Entitlements" in Build Settings for the watchOS target.

## Solution: Create Entitlements File First

Xcode often automatically links entitlements files when they exist. Let's create the file first, then verify the setting.

### Step 1: Create the Entitlements File

1. **In Project Navigator** (left sidebar):
   - Right-click on **AmakaFlowWatch Watch App** folder
   - Select **New File...**

2. **Choose Template**:
   - Select **Property List** (under "Resource" section)
   - Click **Next**

3. **Name the File**:
   - Name: `AmakaFlowWatch.entitlements`
   - ✅ **IMPORTANT**: Make sure **"AmakaFlowWatch"** target is checked
   - Uncheck **AmakaFlowCompanion** if it's checked
   - Location: Should be inside **AmakaFlowWatch Watch App** folder
   - Click **Create**

### Step 2: Add HealthKit Entitlement

1. **Open** `AmakaFlowWatch.entitlements` (click on it in Project Navigator)

2. **Add HealthKit Key**:
   - Click the **+** button at the top left of the property list editor
   - Type: `com.apple.developer.healthkit`
   - Press Enter
   - The value type should automatically be **Boolean**
   - The value should automatically be **YES** (checkmark ✅)

   **OR** Right-click → **Open As** → **Source Code** and add:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>com.apple.developer.healthkit</key>
       <true/>
   </dict>
   </plist>
   ```

### Step 3: Verify in Build Settings (Alternative Methods)

#### Method A: Show All Settings

1. Select **AmakaFlowWatch** target
2. Go to **Build Settings** tab
3. **Top of Build Settings pane**, look for a dropdown that says:
   - "**Basic**" or "**All**" or "**Customized**"
4. Click the dropdown and select **"All"**
5. Now search for: `entitlements` (or `code signing entitlements`)
6. You should see **"Code Signing Entitlements"** in the results

#### Method B: Search in Build Settings

1. Select **AmakaFlowWatch** target
2. Go to **Build Settings** tab
3. In the **search box** at the top right of Build Settings, type: `entitlements`
4. The "Code Signing Entitlements" setting should appear

#### Method C: Check Signing & Capabilities Tab

Sometimes Xcode automatically sets it in the Signing section:

1. Select **AmakaFlowWatch** target
2. Go to **Signing & Capabilities** tab
3. Look in the **"Signing"** section (expanded)
4. Scroll down - sometimes "Entitlements File" appears here
5. Or look for any reference to your entitlements file

#### Method D: Xcode Auto-Detection

If the entitlements file is:
- ✅ Named correctly (`AmakaFlowWatch.entitlements`)
- ✅ Added to the **AmakaFlowWatch** target
- ✅ Located in the **AmakaFlowWatch Watch App** folder

Then Xcode **may automatically detect and use it** without showing an explicit setting. This is fine - the entitlements will still work!

### Step 4: Manually Set Code Signing Entitlements (If Needed)

If you still can't find the setting, you can set it manually:

1. Select **AmakaFlowWatch** target
2. Go to **Build Settings** tab
3. Click **"All"** view (not "Basic")
4. In the search box, type: `code signing entitlements`
5. Find **"Code Signing Entitlements"** row
6. Double-click in the value column (right side)
7. Enter: `AmakaFlowWatch/AmakaFlowWatch.entitlements`
   - (Or the path relative to your project root)

### Step 5: Verify It's Working

The easiest way to verify HealthKit is configured:

1. **Build the project**: Cmd + B
2. **Check for errors**: If you see HealthKit-related errors, the entitlement might be missing
3. **Check entitlements file**: Open `AmakaFlowWatch.entitlements` and verify `com.apple.developer.healthkit` is set to `true`

## Visual Guide

### What You Should See:

**After creating entitlements file:**
```
Project Navigator:
├── AmakaFlowWatch Watch App
│   ├── AmakaFlowWatch.entitlements ← Should appear here
│   ├── AmakaFlowWatchApp.swift
│   └── ...
```

**In Build Settings (All view):**
```
Code Signing Entitlements
  = AmakaFlowWatch/AmakaFlowWatch.entitlements
```

**In entitlements file:**
```
com.apple.developer.healthkit = YES ✅
```

## Common Issues

### "Code Signing Entitlements" doesn't appear:
- ✅ **This is OK!** Xcode may auto-detect the entitlements file
- Make sure the file is added to the **AmakaFlowWatch** target
- Build the project - if there are no errors, it's working

### Entitlements file not found:
- Check that the file is in the **AmakaFlowWatch Watch App** folder
- Verify the file is added to the **AmakaFlowWatch** target (check Target Membership in File Inspector)

### Build errors:
- Make sure `com.apple.developer.healthkit` is set to `true` (YES)
- Verify the entitlements file is added to the correct target
- Clean build folder: Product → Clean Build Folder (Shift + Cmd + K)

## Next Steps

After the entitlements file is created:
1. ✅ Add HealthKit usage descriptions to Info.plist (see XCODE_SETUP_GUIDE.md Step 5)
2. ✅ Build and test the app
3. ✅ Verify HealthKit works on a physical Apple Watch (simulator doesn't fully support HealthKit)


