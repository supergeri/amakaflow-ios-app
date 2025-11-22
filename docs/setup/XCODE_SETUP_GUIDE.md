# Xcode Setup Guide for AmakaFlow Companion iOS App

This guide will help you create the Xcode project and configure it properly.

## Step 1: Create Xcode Project

1. Open Xcode 15+ (or latest version)
2. **File → New → Project**
3. Select **iOS → App**
4. Configure:
   - **Product Name**: `AmakaFlowCompanion` (no spaces for bundle identifier)
   - **Display Name**: `AmakaFlow Companion` (shown to users)
   - **Team**: Select your Apple Developer account
   - **Organization Identifier**: `com.amakaflow` (or your own)
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: **None** (or SwiftData if you want local persistence later)
   - **Include Tests**: ✅ (optional but recommended)
5. Click **Next**
6. **Save Location**: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/`
   - ⚠️ **Important**: Select "Create Git repository" ✅ if you want version control
7. Click **Create**

### Optional: Initialize Git Repository (if you forgot to check "Create Git repository")

If you forgot to check "Create Git repository" during project creation, you can initialize it manually:

1. Open Terminal
2. Navigate to the project directory:
   ```bash
   cd /Users/davidandrews/dev/amakaflow-dev/amakaflow-ios
   ```
3. Initialize Git repository:
   ```bash
   git init
   ```
4. Add all files:
   ```bash
   git add .
   ```
5. Create initial commit:
   ```bash
   git commit -m "Initial commit: AmakaFlow Companion iOS app"
   ```
6. (Optional) Add remote repository if you have one:
   ```bash
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

**Note**: The `.gitignore` file should already exist if you created the project in Xcode. If not, you may want to create one to exclude build artifacts, user data, and Xcode-specific files.

## Step 2: Add watchOS Target

1. **File → New → Target**
2. Select **watchOS → App**
3. Click **Next**
4. Configure:
   - **Product Name**: `AmakaFlowWatch`
   - **Team**: Same as iOS target
   - **Organization Identifier**: Same as iOS target
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: **None**
   - **Supports**: **Watch App Only** (not companion app)
   - **Include Tests**: ✅ (optional)
5. Click **Finish**
6. When prompted about activating the scheme, click **Activate**

## Step 3: Add WorkoutKitSync Package Dependency

1. Select the **AmakaFlowCompanion** project in the Project Navigator (top icon)
2. Select the **AmakaFlowCompanion** target (iOS)
3. Go to **Package Dependencies** tab
4. Click **+** button
5. Click **Add Local...**
6. Navigate to: `/Users/davidandrews/dev/workoutkit-sync`
7. Click **Add Package**
8. Select `WorkoutKitSync` product
9. Click **Add Package**
10. Repeat for **AmakaFlowWatch** target (watchOS):
    - **Click the blue project icon** at top of Project Navigator
    - In the main editor, find **TARGETS** section
    - **Click "AmakaFlowWatch"** in the TARGETS list
    - Go to **Package Dependencies** tab
    - Click **+** → **Add Local...**
    - Navigate to `/Users/davidandrews/dev/workoutkit-sync`
    - Click **Add Package**
    - Select `WorkoutKitSync` product
    - Click **Add Package**

## Step 4: Configure Capabilities

### iOS Target Capabilities

1. Select **AmakaFlowCompanion** project → **AmakaFlowCompanion** target (iOS)
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **HealthKit**:
   - Click **+ Capability** → Select **HealthKit**
   - The HealthKit section will expand showing three subsections:
     - **Health Records** (optional - you can skip this)
     - **Health Share** (for READ access)
     - **Health Update** (for WRITE access)
   - **Important**: Fill in BOTH "Health Share" and "Health Update" Usage Descriptions before clicking away, or the empty section may collapse.
   - In the **Health Share** section, click the text field and enter:
     ```
     AmakaFlow Companion needs access to read your workout data
     ```
   - In the **Health Update** section, click the text field and enter:
     ```
     AmakaFlow Companion needs access to save your completed workouts
     ```
   - ⚠️ **Note**: In Xcode 15+, HealthKit doesn't have separate "Read" and "Write" checkboxes. Adding Usage Descriptions automatically grants that access type.
   - ⚠️ **If a section disappears**: Click the down arrow next to "HealthKit" to expand it again, then fill in the missing Usage Description.
5. Add **Background Modes**:
   - Click **+ Capability** → Select **Background Modes**
   - Enable: "Background fetch" and "Remote notifications"
6. **Watch Connectivity** will be automatically added when you add watchOS target

### watchOS Target Capabilities

