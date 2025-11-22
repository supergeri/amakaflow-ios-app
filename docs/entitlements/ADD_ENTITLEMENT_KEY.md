# Adding HealthKit Key to Entitlements File

## Problem
You don't see a "+" button in the entitlements file editor.

## Solution: Use Right-Click Menu

### Step 1: Fix Target Membership (IMPORTANT!)

**In File Inspector (Right Sidebar):**
1. With `AmakFlowWatch.entitlements` selected, look at the **File Inspector** (right sidebar)
2. Scroll down to find **"Target Membership"** section
3. You'll see: **"No Targets"** or checkboxes
4. ✅ **Check the box next to "AmakaFlowWatch"**
   - This adds the file to the target so it gets included in builds
5. **IMPORTANT**: Without this, the entitlements file won't work!

### Step 2: Add HealthKit Key

You can add the key in several ways:

#### Method A: Right-Click Menu (Easiest)

1. **Right-click** in the empty area of the property list editor (in the "Key" column or the table)
2. Select **"Add Row"** from the context menu
3. Type: `com.apple.developer.healthkit`
4. Press **Enter**
5. The value type should automatically be **Boolean**
6. The value should automatically be **YES** (checkmark ✅)

#### Method B: Edit as Source Code (Alternative)

1. Right-click on `AmakFlowWatch.entitlements` in Project Navigator
2. Select **"Open As"** → **"Source Code"**
3. Replace the contents with:
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
4. Save the file (Cmd + S)

#### Method C: Use Editor Menu

1. In the property list editor, click the **"Editor"** menu at the top of Xcode
2. Select **"Add Item"** (or similar option)
3. Type the key name

## Visual Guide

### Before:
```
Key  | Type    | Value
-----|---------|-------
     |(0 items)|
```

### After Right-Click → Add Row:
```
Key                              | Type    | Value
---------------------------------|---------|------
com.apple.developer.healthkit    | Boolean | YES ✅
```

## Step 3: Verify Target Membership

**In File Inspector (Right Sidebar):**
- Under "Target Membership", you should see:
  - ✅ **AmakaFlowWatch** (checked)

If it still shows "No Targets", click the checkbox next to "AmakaFlowWatch".

## Step 4: Link in Build Settings (After adding the key)

1. Select **AmakaFlowWatch** target
2. Go to **Build Settings** tab
3. Find **"Code Signing Entitlements"** (under "Signing" section)
4. Double-click the empty value field
5. Type: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
   - (Use the exact folder name where your file is located)
6. Press **Enter**

## Troubleshooting

### "+" button still not visible:
- **Right-click** in the property list editor area instead
- Or use "Edit as Source Code" method (Method B above)

### "Add Row" option not available:
- Make sure you're right-clicking **in the table area** (not on a column header)
- Try right-clicking in the empty space under the "Key" column

### File name typo:
- I notice your file is named `AmakFlowWatch.entitlements` (missing an 'a')
- It should be `AmakaFlowWatch.entitlements` for consistency
- You can rename it in Project Navigator if you want, but the current name will work too
- Just use the exact path when linking in Build Settings

## Checklist

- [ ] ✅ "AmakaFlowWatch" is checked in Target Membership
- [ ] ✅ `com.apple.developer.healthkit` key is added
- [ ] ✅ Value is set to YES (Boolean)
- [ ] ✅ Entitlements file path is set in Build Settings

## Next Steps

After the entitlement is added:
1. Link it in Build Settings (see Step 4 above)
2. Add HealthKit usage descriptions to Info.plist (see XCODE_SETUP_GUIDE.md Step 5)


