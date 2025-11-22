# Next Steps After HealthKit Setup

## ✅ What You've Completed

### watchOS Target (AmakaFlowWatch):
- ✅ HealthKit entitlements file created (`AmakFlowWatch.entitlements`)
- ✅ HealthKit entitlement added (`com.apple.developer.healthkit = true`)
- ✅ Code Signing Entitlements path set in Build Settings
- ✅ HealthKit usage descriptions added to Info.plist

## 🔄 Next: Complete iOS Target HealthKit Setup

Before moving on, let's make sure the **iOS target (AmakaFlowCompanion)** also has HealthKit configured:

### Step A: Add HealthKit Capability for iOS Target

1. **Select AmakaFlowCompanion target**:
   - Click blue project icon at top
   - Find **TARGETS** section
   - Click **"AmakaFlowCompanion"**

2. **Go to Signing & Capabilities tab**:
   - Click **"Signing & Capabilities"** tab

3. **Add HealthKit capability**:
   - Click **"+ Capability"** button
   - Search for or select **"HealthKit"**
   - Click to add it

4. **Add Usage Descriptions**:
   - The HealthKit section should expand
   - In **"Health Share"** section, add:
     ```
     AmakaFlow Companion needs access to read your workout data
     ```
   - In **"Health Update"** section, add:
     ```
     AmakaFlow Companion needs access to save your completed workouts
     ```

5. **Add Calendar capability** (if using Calendar sync):
   - Click **"+ Capability"** again
   - Add **"Background Modes"** capability
   - Enable: "Background fetch" and "Remote notifications"

### Step B: Add HealthKit Usage Descriptions to iOS Info.plist

1. **Find Info.plist for iOS target**:
   - In Project Navigator, look for `Info.plist` in **"AmakaFlowCompanion"** folder
   - Or create it if it doesn't exist (same process as watchOS)

2. **Add these keys**:
   - `NSHealthShareUsageDescription`: `AmakaFlow Companion needs access to read your workout data`
   - `NSHealthUpdateUsageDescription`: `AmakaFlow Companion needs access to save your completed workouts`
   - `NSCalendarsUsageDescription`: `AmakaFlow Companion schedules your workouts to your calendar with reminders`
   - `NSCalendarsWriteOnlyAccessUsageDescription`: `AmakaFlow Companion creates calendar events for your scheduled workouts`

## 📝 Step 6: Add Existing Swift Files

After HealthKit is set up for both targets, add your Swift code:

### For iOS Target:

1. **Delete default files** (if they exist):
   - `ContentView.swift`
   - `*App.swift` files that Xcode created

2. **Add Swift files from your project**:
   - Right-click on **"AmakaFlowCompanion"** folder
   - Select **"Add Files to 'AmakaFlowCompanion'..."**
   - Navigate to where your Swift files are located
   - Select all `.swift` files you need
   - ✅ **IMPORTANT**: Check **"AmakaFlowCompanion"** under "Add to targets"
   - Uncheck "Copy items if needed" if files are already in the right place
   - Click **"Add"**

### For watchOS Target:

1. **Add watchOS Swift files** (if you have any):
   - Right-click on **"AmakaFlowWatch Watch App"** folder
   - Select **"Add Files to 'AmakaFlowCompanion'..."**
   - Navigate to your watchOS Swift files
   - Select the files
   - ✅ Check **"AmakaFlowWatch"** under "Add to targets"
   - Click **"Add"**

## ✅ Verification Checklist

### watchOS Target:
- [x] HealthKit entitlements file exists
- [x] Entitlements linked in Build Settings
- [x] Usage descriptions in Info.plist

### iOS Target:
- [ ] HealthKit capability added (via Capabilities panel)
- [ ] HealthKit usage descriptions in Info.plist
- [ ] Calendar usage descriptions (if using Calendar)

### Both Targets:
- [ ] Swift files added and target membership verified
- [ ] Build successful (Cmd + B) with no errors

## 🚀 After All Steps Complete

1. **Build the project**: Press **Cmd + B**
2. **Fix any errors** that appear
3. **Test on simulator** or physical device
4. **Verify HealthKit permissions** work when running the app

## Quick Reference

- **watchOS HealthKit**: Done ✅
- **iOS HealthKit**: Needs setup (see Step A above)
- **Swift Files**: Add after HealthKit setup (Step 6)
- **Build & Test**: Final verification