⚠️ **IMPORTANT**: watchOS targets **do not support** the Capabilities UI panel in Xcode. You must configure HealthKit manually through entitlements and Info.plist.

#### Step 1: Create/Edit Entitlements File

1. **Click the blue project icon** at top of Project Navigator
2. In the main editor, find **TARGETS** section
3. **Click "AmakaFlowWatch"** in the TARGETS list
4. Go to **Signing & Capabilities** tab
5. Look for **Entitlements File** field (under "Code Signing Entitlements")
6. If empty, create a new entitlements file:
   - Right-click on **AmakaFlowWatch Watch App** folder in Project Navigator
   - Select **New File...**
   - Choose **Property List** template
   - Name it `AmakaFlowWatch.entitlements`
   - Make sure **AmakaFlowWatch** target is selected
   - Click **Create**
7. If an entitlements file already exists, click on it to open

#### Step 2: Add HealthKit Entitlement

1. Open the `AmakaFlowWatch.entitlements` file (or the existing entitlements file)
2. Add the HealthKit entitlement:
   - Click the **+** button to add a new key
   - Type: `com.apple.developer.healthkit`
   - Set value type to **Boolean**
   - Set value to **YES** (checkmark)
   - Or manually add this XML:
   ```xml
   <key>com.apple.developer.healthkit</key>
   <true/>
   ```

#### Step 3: Verify Entitlements File is Linked

After creating the entitlements file, Xcode usually auto-detects it. To verify or manually set:

1. Select **AmakaFlowWatch** target
2. Go to **Build Settings** tab
3. **Important**: Make sure you're viewing **"All"** settings (not "Basic"):
   - Look for a dropdown at the top of Build Settings pane
   - Select **"All"** instead of "Basic"
4. In the search box (top right of Build Settings), type: `entitlements`
5. Look for **"Code Signing Entitlements"**:
   - If it appears and is empty, double-click the value field
   - Enter: `AmakaFlowWatch/AmakaFlowWatch.entitlements`
   - If it already shows the correct path, you're good!
   - **Note**: If this setting doesn't appear, that's OK - Xcode may auto-detect it if the file is properly added to the target

**Alternative**: Sometimes the entitlements file path appears in **Signing & Capabilities** tab under the "Signing" section.

**Note**: HealthKit usage descriptions are added in Info.plist (see Step 5 below). The Capabilities panel showing "No matches" is expected for watchOS - just ignore it.

**Troubleshooting**: If you can't find "Code Signing Entitlements" in Build Settings, see `FIND_ENTITLEMENTS_SETTING.md` for detailed instructions.

## Step 5: Update Info.plist Files

### iOS Info.plist

1. Find `Info.plist` in **AmakaFlowCompanion** target (or create one if using SwiftUI targets)
2. Add these keys (or add to `Info` dictionary if using Xcode 15+):

```xml
<key>NSCalendarsUsageDescription</key>
<string>AmakaFlow Companion schedules your workouts to your calendar with reminders</string>

<key>NSHealthShareUsageDescription</key>
<string>AmakaFlow Companion needs access to read your workout data</string>

<key>NSHealthUpdateUsageDescription</key>
<string>AmakaFlow Companion needs access to save your completed workouts</string>

<key>NSCalendarsWriteOnlyAccessUsageDescription</key>
<string>AmakaFlow Companion creates calendar events for your scheduled workouts</string>
```

**For Xcode 15+ (using Info dictionary directly in target settings):**
1. Select **AmakaFlowCompanion** target
2. Go to **Info** tab
3. Click **+** to add each key above with its corresponding value

### watchOS Info.plist

1. **Click the blue project icon** at top of Project Navigator
2. In the main editor, find **TARGETS** section
3. **Click "AmakaFlowWatch"** in the TARGETS list
4. Go to **Info** tab
5. Add these keys:

```xml
<key>NSHealthShareUsageDescription</key>
<string>AmakaFlow Companion needs access to track your workouts</string>

<key>NSHealthUpdateUsageDescription</key>
<string>AmakaFlow Companion saves your workout data to Health</string>
```

## Step 6: Add Existing Swift Files

### ⚠️ Important: Target Membership

When adding files, make sure **Target Membership** is checked for **AmakaFlowCompanion** target, otherwise previews won't work.

### Adding Files

