//
//  WorkoutCompletionViewModelTests.swift
//  AmakaFlowCompanionTests
//
//  Unit tests for WorkoutCompletionViewModel
//

import XCTest
@testable import AmakaFlowCompanion

@MainActor
final class WorkoutCompletionViewModelTests: XCTestCase {

    override func setUp() async throws {
        // Give the app initialization time to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }

    // MARK: - Duration Formatting Tests

    func testFormattedDurationMinutesOnly() {
        let viewModel = createViewModel(durationSeconds: 300) // 5 minutes
        XCTAssertEqual(viewModel.formattedDuration, "5m 0s")
    }

    func testFormattedDurationMinutesAndSeconds() {
        let viewModel = createViewModel(durationSeconds: 185) // 3m 5s
        XCTAssertEqual(viewModel.formattedDuration, "3m 5s")
    }

    func testFormattedDurationWithHours() {
        let viewModel = createViewModel(durationSeconds: 3725) // 1h 2m 5s
        XCTAssertEqual(viewModel.formattedDuration, "1h 2m 5s")
    }

    func testFormattedDurationZeroSeconds() {
        let viewModel = createViewModel(durationSeconds: 0)
        XCTAssertEqual(viewModel.formattedDuration, "0m 0s")
    }

    // MARK: - Heart Rate Data Detection Tests

    func testHasHeartRateDataWithAvgHR() {
        let viewModel = createViewModel(avgHeartRate: 140)
        XCTAssertTrue(viewModel.hasHeartRateData)
    }

    func testHasHeartRateDataWithSamples() {
        let samples = createSamples(count: 5, baseValue: 130)
        let viewModel = createViewModel(heartRateSamples: samples)
        XCTAssertTrue(viewModel.hasHeartRateData)
    }

    func testHasNoHeartRateData() {
        let viewModel = createViewModel(avgHeartRate: nil, heartRateSamples: [])
        XCTAssertFalse(viewModel.hasHeartRateData)
    }

    // MARK: - Avg Heart Rate Calculation Tests

    func testCalculatedAvgHeartRateUsesProvidedValue() {
        let samples = createSamples(count: 5, baseValue: 100)
        let viewModel = createViewModel(avgHeartRate: 150, heartRateSamples: samples)
        XCTAssertEqual(viewModel.calculatedAvgHeartRate, 150)
    }

    func testCalculatedAvgHeartRateFromSamples() {
        let samples = [
            HeartRateSample(timestamp: Date(), value: 100),
            HeartRateSample(timestamp: Date(), value: 120),
            HeartRateSample(timestamp: Date(), value: 140)
        ]
        let viewModel = createViewModel(avgHeartRate: nil, heartRateSamples: samples)
        XCTAssertEqual(viewModel.calculatedAvgHeartRate, 120)
    }

    func testCalculatedAvgHeartRateNoData() {
        let viewModel = createViewModel(avgHeartRate: nil, heartRateSamples: [])
        XCTAssertNil(viewModel.calculatedAvgHeartRate)
    }

    // MARK: - Max Heart Rate Calculation Tests

    func testCalculatedMaxHeartRateUsesProvidedValue() {
        let samples = createSamples(count: 5, baseValue: 100)
        let viewModel = createViewModel(maxHeartRate: 180, heartRateSamples: samples)
        XCTAssertEqual(viewModel.calculatedMaxHeartRate, 180)
    }

    func testCalculatedMaxHeartRateFromSamples() {
        let samples = [
            HeartRateSample(timestamp: Date(), value: 100),
            HeartRateSample(timestamp: Date(), value: 175),
            HeartRateSample(timestamp: Date(), value: 140)
        ]
        let viewModel = createViewModel(maxHeartRate: nil, heartRateSamples: samples)
        XCTAssertEqual(viewModel.calculatedMaxHeartRate, 175)
    }

    func testCalculatedMaxHeartRateNoData() {
        let viewModel = createViewModel(maxHeartRate: nil, heartRateSamples: [])
        XCTAssertNil(viewModel.calculatedMaxHeartRate)
    }

    // MARK: - Edge Cases

    func testSingleSampleAvgAndMax() {
        let samples = [HeartRateSample(timestamp: Date(), value: 142)]
        let viewModel = createViewModel(avgHeartRate: nil, maxHeartRate: nil, heartRateSamples: samples)
        XCTAssertEqual(viewModel.calculatedAvgHeartRate, 142)
        XCTAssertEqual(viewModel.calculatedMaxHeartRate, 142)
    }

    // MARK: - Helper Methods

    private func createViewModel(
        workoutName: String = "Test Workout",
        durationSeconds: Int = 1800,
        calories: Int? = nil,
        avgHeartRate: Int? = nil,
        maxHeartRate: Int? = nil,
        heartRateSamples: [HeartRateSample] = []
    ) -> WorkoutCompletionViewModel {
        WorkoutCompletionViewModel(
            workoutName: workoutName,
            durationSeconds: durationSeconds,
            deviceMode: .phoneOnly,
            calories: calories,
            avgHeartRate: avgHeartRate,
            maxHeartRate: maxHeartRate,
            heartRateSamples: heartRateSamples,
            onDismiss: nil
        )
    }

    private func createSamples(count: Int, baseValue: Int) -> [HeartRateSample] {
        (0..<count).map { i in
            HeartRateSample(
                timestamp: Date().addingTimeInterval(Double(i) * 5),
                value: baseValue + (i * 5)
            )
        }
    }
}
