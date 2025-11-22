# Test Blank Screen - Diagnostic Steps

## Added Debug View

I've added a debug section at the top of `WorkoutDetailView` that will show:
- ✅ "DEBUG: View Loaded" (green text)
- ✅ Workout name
- ✅ Interval count

## Test Steps

### Step 1: Build and Run

1. **Clean Build Folder** (Shift + Cmd + K)
2. **Build** (Cmd + B)
3. **Run** (Cmd + R)

### Step 2: Tap a Workout

1. **Tap any workout** in the list
2. **Look at the detail screen**

### Step 3: What Do You See?

**Scenario A: You see the DEBUG section**
- ✅ View is rendering!
- ✅ Issue is with the content below (WorkoutHeaderCard, etc.)
- **Next**: Check if `WorkoutHeaderCard` is crashing or not visible

**Scenario B: Still completely blank**
- ❌ View isn't rendering at all
- ❌ Sheet might not be presenting
- **Next**: Check sheet presentation

**Scenario C: You see debug text but nothing else**
- ✅ View is rendering
- ❌ Content below debug is invisible/crashing
- **Next**: Check `WorkoutHeaderCard` and components

### Step 4: Check Console (If Still Blank)

1. **Open Console** (Cmd + Shift + Y)
2. **Tap workout**
3. **Look for**:
   - Crash logs
   - Swift runtime errors
   - "Fatal error" messages
   - Any errors mentioning "WorkoutHeaderCard" or "IntervalRow"

### Step 5: Test Sheet Presentation

If debug text doesn't show, verify the sheet is actually presenting:

In `WorkoutsView.swift`, add print statements:

```swift
.onTapGesture {
    print("🔵 TAPPED WORKOUT: \(scheduled.workout.name)")
    selectedWorkout = scheduled.workout
    print("🔵 Selected workout set: \(selectedWorkout?.name ?? "nil")")
    showingDetail = true
    print("🔵 showingDetail set to: \(showingDetail)")
}
```

Then check console when you tap - you should see these print statements.

### Step 6: Simplify View (If Needed)

If debug text shows but content doesn't, temporarily replace the body with just:

```swift
var body: some View {
    NavigationStack {
        VStack {
            Text("Simple Test View")
                .foregroundColor(.white)
                .font(.title)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .navigationTitle(workout.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") { dismiss() }
                    .foregroundColor(.white)
            }
        }
    }
}
```

If this works, the issue is with the complex view. If this is still blank, the issue is with navigation/presentation.

## Most Likely Issues

1. **Sheet not presenting** - `showingDetail` isn't being set properly
2. **View crashing silently** - Components causing crash during render
3. **Layout hiding content** - Content exists but is off-screen or transparent

The debug view should help us identify which one!

## Report Back

After running with the debug view:
1. **Do you see the debug text?** (Yes/No)
2. **What does the console show?** (any errors?)
3. **Is the screen completely black or do you see anything?**

This will help pinpoint the exact issue!


