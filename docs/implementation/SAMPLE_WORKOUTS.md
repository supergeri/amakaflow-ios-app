# Sample Workout Data

This file contains sample workout data for testing the AmakaFlow Companion iOS app.

## Sample Workout 1: Full Body Strength

**Description**: Complete full body workout with compound movements

**WorkoutKit DTO Format** (for WorkoutKitSync):
```json
{
  "title": "Full Body Strength Workout",
  "sportType": "strengthTraining",
  "intervals": [
    {
      "kind": "warmup",
      "seconds": 300,
      "target": null
    },
    {
      "kind": "reps",
      "reps": 8,
      "name": "Squat",
      "load": null,
      "restSec": 90
    },
    {
      "kind": "reps",
      "reps": 8,
      "name": "Bench Press",
      "load": null,
      "restSec": 90
    },
    {
      "kind": "reps",
      "reps": 8,
      "name": "Romanian Deadlift",
      "load": null,
      "restSec": 90
    },
    {
      "kind": "repeat",
      "reps": 3,
      "intervals": [
        {
          "kind": "reps",
          "reps": 10,
          "name": "Dumbbell Row",
          "load": null,
          "restSec": 60
        },
        {
          "kind": "time",
          "seconds": 60,
          "target": null
        },
        {
          "kind": "reps",
          "reps": 12,
          "name": "Push Up",
          "load": null,
          "restSec": null
        }
      ]
    },
    {
      "kind": "cooldown",
      "seconds": 300,
      "target": null
    }
  ],
  "schedule": null
}
```

**Swift Workout Model** (for app):
```swift
let sampleWorkout1 = Workout(
    name: "Full Body Strength Workout",
    sport: .strength,
    duration: 1890,
    intervals: [
        .warmup(seconds: 300, target: nil),
        .reps(reps: 8, name: "Squat", load: nil, restSec: 90),
        .reps(reps: 8, name: "Bench Press", load: nil, restSec: 90),
        .reps(reps: 8, name: "Romanian Deadlift", load: nil, restSec: 90),
        .repeat(reps: 3, intervals: [
            .reps(reps: 10, name: "Dumbbell Row", load: nil, restSec: 60),
            .time(seconds: 60, target: nil),
            .reps(reps: 12, name: "Push Up", load: nil, restSec: nil)
        ]),
        .cooldown(seconds: 300, target: nil)
    ],
    description: "Complete full body workout with compound movements",
    source: .coach
)
```

## Sample Workout 2: Upper Body Push Day

**Description**: Focus on chest, shoulders, and triceps

**WorkoutKit DTO Format**:
```json
{
  "title": "Upper Body Push Day",
  "sportType": "strengthTraining",
  "intervals": [
    {
      "kind": "repeat",
      "reps": 4,
      "intervals": [
        {
          "kind": "reps",
          "reps": 6,
          "name": "Bench Press",
          "load": null,
          "restSec": 120
        },
        {
          "kind": "time",
          "seconds": 120,
          "target": null
        },
        {
          "kind": "reps",
          "reps": 8,
          "name": "Overhead Press",
          "load": null,
          "restSec": 90
        }
      ]
    },
    {
      "kind": "repeat",
      "reps": 3,
      "intervals": [
        {
          "kind": "reps",
          "reps": 10,
          "name": "Incline Dumbbell Press",
          "load": null,
          "restSec": 60
        },
        {
          "kind": "time",
          "seconds": 60,
          "target": null
        },
        {
          "kind": "reps",
          "reps": 12,
          "name": "Tricep Dips",
          "load": null,
          "restSec": null
        }
      ]
    }
  ],
  "schedule": null
}
```

**Swift Workout Model**:
```swift
let sampleWorkout2 = Workout(
    name: "Upper Body Push Day",
    sport: .strength,
    duration: 2280,
    intervals: [
        .repeat(reps: 4, intervals: [
            .reps(reps: 6, name: "Bench Press", load: nil, restSec: 120),
            .time(seconds: 120, target: nil),
            .reps(reps: 8, name: "Overhead Press", load: nil, restSec: 90)
        ]),
        .repeat(reps: 3, intervals: [
            .reps(reps: 10, name: "Incline Dumbbell Press", load: nil, restSec: 60),
            .time(seconds: 60, target: nil),
            .reps(reps: 12, name: "Tricep Dips", load: nil, restSec: nil)
        ])
    ],
    description: "Focus on chest, shoulders, and triceps",
    source: .coach
)
```

## Sample Workout 3: Running Intervals

**Description**: Speed work for endurance

**WorkoutKit DTO Format**:
```json
{
  "title": "Tuesday Speed Work",
  "sportType": "running",
  "intervals": [
    {
      "kind": "warmup",
      "seconds": 600,
      "target": null
    },
    {
      "kind": "repeat",
      "reps": 6,
      "intervals": [
        {
          "kind": "distance",
          "meters": 400,
          "target": null
        },
        {
          "kind": "time",
          "seconds": 120,
          "target": null
        }
      ]
    },
    {
      "kind": "cooldown",
      "seconds": 600,
      "target": null
    }
  ],
  "schedule": null
}
```

**Swift Workout Model**:
```swift
let sampleWorkout3 = Workout(
    name: "Tuesday Speed Work",
    sport: .running,
    duration: 2640,
    intervals: [
        .warmup(seconds: 600, target: nil),
        .repeat(reps: 6, intervals: [
            .distance(meters: 400, target: nil),
            .time(seconds: 120, target: nil)
        ]),
        .cooldown(seconds: 600, target: nil)
    ],
    description: "400m repeats for speed endurance",
    source: .coach
)
```

## Testing Instructions

1. **Add to App**: Use the "Add Sample Workout" button in `WorkoutsView`
2. **Test WorkoutKit Sync**: Tap "Save to Apple Fitness" in `WorkoutDetailView`
3. **Test Watch Sync**: Tap "Start on Apple Watch" to send workout to Watch
4. **Test Calendar Sync**: Tap "Schedule to Calendar" to add workout to Calendar

## API Endpoints

For future API integration:

- **GET /workouts**: Fetch user's workouts from mapper-api
- **GET /export/apple/{workoutId}**: Get workout in WorkoutKit DTO format
- **POST /workouts**: Save workout to backend

See `IOS_TRANSFER_GUIDE.md` for full API documentation.

