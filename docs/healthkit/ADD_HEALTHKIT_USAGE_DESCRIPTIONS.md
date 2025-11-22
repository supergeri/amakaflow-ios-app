# Add HealthKit Usage Descriptions to Info.plist

## Step 5: Add HealthKit Usage Descriptions for watchOS

You've set up the entitlements file! Now you need to add usage descriptions so iOS/watchOS knows why your app needs HealthKit access.

### For watchOS Target (AmakaFlowWatch):

1. **Select the AmakaFlowWatch target**:
   - Click the blue project icon at top of Project Navigator
   - Find **TARGETS** section
   - Click **"AmakaFlowWatch"**

2. **Go to Info tab**:
   - Click the **"Info"** tab (next to Build Settings)
   - You'll see a list of keys and values (or an empty list)

3. **Add HealthKit Usage Descriptions**:
   - Click the **+** button (top left of the Info list)
   - Add the following two keys:

   **Key 1:**
   - Type: `NSHealthShareUsageDescription`
   - Press Enter or Tab
   - Type: `AmakaFlow Companion needs access to track your workouts`
   - Press Enter

   **Key 2:**
   - Click the **+** button again
   - Type: `NSHealthUpdateUsageDescription`
   - Press Enter or Tab
   - Type: `AmakaFlow Companion saves your workout data to Health`
   - Press Enter

4. **Verify**:
   - You should now see two entries:
     - `NSHealthShareUsageDescription` = "AmakaFlow Companion needs access to track your workouts"
     - `NSHealthUpdateUsageDescription` = "AmakaFlow Companion saves your workout data to Health"

### What You Should See in Info Tab:

```
Key                                    | Type  | Value
---------------------------------------|-------|----------------------------------------
NSHealthShareUsageDescription          | String| AmakaFlow Companion needs access to...
NSHealthUpdateUsageDescription         | String| AmakaFlow Companion saves your workout...
```

## Next: Do the Same for iOS Target (AmakaFlowCompanion)

After adding for watchOS, do the same for iOS:

1. **Select AmakaFlowCompanion target**
2. **Go to Info tab**
3. **Add these keys**:

   - `NSHealthShareUsageDescription`: `AmakaFlow Companion needs access to read your workout data`
   - `NSHealthUpdateUsageDescription`: `AmakaFlow Companion needs access to save your completed workouts`
   - `NSCalendarsUsageDescription`: `AmakaFlow Companion schedules your workouts to your calendar with reminders`
   - `NSCalendarsWriteOnlyAccessUsageDescription`: `AmakaFlow Companion creates calendar events for your scheduled workouts`

## Important Notes

✅ **Both entitlements AND usage descriptions are required** - one without the other won't work
✅ **Usage descriptions appear in permission dialogs** - users see these when your app requests HealthKit access
✅ **Different targets can have different descriptions** - watchOS and iOS can have different messages

## Checklist

For watchOS:
- [ ] ✅ Entitlements file created with `com.apple.developer.healthkit = true`
- [ ] ✅ Code Signing Entitlements path set in Build Settings
- [ ] ✅ `NSHealthShareUsageDescription` added to Info.plist
- [ ] ✅ `NSHealthUpdateUsageDescription` added to Info.plist

For iOS (after watchOS):
- [ ] ✅ HealthKit capability added (via Capabilities panel)
- [ ] ✅ `NSHealthShareUsageDescription` added to Info.plist
- [ ] ✅ `NSHealthUpdateUsageDescription` added to Info.plist
- [ ] ✅ Calendar usage descriptions added (if using Calendar sync)


