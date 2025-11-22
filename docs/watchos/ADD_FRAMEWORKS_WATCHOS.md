# Step 7: Add Frameworks for AmakaFlowWatch Target

## Current Status
You're on the **General** tab for the **AmakaFlowWatch** target and need to add frameworks.

## Step-by-Step Instructions

### Step 1: Find "Frameworks, Libraries, and Embedded Content" Section

1. **You're already on the General tab** ✅
2. **Scroll down** in the General tab
3. **Look for** a section called **"Frameworks, Libraries, and Embedded Content"**
   - It's usually near the bottom of the General tab
   - You might need to scroll past:
     - Supported Destinations
     - Minimum Deployments
     - Identity
     - Embedded Content
     - App Icons and Launch Screens
     - etc.

### Step 2: Add Frameworks

Once you find the **"Frameworks, Libraries, and Embedded Content"** section:

1. **Click the "+" button** at the bottom left of that section
2. **A dialog will appear** showing available frameworks
3. **Add these frameworks one by one**:

   **Framework 1: HealthKit**
   - In the search box, type: `HealthKit`
   - Select **"HealthKit.framework"**
   - Click **"Add"**

   **Framework 2: WatchConnectivity**
   - Click **"+"** again
   - Type: `WatchConnectivity`
   - Select **"WatchConnectivity.framework"**
   - Click **"Add"**

   **Framework 3: WorkoutKit** (if available for watchOS 11+)
   - Click **"+"** again
   - Type: `WorkoutKit`
   - If it appears, select **"WorkoutKit.framework"**
   - Click **"Add"**
   - ⚠️ **Note**: WorkoutKit might only be available on watchOS 11.0+. If it doesn't appear, skip it for now.

   **Framework 4: WorkoutKitSync** (Package Product)
   - Click **"+"** again
   - Look for **"Package Products"** section in the dialog
   - Select **"WorkoutKitSync"**
   - Click **"Add"**

### Step 3: Verify Frameworks Are Added

After adding, you should see a table with columns:
- **Name** (framework name)
- **Kind** (Framework, Library, etc.)
- **Status** (Required, Optional)
- **Embed** (Do Not Embed, Embed & Sign, etc.)

**You should see:**
- ✅ `HealthKit.framework`
- ✅ `WatchConnectivity.framework`
- ✅ `WorkoutKit.framework` (if available)
- ✅ `WorkoutKitSync` (package product)

### Step 4: Set Embed Status (if needed)

For most system frameworks (HealthKit, WatchConnectivity, WorkoutKit):
- **Embed** should be set to **"Do Not Embed"** (default)
- System frameworks don't need to be embedded

For **WorkoutKitSync** (package product):
- **Embed** should be set to **"Do Not Embed"** (default)
- Package products are linked, not embedded

## Visual Guide

### What You Should See:

```
Frameworks, Libraries, and Embedded Content
┌─────────────────────────────┬──────────┬──────────┬──────────────────┐
│ Name                        │ Kind     │ Status   │ Embed            │
├─────────────────────────────┼──────────┼──────────┼──────────────────┤
│ HealthKit.framework         │ Framework│ Required │ Do Not Embed     │
│ WatchConnectivity.framework │ Framework│ Required │ Do Not Embed     │
│ WorkoutKit.framework        │ Framework│ Required │ Do Not Embed     │
│ WorkoutKitSync              │ Package  │ Required │ Do Not Embed     │
└─────────────────────────────┴──────────┴──────────┴──────────────────┘
[+] [-]
```

## Troubleshooting

### Can't find "Frameworks, Libraries, and Embedded Content" section:
- **Scroll down more** - it's usually at the bottom of the General tab
- Make sure you're on the **General** tab (not Build Settings or Build Phases)
- Try collapsing other sections to make more room

### Framework doesn't appear in the list:
- **HealthKit** and **WatchConnectivity** should always be available
- **WorkoutKit** might not be available if your deployment target is below watchOS 11.0
- **WorkoutKitSync** should appear if you added the package dependency in Step 3

### "WorkoutKitSync" not in the list:
- Go back to **Step 3** and make sure you added the package dependency
- Select **AmakaFlowWatch** target → **Package Dependencies** tab
- Verify **WorkoutKitSync** is listed there

### Framework added but shows errors:
- Make sure the framework is set to **"Required"** (not Optional)
- For system frameworks, **Embed** should be **"Do Not Embed"**

## Quick Checklist

- [ ] Found "Frameworks, Libraries, and Embedded Content" section
- [ ] Added HealthKit.framework
- [ ] Added WatchConnectivity.framework
- [ ] Added WorkoutKit.framework (if available)
- [ ] Added WorkoutKitSync package product
- [ ] All frameworks show "Do Not Embed" (for system frameworks)

## Next Steps

After adding frameworks:
1. ✅ **Build the project** (Cmd + B) to verify everything links correctly
2. ✅ **Move to Step 8**: Configure Minimum Deployment Targets
3. ✅ **Fix any build errors** that appear


