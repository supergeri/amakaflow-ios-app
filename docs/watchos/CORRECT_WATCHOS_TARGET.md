# Correct watchOS Target for Frameworks

## ✅ You're Correct!

**Yes, you should use "AmakaFlowWatch Watch App" target, not "AmakaFlowWatch".**

## Why There Are Two Targets

When you add a watchOS target in Xcode, it typically creates **TWO targets**:

1. **"AmakaFlowWatch"** - This might be the extension or a parent target
2. **"AmakaFlowWatch Watch App"** - This is the **actual watchOS app** that runs on Apple Watch ✅

## Which Target to Use

### ✅ Use "AmakaFlowWatch Watch App" for:
- Adding frameworks (HealthKit, WatchConnectivity, WorkoutKit, WorkoutKitSync)
- Setting deployment targets
- Adding Info.plist keys
- Adding Swift files that run on the watch

### The "AmakaFlowWatch" target might be:
- A watchOS extension target
- A parent/organizational target
- Not the main app target

## How to Identify the Correct Target

Look at the **"Frameworks, Libraries, and Embedded Content"** section:

- ✅ **"AmakaFlowWatch Watch App"** has this section → **Use this one**
- ❌ **"AmakaFlowWatch"** might not have this section or might be missing features

## Your Current Setup (from screenshot)

✅ **You're viewing**: "AmakaFlowWatch Watch App" target
✅ **You can see**: "Frameworks, Libraries, and Embedded Content" section (empty, ready for you to add frameworks)
✅ **Supported Destinations**: Apple Watch with watchOS SDK
✅ **This is the correct target!**

## Next Steps

1. ✅ You're already on the correct target ("AmakaFlowWatch Watch App")
2. ✅ You can see the "Frameworks, Libraries, and Embedded Content" section
3. ✅ Now click the **+** button to add frameworks:
   - HealthKit.framework
   - WatchConnectivity.framework
   - WorkoutKit.framework (if available)
   - WorkoutKitSync (package product)

## Summary

- ✅ **Correct Target**: "AmakaFlowWatch Watch App"
- ✅ **Location**: General tab → Frameworks, Libraries, and Embedded Content section
- ✅ **Action**: Click + button and add the frameworks listed above

You're all set! Add the frameworks now.