1. **Delete** the default `ContentView.swift` and `*App.swift` files that Xcode created (if they exist)
2. Right-click on **AmakaFlowCompanion** folder in Project Navigator
3. Select **Add Files to "AmakaFlowCompanion"...**
4. Navigate to: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlow/`
5. Select all `.swift` files in the main `AmakaFlow` folder:
   - `AmakaFlowApp.swift`
   - `Theme.swift`
6. **Uncheck** "Copy items if needed" (files are already in the right place)
7. ✅ **IMPORTANT**: Under "Add to targets", check ✅ **AmakaFlowCompanion** (iOS target)
8. Click **Add**
9. Repeat for subdirectories:
   - Add files from `AmakaFlow/Models/` → Check ✅ **AmakaFlowCompanion** target
   - Add files from `AmakaFlow/ViewModels/` → Check ✅ **AmakaFlowCompanion** target
   - Add files from `AmakaFlow/Views/` → Check ✅ **AmakaFlowCompanion** target
   - Add files from `AmakaFlow/Views/Components/` → Check ✅ **AmakaFlowCompanion** target
   - Add files from `AmakaFlow/Services/` → Check ✅ **AmakaFlowCompanion** target

### Verify Target Membership

After adding files, verify they're in the target:
1. Select any Swift file in Project Navigator
2. Open **File Inspector** (right sidebar, or **Option+Cmd+1**)
3. Under **Target Membership**, you should see ✅ **AmakaFlowCompanion** checked
4. If not checked, check it manually for each file

### For watchOS Target

1. Right-click on **AmakaFlowWatch Watch App** folder (or create a folder group)
2. Select **Add Files to "AmakaFlowCompanion"...**
3. Navigate to: `/Users/davidandrews/dev/amakaflow-dev/amakaflow-ios/AmakaFlowWatch/`
4. Select all `.swift` files:
   - `AmakaFlowWatchApp.swift`
   - `WatchWorkoutManager.swift`
   - `WorkoutListView.swift`
5. **Uncheck** "Copy items if needed"
6. ✅ **IMPORTANT**: Under "Add to targets", check ✅ **AmakaFlowWatch** (watchOS target only)
7. Click **Add**

## Step 7: Add Frameworks (if needed)

Frameworks should be automatically linked, but verify:

1. Select **AmakaFlowCompanion** target
2. Go to **General** tab
3. Scroll to **Frameworks, Libraries, and Embedded Content**
4. Verify these are present (add if missing):
   - `EventKit.framework`
   - `HealthKit.framework`
   - `WatchConnectivity.framework`
   - `WorkoutKitSync` (package product)

5. For **AmakaFlowWatch Watch App** target:
   - **Click the blue project icon** at top of Project Navigator
   - In the main editor, find **TARGETS** section
   - **Click "AmakaFlowWatch Watch App"** in the TARGETS list (⚠️ **Note**: This is the watchOS app target, not "AmakaFlowWatch")
   - Go to **General** tab
   - Scroll down to **"Frameworks, Libraries, and Embedded Content"** section
   - Click **+** button to add:
     - `HealthKit.framework`
     - `WatchConnectivity.framework`
     - `WorkoutKit.framework` (watchOS 11+)
     - `WorkoutKitSync` (package product)

## Step 8: Configure Minimum Deployment Targets

1. Select **AmakaFlowCompanion** target
2. Go to **General** tab
3. Set **iOS Deployment Target**: **17.0** (or **18.0** for WorkoutKit support)

4. Select **AmakaFlowWatch** target
5. Set **watchOS Deployment Target**: **10.0** (or **11.0** for WorkoutKit support)

⚠️ **Note**: WorkoutKit requires iOS 18.0+ / watchOS 11.0+. If you want to support iOS 17.0, you'll need conditional compilation.

## Step 9: Build and Test

1. Select a physical device (iPhone) or Simulator
2. Press **Cmd+B** to build
3. Fix any compilation errors:
   - Missing imports
   - Missing files in target membership
   - Framework linking issues

## Common Issues

### Issue: "Cannot find 'WorkoutKitSync' in scope"
- **Solution**: Make sure the package dependency is added to the correct target
- Check **Package Dependencies** tab for the target

### Issue: HealthKit/Calendar permissions not working
- **Solution**: Make sure Info.plist keys are added correctly
- Check target membership for Info.plist

### Issue: Watch app not connecting
- **Solution**: 
  - Make sure WatchConnectivity is added to both targets
  - Both apps must be installed (iOS app on iPhone, watchOS app on Watch)
  - Check that session is activated in `WatchConnectivityManager`

### Issue: WorkoutKit not available
- **Solution**: 
  - WorkoutKit requires iOS 18.0+ / watchOS 11.0+
  - Use conditional compilation: `#if canImport(WorkoutKit)`
  - Or raise minimum deployment target

## Next Steps

After setup is complete:
1. Add sample workout data (see `SAMPLE_WORKOUTS.md`)
2. Test Watch connectivity
3. Test Calendar integration
4. Test WorkoutKit conversion

See the main `README.md` for more details on using the app.

