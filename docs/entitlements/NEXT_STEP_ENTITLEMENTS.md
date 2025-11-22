# Next Step: Set Up Entitlements File

You've found "Code Signing Entitlements" in Build Settings! Now follow these steps:

## Step 1: Create the Entitlements File

### In Project Navigator (Left Sidebar):

1. **Right-click** on the **"AmakaFlowWatch Watch App"** folder
   - (This is the folder that contains `AmakaFlowWatchApp.swift`, `Assets`, `ContentView`, etc.)

2. **Select** "New File..." (or press Cmd + N)

3. **Choose Template**:
   - Scroll down and find **"Property List"** 
   - (It's under the "Resource" section, or search for "Property List")
   - Click **Next**

4. **Name the File**:
   - Name: `AmakaFlowWatch.entitlements`
   - ✅ **IMPORTANT**: Make sure **"AmakaFlowWatch"** target is **checked**
   - Uncheck **"AmakaFlowCompanion"** if it's checked
   - Click **Create**

5. **Verify**:
   - You should now see `AmakaFlowWatch.entitlements` in the **"AmakaFlowWatch Watch App"** folder in Project Navigator

## Step 2: Add HealthKit Entitlement to the File

1. **Click on** `AmakaFlowWatch.entitlements` in Project Navigator to open it

2. **Add the HealthKit key**:
   - Click the **+** button (top left of the property list editor)
   - Type: `com.apple.developer.healthkit`
   - Press **Enter**
   - The value type should automatically be **Boolean**
   - The value should automatically be **YES** (checkmark ✅)

   **Visual:**
   ```
   + (click here)
   ├─ com.apple.developer.healthkit = YES ✅
   ```

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

## Step 3: Link the Entitlements File in Build Settings

1. **Go back to Build Settings** (if you closed it):
   - Select **AmakaFlowWatch** target
   - Click **Build Settings** tab
   - Make sure **"All"** is selected (not "Basic")
   - Find **"Code Signing Entitlements"** in the "Signing" section

2. **Set the path**:
   - **Double-click** on the empty value field next to "Code Signing Entitlements"
   - Type: `AmakaFlowWatch/AmakaFlowWatch.entitlements`
   - Press **Enter**

   **Note**: The path is relative to your target's folder. If you created the file in "AmakaFlowWatch Watch App" folder, the path might need to be adjusted. If the above doesn't work, try:
   - `AmakaFlowWatch Watch App/AmakaFlowWatch.entitlements`
   
   **OR** click the folder icon next to the field and navigate to your entitlements file.

## Step 4: Verify Everything is Set Up

✅ **Checklist:**
- [ ] `AmakaFlowWatch.entitlements` file exists in Project Navigator
- [ ] File contains `com.apple.developer.healthkit = YES`
- [ ] "Code Signing Entitlements" in Build Settings points to the file
- [ ] File is added to **AmakaFlowWatch** target (check Target Membership in File Inspector if unsure)

## Step 5: Next - Add Usage Descriptions to Info.plist

After the entitlements are set up, you need to add HealthKit usage descriptions to Info.plist (see XCODE_SETUP_GUIDE.md Step 5).

## Troubleshooting

### "Code Signing Entitlements" path doesn't work:
- Try clicking the **folder icon** next to the field to browse to the file
- Check the exact folder name - it might be "AmakaFlowWatch Watch App" not just "AmakaFlowWatch"

### File not found error:
- Make sure the file is added to the **AmakaFlowWatch** target:
  - Select `AmakaFlowWatch.entitlements` in Project Navigator
  - Look at the **File Inspector** (right sidebar)
  - Under "Target Membership", make sure **AmakaFlowWatch** is checked

### Can't find "Property List" template:
- In "New File" dialog, scroll down to "Resource" section
- Or use search box in the dialog and type "Property List"

## What You Should See

**Project Navigator:**
```
AmakaFlowWatch Watch App
├── AmakaFlowWatch.entitlements ← Should be here
├── AmakaFlowWatchApp.swift
├── Assets
└── ContentView
```

**Build Settings:**
```
Code Signing Entitlements
  = AmakaFlowWatch/AmakaFlowWatch.entitlements ✅
```

**Entitlements File:**
```
com.apple.developer.healthkit = YES ✅
```


