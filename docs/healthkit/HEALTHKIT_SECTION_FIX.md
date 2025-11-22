# HealthKit Section Disappearing - Quick Fix

## Problem
When you click away from the **Health Update** section in Xcode's HealthKit capability, it disappears/collapses.

## Why This Happens
- The **Health Update** Usage Description field is empty
- Xcode may auto-hide empty sections when you click away
- The section is still there, just collapsed

## Solution

### Option 1: Fill in Text Before Clicking Away
1. Click into the **Health Update** text field (where it says "Usage Description")
2. **Immediately type** this text:
   ```
   AmakaFlow Companion needs access to save your completed workouts
   ```
3. **Don't click away** until the text is entered
4. The section will stay visible once text is added

### Option 2: Expand the Section Again
If the section already disappeared:

1. Look for the **HealthKit** section header in the **Signing & Capabilities** tab
2. You'll see a **down arrow (▼)** or **right arrow (▶)** next to "HealthKit"
3. Click the arrow to expand/collapse the HealthKit section
4. Once expanded, you'll see:
   - **Health Records** (optional)
   - **Health Share** (should have text already)
   - **Health Update** (this is the one that disappeared)
5. Click in the **Health Update** text field
6. Enter:
   ```
   AmakaFlow Companion needs access to save your completed workouts
   ```

## Visual Guide

```
HealthKit ▼              [Info icon]  [Trash icon]
  ├─ Options
  │   ├─ ☐ Clinical Health Records
  │   └─ ☐ HealthKit Background Delivery
  │
  ├─ Health Records
  │   └─ [Usage Description: empty]
  │
  ├─ Health Share
  │   └─ [Usage Description: "AmakaFlow Companion needs access..."] ✅
  │
  └─ Health Update
      └─ [Usage Description: empty] ← Click here and type!
```

## Complete Text to Enter

### Health Share (READ access):
```
AmakaFlow Companion needs access to read your workout data
```

### Health Update (WRITE access):
```
AmakaFlow Companion needs access to save your completed workouts
```

## Tips
- ✅ Enter text immediately after clicking the field
- ✅ Use copy/paste if needed: Cmd+C / Cmd+V
- ✅ Both sections need text to enable READ + WRITE access
- ❌ Don't leave fields empty before clicking away

## Still Not Working?
- Make sure you're on the correct target (AmakaFlowCompanion for iOS, or AmakaFlowWatch for watchOS)
- Try closing and reopening Xcode
- The section should always be visible once text is entered

