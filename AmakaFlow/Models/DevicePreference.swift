//
//  DevicePreference.swift
//  AmakaFlow
//
//  Device preference options for workout tracking
//

import SwiftUI

/// Represents the user's preferred device configuration for workouts
enum DevicePreference: String, Codable, CaseIterable, Identifiable {
    case appleWatchPhone = "apple-watch-phone"
    case phoneOnly = "phone-only"
    case garminPhone = "garmin-phone"
    case amazfitPhone = "amazfit-phone"
    case appleWatchOnly = "apple-watch-only"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .appleWatchPhone: return "Apple Watch + iPhone"
        case .phoneOnly: return "iPhone Only"
        case .garminPhone: return "Garmin + iPhone"
        case .amazfitPhone: return "Amazfit + iPhone"
        case .appleWatchOnly: return "Apple Watch Only"
        }
    }

    var subtitle: String {
        switch self {
        case .appleWatchPhone: return "Watch tracks • Phone guides"
        case .phoneOnly: return "Full-screen follow-along"
        case .garminPhone: return "Fenix 8 • Follow on phone"
        case .amazfitPhone: return "T-Rex 3 • Follow on phone"
        case .appleWatchOnly: return "Independent watch workout"
        }
    }

    var accentColor: Color {
        switch self {
        case .appleWatchPhone, .appleWatchOnly: return Theme.Colors.accentGreen
        case .phoneOnly: return Theme.Colors.accentBlue
        case .garminPhone: return Theme.Colors.garminBlue
        case .amazfitPhone: return Theme.Colors.amazfitOrange
        }
    }

    var iconName: String {
        switch self {
        case .appleWatchPhone, .garminPhone, .amazfitPhone, .appleWatchOnly:
            return "applewatch"
        case .phoneOnly:
            return "iphone"
        }
    }

    var trackingDescription: String {
        switch self {
        case .appleWatchPhone, .appleWatchOnly: return "Tracked on Apple Watch"
        case .phoneOnly: return "Manual tracking"
        case .garminPhone: return "Tracked on Garmin Fenix 8"
        case .amazfitPhone: return "Tracked on Amazfit T-Rex 3"
        }
    }
}
