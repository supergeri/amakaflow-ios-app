# Add HealthKit Usage Descriptions - Alternative Method

## Problem
No "Info" tab visible next to Build Settings.

## Solution: Add Keys to Info.plist File Directly

In some Xcode projects, especially SwiftUI projects, the Info.plist might be in a file rather than in the target's Info tab.

### Step 1: Find or Create Info.plist for watchOS

1. **In Project Navigator** (left sidebar):
   - Look for an `Info.plist` file in the **"AmakaFlowWatch Watch App"** folder
   - If you see one, great! Click on it
   - If you don't see one, we need to create it

2. **If Info.plist doesn't exist**, create it:
   - Right-click on **"AmakaFlowWatch Watch App"** folder
   - Select **"New File..."**
   - Choose **"Property List"** (under Resource)
   - Name it: `Info.plist`
   - ✅ Make sure **"AmakaFlowWatch"** target is checked
   - Click **Create**

### Step 2: Add HealthKit Usage Description Keys

1. **Open** `Info.plist` (click on it in Project Navigator)

2. **Add the keys** - you can do this in two ways:

#### Method A: Property List Editor (Visual)

1. If the file opens in Property List editor:
   - Click the **+** button or right-click → **"Add Row"**
   - Type: `NSHealthShareUsageDescription`
   - Press Enter
   - Set Type to **String** (should be default)
   - Type the value: `AmakaFlow Companion needs access to track your workouts`
   
2. **Add second key**:
   - Click **+** again or right-click → **"Add Row"**
   - Type: `NSHealthUpdateUsageDescription`
   - Press Enter
   - Set Type to **String**
   - Type the value: `AmakaFlow Companion saves your workout data to Health`

#### Method B: Source Code Editor (Easier)

1. **Right-click** on `Info.plist` in Project Navigator
2. Select **"Open As"** → **"Source Code"**
3. You'll see XML code
4. **Add these keys** inside the `<dict>` tags:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSHealthShareUsageDescription</key>
	<string>AmakaFlow Companion needs access to track your workouts</string>
	<key>NSHealthUpdateUsageDescription</key>
	<string>AmakaFlow Companion saves your workout data to Health</string>
</dict>
</plist>
```

5. **Save** the file (Cmd + S)

### Step 3: Verify Info.plist is in Build Settings

1. Select **AmakaFlowWatch** target
2. Go to **Build Settings** tab
3. Make sure **"All"** is selected (not "Basic")
4. Search for: `info.plist`
5. Find **"Info.plist File"** setting
6. **Double-click** the value field
7. Type: `AmakaFlowWatch Watch App/Info.plist`
   - (Or the correct path to your Info.plist file)
8. Press **Enter**

### Step 4: Check Alternative Location - Target's Info Dictionary

Sometimes in Xcode 15+, the Info dictionary is directly in target settings:

1. Select **AmakaFlowWatch** target
2. Look at the tabs: **General**, **Signing & Capabilities**, **Build Settings**, **Build Phases**
3. **If you see an "Info" tab** - click it and add keys there
4. **If not** - the Info.plist file method above will work

### Alternative: Check if Keys Already Exist

The Info.plist might already exist with some keys. Check:

1. In Project Navigator, search for `Info.plist`
2. Open any Info.plist files you find
3. Look for existing HealthKit keys
4. Add the missing ones

## What Your Info.plist Should Look Like

### In Property List View:
```
Key                                    | Type  | Value
---------------------------------------|-------|----------------------------------------
NSHealthShareUsageDescription          | String| AmakaFlow Companion needs access...
NSHealthUpdateUsageDescription         | String| AmakaFlow Companion saves your...
```

### In Source Code View:
```xml
<key>NSHealthShareUsageDescription</key>
<string>AmakaFlow Companion needs access to track your workouts</string>
<key>NSHealthUpdateUsageDescription</key>
<string>AmakaFlow Companion saves your workout data to Health</string>
```

## Troubleshooting

### "Info.plist File" setting not found in Build Settings:
- The Info.plist might be auto-detected
- Try building the project - if there are no errors, it's working
- The path might be in a different build setting

### File exists but can't find it:
- Use the search box in Project Navigator (bottom left)
- Type: `Info.plist`
- It should show all Info.plist files in the project

### Keys added but not working:
- Make sure Info.plist is added to the **AmakaFlowWatch** target
- Check Target Membership in File Inspector
- Verify the file path in Build Settings → Info.plist File

## Next Steps

After adding the usage descriptions:
1. ✅ Build the project (Cmd + B) to verify no errors
2. ✅ Move on to iOS target Info.plist (similar process)
3. ✅ Continue with remaining setup steps from XCODE_SETUP_GUIDE.md


