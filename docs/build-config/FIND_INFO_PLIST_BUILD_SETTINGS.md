# How to Find "Info.plist File" in Build Settings

## Step-by-Step Instructions

### Step 1: Open Build Settings

1. **Click the blue project icon** at the top of the Project Navigator (left sidebar)
2. In the main editor area, you'll see **PROJECT** and **TARGETS** sections
3. **Click "AmakaFlowWatch Watch App"** under TARGETS (not the parent "AmakaFlowWatch")
4. **Click the "Build Settings" tab** at the top

### Step 2: Switch to "All" View

**Important**: The "Info.plist File" setting might not show in "Basic" view!

1. At the top of the Build Settings panel, you'll see filter buttons:
   - **Basic** ← Don't use this
   - **Customized**
   - **All** ← **Click this one!** ✅
2. **Click "All"** to see all build settings

### Step 3: Search for "Info.plist"

1. **Look at the top-right corner** of the Build Settings panel
2. You'll see a **search bar** (it might say "Filter" or show a magnifying glass icon)
3. **Click in the search bar** and type: `info.plist`
   - You can also search for just: `plist`
4. The list will filter to show settings containing "plist"

### Step 4: Find "Info.plist File"

Look for a setting called:
- **"Info.plist File"** (under the "Packaging" section)

It should show:
- **Setting Name**: `INFOPLIST_FILE`
- **Value**: `AmakaFlowWatch Watch App/Info.plist` ✅

### Visual Guide:

```
Build Settings Tab
├─ [Basic] [Customized] [All] ← Click "All"
├─ Search bar: "info.plist" ← Type here
└─ Results:
   └─ Packaging section
      └─ Info.plist File (INFOPLIST_FILE)
         └─ Value: "AmakaFlowWatch Watch App/Info.plist"
```

### Alternative: Use the "Packaging" Section

If searching doesn't work:

1. **Make sure "All" view is selected**
2. **Scroll down** through the build settings (they're organized alphabetically or by category)
3. Look for the **"Packaging"** section (or search for "packaging")
4. In the Packaging section, find **"Info.plist File"**

### If You Still Can't Find It

1. **Make sure you selected "AmakaFlowWatch Watch App" target** (not "AmakaFlowWatch")
2. **Make sure "All" is selected** (not "Basic")
3. **Try searching for**: `INFOPLIST_FILE` (the internal setting name)
4. **Try searching for**: `packaging` to find the Packaging section

### What It Should Look Like:

Once you find it, it should be:

```
Info.plist File (INFOPLIST_FILE)
  Debug: AmakaFlowWatch Watch App/Info.plist
  Release: AmakaFlowWatch Watch App/Info.plist
```

If it's empty or shows a different path, **double-click** the value field and set it to:
```
AmakaFlowWatch Watch App/Info.plist
```

Then press **Enter**.


