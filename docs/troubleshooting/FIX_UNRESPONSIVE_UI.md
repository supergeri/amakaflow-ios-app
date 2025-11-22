# Fix Unresponsive UI - Troubleshooting Guide

## Problem: Phone Cannot Interact / UI Frozen

If the app is running but you cannot interact with it (touches don't respond, buttons don't work), try these fixes:

## Quick Fixes (Try These First)

### 1. Check if Files Are Included in Target

The most common cause is **missing files in the target membership**:

1. **Select a Swift file** in Project Navigator (e.g., `Theme.swift`, `Workout.swift`)
2. **Open File Inspector** (right sidebar, or press **Option+Cmd+1**)
3. **Check "Target Membership"** section
4. **Verify** ✅ **"AmakaFlowCompanion"** is checked

**Fix missing files**:
1. **Select the file** in Project Navigator
2. **File Inspector** → **Target Membership**
3. **Check** ✅ **"AmakaFlowCompanion"** for iOS files
4. **Repeat** for all Swift files in `AmakaFlow` folder

### 2. Clean and Rebuild

1. **Product → Clean Build Folder** (Shift + Cmd + K)
2. **Wait for "Clean Succeeded"**
3. **Product → Build** (Cmd + B)
4. **Check for errors**
5. **Product → Run** (Cmd + R)

### 3. Delete Derived Data

1. **Xcode → Settings** (Cmd + ,)
2. **Locations tab**
3. **Click arrow** next to "Derived Data" path
4. **Close Xcode** (Cmd + Q)
5. **Delete Derived Data folder** for your project
6. **Reopen Xcode and rebuild**

## Check Required Files Are in Target

Make sure these files are included in **AmakaFlowCompanion** target:

- ✅ `Theme.swift`
- ✅ `Workout.swift` (from Models)
- ✅ `WorkoutsViewModel.swift` (from ViewModels)
- ✅ `WatchConnectivityManager.swift` (from Services)
- ✅ `CalendarManager.swift` (from Services)
- ✅ `WorkoutKitConverter.swift` (from Services)
- ✅ `WorkoutsView.swift` (from Views)
- ✅ `SettingsView.swift` (from Views)
- ✅ `WorkoutDetailView.swift` (from Views)
- ✅ `WorkoutCard.swift` (from Views/Components)
- ✅ `IntervalRow.swift` (from Views/Components)
- ✅ All other Swift files in `AmakaFlow` folder

## Verify Build Success

1. **Build** (Cmd + B)
2. **Check for errors** in Issue Navigator
3. **If you see errors like**:
   - ❌ "Cannot find 'Theme' in scope"
   - ❌ "Cannot find 'Workout' in scope"
   - ❌ "Cannot find 'WorkoutsViewModel' in scope"
   
   **Fix**: Add those files to the target (see Step 1 above)

## Test with Minimal UI

If the app still doesn't respond, try this minimal test:

1. **Temporarily simplify** `ContentView.swift`:
```swift
struct ContentView: View {
    var body: some View {
        VStack {
            Text("App is working!")
                .foregroundColor(.white)
                .padding()
            
            Button("Test Button") {
                print("Button tapped!")
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}
```

2. **Run the app**
3. **If this works**, the issue is with specific views/components
4. **If this doesn't work**, it's a more fundamental issue

## Check for Blocking Operations

Look for blocking operations on the main thread:

1. **Check `WorkoutsViewModel.init()`** - should be fast
2. **Check `WatchConnectivity.activate()`** - now async (non-blocking)
3. **Check any `onAppear`** - should not block

## Debug Steps

1. **Check Console** for crash logs
2. **Check Threads** in Debug Navigator (pause the app)
3. **Check Memory** - is memory growing?
4. **Check CPU** - is it at 100%?

## Common Causes

1. ❌ **Missing files in target** (most common)
2. ❌ **Blocking main thread** (synchronous network calls, etc.)
3. ❌ **Infinite loop** in view rendering
4. ❌ **Memory crash** (out of memory)
5. ❌ **Missing environment objects**

## After Fixing

1. **Clean Build Folder**
2. **Rebuild**
3. **Run**
4. **Test interaction** - tap buttons, scroll, navigate

If still not working, check the **Issue Navigator** for specific build/runtime errors.


