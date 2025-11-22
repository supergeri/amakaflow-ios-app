# Fix WKPlanDTO Initialization Errors

## Problem

You're getting errors:
- ❌ "Extra arguments at positions #1, #2, #3, #4 in call"
- ❌ "'nil' requires a contextual type"

This is because **`WKPlanDTO` only has a `Decodable` initializer** - it can't be created with memberwise initialization.

## Solution: Use JSON Encoding/Decoding

Since `WKPlanDTO` is `Decodable`, we need to create it via JSON encoding/decoding instead of direct initialization.

### Option 1: Add Public Initializer to WKPlanDTO (Best Solution)

But first, we need to update the iOS deployment target to 18.0.

### Option 2: Create via JSON (Quick Fix)

Convert Workout to JSON, then decode as WKPlanDTO.

## Step 1: Update iOS Deployment Target

**CRITICAL**: Update iOS deployment target to 18.0 first:

1. **Select AmakaFlowCompanion target**
2. **Go to General tab**
3. **Find "Minimum Deployments"** section
4. **Change "iOS" from 17.0 to 18.0**
5. **Press Enter**

## Step 2: Fix WorkoutKitConverter

The issue is that `WKPlanDTO` doesn't have a public memberwise initializer. We need to either:

### Fix A: Add Public Initializer (Requires modifying WorkoutKitSync package)

This would require editing the WorkoutKitSync package source, which might not be ideal.

### Fix B: Create via JSON (Recommended for now)

Create WKPlanDTO by encoding a dictionary to JSON, then decoding it:

```swift
// Instead of direct init:
let dto = WKPlanDTO(
    title: workout.name,
    sportType: sportType,
    schedule: nil,
    intervals: intervals
)

// Use JSON encoding/decoding:
let jsonDict: [String: Any] = [
    "title": workout.name,
    "sportType": sportType,
    "schedule": nil as Any?,
    "intervals": intervals // Need to encode intervals properly
]
let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
let dto = try JSONDecoder().decode(WKPlanDTO.self, from: jsonData)
```

But this is complex because `intervals` needs to be properly encoded as JSON first.

### Fix C: Check if Package Has Initializer (Check Package Source)

Let me check if we can add a public initializer to the package.

## Quick Fix: Update Deployment Target First

**DO THIS FIRST** before fixing the API calls:

1. Update iOS deployment target to **18.0**
2. Clean and rebuild
3. See if errors change

The deployment target mismatch might be causing some of these errors.


