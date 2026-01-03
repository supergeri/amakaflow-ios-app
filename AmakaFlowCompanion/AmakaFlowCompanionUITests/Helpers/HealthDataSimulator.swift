//
//  HealthDataSimulator.swift
//  AmakaFlowCompanionUITests
//
//  Helper for simulating health data in E2E tests (AMA-232)
//  Note: For full HealthKit injection, add XCTHealthKit package to the UITests target
//

import XCTest

/// Helper for simulating health data in tests
/// For full HealthKit sample injection, install XCTHealthKit:
/// https://github.com/StanfordBDHG/XCTHealthKit
enum HealthDataSimulator {

    // MARK: - XCTHealthKit Integration (when available)

    /// Inject health samples using XCTHealthKit
    /// This requires XCTHealthKit to be added as a Swift Package dependency
    ///
    /// To add XCTHealthKit:
    /// 1. Open project in Xcode
    /// 2. File > Add Package Dependencies
    /// 3. Enter: https://github.com/StanfordBDHG/XCTHealthKit.git
    /// 4. Add to: AmakaFlowCompanionUITests target
    ///
    /// Example usage after adding XCTHealthKit:
    /// ```swift
    /// import XCTHealthKit
    ///
    /// let healthApp = XCUIApplication.healthApp
    /// try launchAndAddSamples(healthApp: healthApp, [
    ///     .restingHeartRate(value: 68),
    ///     .activeEnergy(value: 150),
    ///     .steps(value: 500)
    /// ])
    /// ```

    // MARK: - Simulated Heart Rate Curve

    /// Generate simulated heart rate values for a workout
    /// - Parameters:
    ///   - duration: Workout duration in seconds
    ///   - restingBPM: Starting/resting heart rate
    ///   - peakBPM: Peak heart rate during workout
    ///   - sampleInterval: Interval between samples in seconds
    /// - Returns: Array of (timestamp, heartRate) tuples
    static func generateHeartRateCurve(
        duration: TimeInterval,
        restingBPM: Double = 70,
        peakBPM: Double = 150,
        sampleInterval: TimeInterval = 5
    ) -> [(timestamp: TimeInterval, heartRate: Double)] {
        var samples: [(TimeInterval, Double)] = []
        var currentTime: TimeInterval = 0

        // Phases of a typical workout:
        // 1. Warmup (20% of duration): gradual increase from resting to 70% of peak
        // 2. Main workout (60% of duration): between 70-100% of peak
        // 3. Cooldown (20% of duration): gradual decrease back to near resting

        let warmupEnd = duration * 0.2
        let mainEnd = duration * 0.8
        let warmupTarget = restingBPM + (peakBPM - restingBPM) * 0.7

        while currentTime <= duration {
            let hr: Double

            if currentTime < warmupEnd {
                // Warmup phase: linear increase
                let progress = currentTime / warmupEnd
                hr = restingBPM + (warmupTarget - restingBPM) * progress
            } else if currentTime < mainEnd {
                // Main workout: oscillate between warmup target and peak
                let phaseProgress = (currentTime - warmupEnd) / (mainEnd - warmupEnd)
                let oscillation = sin(phaseProgress * .pi * 4) * 0.15  // Some variation
                hr = warmupTarget + (peakBPM - warmupTarget) * (0.5 + oscillation)
            } else {
                // Cooldown: linear decrease
                let progress = (currentTime - mainEnd) / (duration - mainEnd)
                let cooldownStart = warmupTarget + (peakBPM - warmupTarget) * 0.5
                hr = cooldownStart - (cooldownStart - restingBPM - 10) * progress
            }

            // Add some natural variation (±3 BPM)
            let variation = Double.random(in: -3...3)
            samples.append((currentTime, max(restingBPM, hr + variation)))

            currentTime += sampleInterval
        }

        return samples
    }

    // MARK: - Mock Data for UI Testing

    /// Generate mock workout summary data
    static func mockWorkoutSummary(duration: TimeInterval = 1800) -> [String: Any] {
        let hrCurve = generateHeartRateCurve(duration: duration)
        let avgHR = hrCurve.map(\.heartRate).reduce(0, +) / Double(hrCurve.count)
        let maxHR = hrCurve.map(\.heartRate).max() ?? 150

        return [
            "duration": duration,
            "averageHeartRate": Int(avgHR),
            "maxHeartRate": Int(maxHR),
            "activeCalories": Int(duration * 0.15),  // ~270 kcal for 30 min
            "totalCalories": Int(duration * 0.2),    // ~360 kcal for 30 min
            "startDate": Date().addingTimeInterval(-duration),
            "endDate": Date()
        ]
    }
}

// MARK: - XCTHealthKit Extensions (uncomment after adding package)

/*
 After adding XCTHealthKit as a dependency, uncomment this extension:

 import XCTHealthKit

 extension HealthDataSimulator {

     /// Launch Health app and add samples for testing
     static func injectHealthSamples(
         _ samples: [HealthSample],
         for app: XCUIApplication
     ) throws {
         let healthApp = XCUIApplication.healthApp
         try launchAndAddSamples(healthApp: healthApp, samples)
         app.activate()
     }

     /// Sample presets for common test scenarios
     enum TestScenario {
         case restingState
         case duringWorkout
         case postWorkout

         var samples: [HealthSample] {
             switch self {
             case .restingState:
                 return [
                     .restingHeartRate(value: 65),
                     .steps(value: 1000),
                     .activeEnergy(value: 50)
                 ]
             case .duringWorkout:
                 return [
                     .heartRate(value: 145),
                     .activeEnergy(value: 200),
                     .steps(value: 3000)
                 ]
             case .postWorkout:
                 return [
                     .heartRate(value: 85),
                     .activeEnergy(value: 350),
                     .steps(value: 5000)
                 ]
             }
         }
     }
 }
 */
