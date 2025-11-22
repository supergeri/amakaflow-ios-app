# WorkoutDetailView Unit Tests

This test suite ensures the WorkoutDetailView and related components work correctly and remain stable as the codebase evolves.

## Test Coverage

### Workout Model Tests
- ✅ `formattedDuration` - Verifies duration formatting (hours/minutes)
- ✅ `intervalCount` - Verifies correct interval counting
- ✅ Empty intervals handling
- ✅ Valid intervals verification

### WorkoutInterval Tests
- ✅ Warmup interval creation and properties
- ✅ Reps interval creation and properties
- ✅ Repeat interval creation with nested intervals

### WorkoutHelpers Tests
- ✅ `formatDuration` - Formats seconds to human-readable duration
- ✅ `formatDuration` - Handles zero duration
- ✅ `formatDistance` - Formats meters to km/m

### WorkoutsViewModel Tests
- ✅ `filteredUpcoming` - Returns all when search is empty
- ✅ `filteredUpcoming` - Filters by workout name
- ✅ `filteredIncoming` - Returns all when search is empty
- ✅ `filteredIncoming` - Filters correctly
- ✅ Search is case-insensitive

### WorkoutInterval Computed Properties Tests
- ✅ Interval icons for different types (warmup, reps, repeat)

### Workout Sport Type Tests
- ✅ All sport types are valid
- ✅ Raw values are lowercase

### Workout Source Tests
- ✅ All source types are valid

### Edge Cases Tests
- ✅ Very long workout names
- ✅ Workouts with no description
- ✅ Workouts with many intervals (50+)
- ✅ Nested repeat intervals

### Data Integrity Tests
- ✅ Duration consistency
- ✅ Interval order preservation

### ViewModel State Tests
- ✅ Initial state
- ✅ Search query updates

## Running the Tests

### In Xcode
1. Open the project in Xcode
2. Press `Cmd + U` to run all tests
3. Or click the diamond icon next to a specific test

### Via Command Line
```bash
cd amakaflow-ios/AmakaFlowCompanion
xcodebuild test -scheme AmakaFlowCompanion -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Test Structure

Tests are organized by component:
- `WorkoutDetailViewTests` - Main test suite
- Test extensions group related tests together
- Each test function uses `@Test` annotation
- Assertions use `#expect()` from Swift Testing

## Adding New Tests

When adding new features or fixing bugs:

1. **Add a test first** (TDD approach) or add it after fixing
2. **Test the happy path** - Normal usage scenarios
3. **Test edge cases** - Empty data, null values, boundary conditions
4. **Test error cases** - Invalid inputs, failures
5. **Keep tests isolated** - Each test should be independent
6. **Use descriptive names** - Test names should describe what they test

## Test Examples

### Basic Test
```swift
@Test("Workout - formattedDuration formats correctly")
func testWorkoutFormattedDuration() {
    let workout = WorkoutDetailViewTests.makeSampleWorkout()
    let duration = workout.formattedDuration
    
    #expect(duration.contains("31") || duration.contains("32"))
}
```

### Edge Case Test
```swift
@Test("WorkoutDetailView - handles workout with very long name")
func testLongWorkoutName() {
    let longName = String(repeating: "A", count: 100)
    let workout = Workout(/* ... */)
    
    #expect(workout.name == longName)
    #expect(workout.name.count == 100)
}
```

## Maintaining Tests

- ✅ Run tests before committing changes
- ✅ Ensure all tests pass before merging PRs
- ✅ Update tests when changing behavior
- ✅ Add tests for bug fixes to prevent regression
- ✅ Keep test data up-to-date with actual data structures

## Notes

- Tests use Swift Testing framework (iOS 18.0+)
- Tests are marked with `@MainActor` when needed for ViewModel tests
- Sample data is created via helper methods for reusability
- Tests focus on logic and computed properties, not UI rendering


