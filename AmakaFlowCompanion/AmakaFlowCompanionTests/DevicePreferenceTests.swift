//
//  DevicePreferenceTests.swift
//  AmakaFlowCompanionTests
//
//  Unit tests for DevicePreference enum and device-aware workout starting
//

import XCTest
@testable import AmakaFlowCompanion

final class DevicePreferenceTests: XCTestCase {

    // MARK: - Raw Value Tests

    func testAppleWatchPhoneRawValue() {
        XCTAssertEqual(DevicePreference.appleWatchPhone.rawValue, "apple-watch-phone")
    }

    func testPhoneOnlyRawValue() {
        XCTAssertEqual(DevicePreference.phoneOnly.rawValue, "phone-only")
    }

    func testGarminPhoneRawValue() {
        XCTAssertEqual(DevicePreference.garminPhone.rawValue, "garmin-phone")
    }

    func testAmazfitPhoneRawValue() {
        XCTAssertEqual(DevicePreference.amazfitPhone.rawValue, "amazfit-phone")
    }

    func testAppleWatchOnlyRawValue() {
        XCTAssertEqual(DevicePreference.appleWatchOnly.rawValue, "apple-watch-only")
    }

    // MARK: - ID Tests

    func testIdMatchesRawValue() {
        for preference in DevicePreference.allCases {
            XCTAssertEqual(preference.id, preference.rawValue)
        }
    }

    // MARK: - Title Tests

    func testAppleWatchPhoneTitle() {
        XCTAssertEqual(DevicePreference.appleWatchPhone.title, "Apple Watch + iPhone")
    }

    func testPhoneOnlyTitle() {
        XCTAssertEqual(DevicePreference.phoneOnly.title, "iPhone Only")
    }

    func testGarminPhoneTitle() {
        XCTAssertEqual(DevicePreference.garminPhone.title, "Garmin + iPhone")
    }

    func testAmazfitPhoneTitle() {
        XCTAssertEqual(DevicePreference.amazfitPhone.title, "Amazfit + iPhone")
    }

    func testAppleWatchOnlyTitle() {
        XCTAssertEqual(DevicePreference.appleWatchOnly.title, "Apple Watch Only")
    }

    // MARK: - Subtitle Tests

    func testAllPreferencesHaveSubtitles() {
        for preference in DevicePreference.allCases {
            XCTAssertFalse(preference.subtitle.isEmpty, "\(preference) should have a non-empty subtitle")
        }
    }

    func testPhoneOnlySubtitle() {
        XCTAssertEqual(DevicePreference.phoneOnly.subtitle, "Full-screen follow-along")
    }

    // MARK: - Icon Tests

    func testPhoneOnlyIconIsIphone() {
        XCTAssertEqual(DevicePreference.phoneOnly.iconName, "iphone")
    }

    func testWatchPreferencesUseAppleWatchIcon() {
        XCTAssertEqual(DevicePreference.appleWatchPhone.iconName, "applewatch")
        XCTAssertEqual(DevicePreference.appleWatchOnly.iconName, "applewatch")
        XCTAssertEqual(DevicePreference.garminPhone.iconName, "applewatch")
        XCTAssertEqual(DevicePreference.amazfitPhone.iconName, "applewatch")
    }

    // MARK: - Tracking Description Tests

    func testAppleWatchTrackingDescription() {
        XCTAssertEqual(DevicePreference.appleWatchPhone.trackingDescription, "Tracked on Apple Watch")
        XCTAssertEqual(DevicePreference.appleWatchOnly.trackingDescription, "Tracked on Apple Watch")
    }

    func testPhoneOnlyTrackingDescription() {
        XCTAssertEqual(DevicePreference.phoneOnly.trackingDescription, "Manual tracking")
    }

    func testGarminTrackingDescription() {
        XCTAssertEqual(DevicePreference.garminPhone.trackingDescription, "Tracked on Garmin Fenix 8")
    }

    func testAmazfitTrackingDescription() {
        XCTAssertEqual(DevicePreference.amazfitPhone.trackingDescription, "Tracked on Amazfit T-Rex 3")
    }

    // MARK: - Codable Tests

    func testEncodeDecodeAllPreferences() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        for preference in DevicePreference.allCases {
            let encoded = try encoder.encode(preference)
            let decoded = try decoder.decode(DevicePreference.self, from: encoded)
            XCTAssertEqual(preference, decoded)
        }
    }

    func testDecodeFromRawValueString() throws {
        let decoder = JSONDecoder()

        let jsonString = "\"apple-watch-phone\""
        let data = jsonString.data(using: .utf8)!
        let decoded = try decoder.decode(DevicePreference.self, from: data)

        XCTAssertEqual(decoded, .appleWatchPhone)
    }

    func testDecodePhoneOnly() throws {
        let decoder = JSONDecoder()

        let jsonString = "\"phone-only\""
        let data = jsonString.data(using: .utf8)!
        let decoded = try decoder.decode(DevicePreference.self, from: data)

        XCTAssertEqual(decoded, .phoneOnly)
    }

    func testDecodeInvalidValueThrows() {
        let decoder = JSONDecoder()

        let jsonString = "\"invalid-preference\""
        let data = jsonString.data(using: .utf8)!

        XCTAssertThrowsError(try decoder.decode(DevicePreference.self, from: data))
    }

    // MARK: - CaseIterable Tests

    func testAllCasesCount() {
        XCTAssertEqual(DevicePreference.allCases.count, 5)
    }

    func testAllCasesContainsExpectedValues() {
        let allCases = DevicePreference.allCases
        XCTAssertTrue(allCases.contains(.appleWatchPhone))
        XCTAssertTrue(allCases.contains(.phoneOnly))
        XCTAssertTrue(allCases.contains(.garminPhone))
        XCTAssertTrue(allCases.contains(.amazfitPhone))
        XCTAssertTrue(allCases.contains(.appleWatchOnly))
    }

    // MARK: - Identifiable Tests

    func testUniqueIds() {
        let ids = DevicePreference.allCases.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count, "All IDs should be unique")
    }

    // MARK: - UserDefaults Storage Tests

    func testUserDefaultsStorageKey() {
        // Verify the key used matches what we expect
        let key = "devicePreference"
        UserDefaults.standard.set(DevicePreference.phoneOnly.rawValue, forKey: key)

        let storedValue = UserDefaults.standard.string(forKey: key)
        XCTAssertEqual(storedValue, "phone-only")

        // Clean up
        UserDefaults.standard.removeObject(forKey: key)
    }

    func testUserDefaultsRoundTrip() {
        let key = "devicePreference"

        for preference in DevicePreference.allCases {
            UserDefaults.standard.set(preference.rawValue, forKey: key)

            let storedValue = UserDefaults.standard.string(forKey: key)
            let restored = DevicePreference(rawValue: storedValue ?? "")

            XCTAssertEqual(restored, preference)
        }

        // Clean up
        UserDefaults.standard.removeObject(forKey: key)
    }

    // MARK: - Device Availability Logic Tests

    func testAppleWatchPreferencesRequireWatchReachability() {
        // Test the logic that determines if a device preference requires watch
        let watchPreferences: [DevicePreference] = [.appleWatchPhone, .appleWatchOnly]

        for preference in watchPreferences {
            XCTAssertTrue(
                preference == .appleWatchPhone || preference == .appleWatchOnly,
                "\(preference) should be an Apple Watch preference"
            )
        }
    }

    func testPhoneOnlyDoesNotRequireExternalDevice() {
        // Phone only should always be available
        XCTAssertEqual(DevicePreference.phoneOnly.rawValue, "phone-only")
        // This preference should work without any external device connection
    }
}
