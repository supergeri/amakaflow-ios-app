# Fix: Cannot Preview Files - iOS Deployment Target Issue

## Problem

If you're seeing an error like:
```
Cannot preview this file
Download Xcode support for iOS 26.1
```

This is because the Xcode project has the deployment target set to iOS 26.1, which doesn't exist yet.

## Solution

### Option 1: Fix in Xcode (Recommended)

1. Open your Xcode project
2. Select the **AmakaFlowCompanion** project in the Project Navigator
3. Select the **AmakaFlowCompanion** target (iOS)
4. Go to **General** tab
5. Find **Minimum Deployments**
6. Change **iOS** from `26.1` to `17.0` (or `18.0` for WorkoutKit support)
7. Repeat for **AmakaFlowCompanionTests** and **AmakaFlowCompanionUITests** targets if they also have incorrect deployment targets

### Option 2: Fix via Command Line

The deployment target has already been fixed in the project file, but if you need to verify:

```bash
cd /Users/davidandrews/dev/amakaflow-dev/amakaflow-ios
grep -n "IPHONEOS_DEPLOYMENT_TARGET" AmakaFlowCompanion/AmakaFlowCompanion.xcodeproj/project.pbxproj
```

Should show: `IPHONEOS_DEPLOYMENT_TARGET = 17.0;`

## Recommended Settings

- **iOS Deployment Target**: `17.0` (minimum) or `18.0` (for WorkoutKit support)
- **watchOS Deployment Target**: `10.0` (minimum) or `11.0` (for WorkoutKit support)

## After Fixing

1. Close and reopen Xcode (if the error persists)
2. Clean build folder: **Product → Clean Build Folder** (Cmd+Shift+K)
3. Try the preview again

The preview should now work with available iOS simulators.

