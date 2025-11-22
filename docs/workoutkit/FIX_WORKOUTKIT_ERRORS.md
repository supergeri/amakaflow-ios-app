# Fix WorkoutKit Type Errors

## Current Errors

The code is using WorkoutKit types that aren't being found:
- ❌ `WorkoutActivity` - Cannot find type
- ❌ `WorkoutComposition` - Cannot find
- ❌ `WorkoutStep` - Type has no member 'work', 'rest', etc.

## Problem

WorkoutKit is only available on **watchOS 11.0+**, but the code has `@available(watchOS 10.0, *)` which creates a mismatch. Also, WorkoutKit types might need proper availability checks.

## Solution: Fix Availability and Type Usage

### Option 1: Update Availability to watchOS 11.0+ (Recommended)

If you want to use WorkoutKit, you need watchOS 11.0+:

1. **Update the function availability**:
   - Change `@available(watchOS 10.0, *)` to `@available(watchOS 11.0, *)`
   - Or use `#if canImport(WorkoutKit)` for conditional compilation

2. **Update minimum deployment target**:
   - Make sure "AmakaFlowWatch Watch App" target has minimum deployment of **watchOS 11.0**
   - (You already set this earlier)

### Option 2: Use HealthKit Instead (Fallback)

If you want to support watchOS 10.0, use HealthKit instead of WorkoutKit for those functions.

## Quick Fix: Update Availability

The `workoutActivity` function needs to be available only on watchOS 11.0+:

```swift
@available(watchOS 11.0, *)
private func workoutActivity(for sport: WorkoutSport) -> WorkoutActivity {
    // ... existing code ...
}
```

And any code that uses `WorkoutComposition` or `WorkoutStep` also needs `@available(watchOS 11.0, *)`.

## Check WorkoutKit Import

Make sure WorkoutKit is properly imported and available:

1. **Check Build Settings**:
   - Select "AmakaFlowWatch Watch App" target
   - Build Settings → Search for "framework search paths"
   - Verify WorkoutKit framework is linked

2. **Check Framework is Added**:
   - General tab → Frameworks, Libraries, and Embedded Content
   - Should show `WorkoutKit.framework`

## Alternative: Conditional Compilation

If you want to support both watchOS 10.0 and 11.0+:

```swift
#if canImport(WorkoutKit)
@available(watchOS 11.0, *)
private func workoutActivity(for sport: WorkoutSport) -> WorkoutActivity {
    // WorkoutKit code
}
#endif

// Fallback for watchOS 10.0
private func hkActivityType(for sport: WorkoutSport) -> HKWorkoutActivityType {
    // HealthKit code (already exists)
}
```

## Next Steps

1. **Update availability annotations** to `@available(watchOS 11.0, *)` for WorkoutKit functions
2. **Verify WorkoutKit framework** is added to the target
3. **Clean and rebuild** the project
4. **Check if errors are resolved**


