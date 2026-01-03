# AmakaFlow E2E UI Tests

Automated end-to-end testing for AmakaFlow Companion iOS app (AMA-232).

## Quick Start

### 1. Setup Test Credentials

Copy the example credentials file and add your test JWT:

```bash
cp AmakaFlowCompanionUITests/TestCredentials.example.swift AmakaFlowCompanionUITests/TestCredentials.swift
```

Then edit `TestCredentials.swift` with your test account JWT.

To generate a test JWT (from mapper-api directory):

```bash
python3 -c "
import jwt
from datetime import datetime, timedelta, timezone
JWT_SECRET = 'amakaflow-mobile-jwt-secret-change-in-production'
now = datetime.now(timezone.utc)
expiry = now + timedelta(days=365)
payload = {
    'sub': 'YOUR_TEST_USER_ID',
    'iat': int(now.timestamp()),
    'exp': int(expiry.timestamp()),
    'iss': 'amakaflow',
    'aud': 'ios_companion',
    'email': 'YOUR_TEST_EMAIL',
    'name': 'YOUR_TEST_NAME'
}
print(jwt.encode(payload, JWT_SECRET, algorithm='HS256'))
"
```

### 2. Run Tests from Command Line

```bash
# Run all E2E tests
xcodebuild test \
    -project AmakaFlowCompanion.xcodeproj \
    -scheme AmakaFlowCompanion \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -only-testing:AmakaFlowCompanionUITests

# Run specific test class
xcodebuild test \
    -project AmakaFlowCompanion.xcodeproj \
    -scheme AmakaFlowCompanion \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -only-testing:AmakaFlowCompanionUITests/WorkoutFlowE2ETests

# Run specific test
xcodebuild test \
    -project AmakaFlowCompanion.xcodeproj \
    -scheme AmakaFlowCompanion \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -only-testing:AmakaFlowCompanionUITests/WorkoutFlowE2ETests/testAppLaunchesAuthenticated
```

### 3. Run Tests from Xcode

1. Open `AmakaFlowCompanion.xcodeproj` in Xcode
2. Select an iPhone simulator
3. Press `Cmd+U` to run all tests, or right-click a test to run individually

## Project Structure

```
AmakaFlowCompanionUITests/
├── README.md                           # This file
├── TestCredentials.swift               # Test credentials (gitignored)
├── TestCredentials.example.swift       # Template for credentials
├── AmakaFlowCompanionUITests.swift     # Base UI tests
├── AmakaFlowCompanionUITestsLaunchTests.swift  # Launch tests
├── Helpers/
│   ├── TestAuthHelper.swift            # Auth bypass configuration
│   └── HealthDataSimulator.swift       # Health data simulation
└── E2ETests/
    └── WorkoutFlowE2ETests.swift       # Full workout flow tests
```

## Test Categories

### Base Tests (`AmakaFlowCompanionUITests`)
- App launch verification
- Main content visibility with test credentials
- Launch performance metrics

### Launch Tests (`AmakaFlowCompanionUITestsLaunchTests`)
- Screenshot capture on launch
- Authenticated vs unauthenticated launch states

### E2E Workout Tests (`WorkoutFlowE2ETests`)
- Authenticated app launch
- Workouts list navigation
- Workout selection and detail view
- Starting workout flow
- Performance measurements

## How Auth Bypass Works

The tests use launch arguments and environment variables to bypass the normal pairing flow:

```swift
app.launchArguments = ["--uitesting", "--skip-pairing"]
app.launchEnvironment = [
    "TEST_ACCOUNT_TOKEN": "jwt_token_here",
    "TEST_USER_ID": "user_id",
    "TEST_USER_EMAIL": "email@example.com",
    "TEST_USER_NAME": "Test User"
]
```

In DEBUG builds, the app checks for these arguments and injects the credentials directly into the keychain, bypassing the QR code/short code pairing flow.

## Adding XCTHealthKit (Optional)

For full HealthKit sample injection in simulators:

1. In Xcode: File > Add Package Dependencies
2. Enter: `https://github.com/StanfordBDHG/XCTHealthKit.git`
3. Add to target: `AmakaFlowCompanionUITests`

Then you can inject health samples:

```swift
import XCTHealthKit

let healthApp = XCUIApplication.healthApp
try launchAndAddSamples(healthApp: healthApp, [
    .restingHeartRate(value: 68),
    .activeEnergy(value: 150)
])
```

## Watch Simulator Pairing

To test with a paired Watch simulator:

```bash
# List simulators
xcrun simctl list

# Pair watch to phone (get UDIDs from list output)
xcrun simctl pair <WATCH_UDID> <IPHONE_UDID>

# Boot paired device
xcrun simctl boot <IPHONE_UDID>
```

### WatchConnectivity Limitations in Simulators

| Feature | Simulator Behavior |
|---------|-------------------|
| `isReachable` | Often returns `false` |
| `sendMessage()` | May timeout |
| `transferUserInfo()` | ✅ Works reliably |
| `updateApplicationContext()` | ✅ Works reliably |

Use `transferUserInfo()` and `updateApplicationContext()` for simulator tests.

## Troubleshooting

### Tests fail with "Pairing view shown"
- Ensure `TestCredentials.swift` exists with valid JWT
- Check that the JWT hasn't expired

### "No workout cells found"
- API may be unreachable or returning empty results
- Check network connectivity to staging API
- Verify test account has workouts

### Keychain errors
- Simulator keychain may be in bad state
- Try: Simulator > Device > Erase All Content and Settings

### Screenshots not captured
- Screenshots are saved to test results
- View in Xcode: View > Navigators > Report Navigator
