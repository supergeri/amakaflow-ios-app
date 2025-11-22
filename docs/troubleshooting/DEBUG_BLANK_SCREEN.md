# Debug Blank Detail Screen

## Problem: Detail Screen is Blank

The list shows correctly, but when clicking a workout, the detail screen is completely blank.

## Possible Causes

1. **Missing Navigation Title** (FIXED ✅ - added `.navigationTitle()`)
2. **Files not in target** - Components missing from target membership
3. **View not rendering** - Crash during view initialization
4. **Content not visible** - Black on black, transparent, etc.

## Quick Debug Steps

### Step 1: Check Console for Errors

1. **Run app** (Cmd + R)
2. **Open Console** (View → Debug Area → Show Debug Area, or Cmd + Shift + Y)
3. **Tap on a workout**
4. **Look for errors**:
   - "Cannot find 'WorkoutHeaderCard' in scope"
   - "Cannot find 'IntervalRow' in scope"
   - "Fatal error: Array index out of range"
   - Any crash logs

### Step 2: Verify Target Membership

Make sure these files are included in **AmakaFlowCompanion** target:

1. **Select file** in Project Navigator
2. **File Inspector** (Option+Cmd+1)
3. **Target Membership** → Check ✅ **"AmakaFlowCompanion"**

Required files:
- ✅ `WorkoutDetailView.swift`
- ✅ `WorkoutHeaderCard` (inside WorkoutDetailView.swift - same file)
- ✅ `IntervalRow.swift`
- ✅ `ScheduleCalendarSheet.swift`
- ✅ `Theme.swift`
- ✅ `Workout.swift` (model)

### Step 3: Test with Minimal View

Temporarily replace `WorkoutDetailView.body` with:

```swift
var body: some View {
    NavigationStack {
        VStack {
            Text("Workout: \(workout.name)")
                .font(.title)
                .foregroundColor(.white)
                .padding()
            
            Text("Intervals: \(workout.intervals.count)")
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .navigationTitle(workout.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
}
```

**If this works:**
- The issue is with the view rendering (WorkoutHeaderCard, IntervalRow, etc.)
- Check if components are in target

**If this is still blank:**
- The issue is with presentation/navigation
- Check if the sheet is actually showing

### Step 4: Check Workout Data

The workout might have invalid data:

1. Add a breakpoint in `WorkoutDetailView.init`
2. Check if `workout` is valid
3. Check if `workout.intervals` exists and has data

### Step 5: Verify Sheet Presentation

In `WorkoutsView`, check:

1. Is `showingDetail` being set to `true`?
2. Is `selectedWorkout` not nil?
3. Add print statements:
   ```swift
   .onTapGesture {
       print("Tapped workout: \(scheduled.workout.name)")
       selectedWorkout = scheduled.workout
       showingDetail = true
       print("showingDetail set to: \(showingDetail)")
   }
   ```

### Step 6: Check for Missing Dependencies

Verify these exist and are in target:
- ✅ `Workout` model
- ✅ `WorkoutInterval` enum
- ✅ `WorkoutHelpers` (for `formattedDuration`)
- ✅ `Theme` struct
- ✅ `WorkoutsViewModel`

## Common Issues

1. ❌ **Missing navigation title** (FIXED ✅)
2. ❌ **Files not in target** (most common)
3. ❌ **Missing environment object** (FIXED ✅)
4. ❌ **Workout data is nil or invalid**
5. ❌ **Components crashing during render**

## Next Steps

1. **Check Console** first - this will tell you exactly what's wrong
2. **Verify Target Membership** - ensure all files are included
3. **Test with minimal view** - isolate the issue
4. **Check for crashes** - set breakpoints and step through

The blank screen is usually caused by:
- Missing files in target (most common)
- Crash during rendering (check console)
- Missing dependencies

Start with **checking the console** for errors!


