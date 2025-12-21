//
//  Theme.swift
//  AmakaFlow
//
//  Design system matching Figma specifications
//

import SwiftUI

struct Theme {
    // MARK: - Colors
    struct Colors {
        // Primary
        static let background = Color(hex: "0D0D0F")
        static let surface = Color(hex: "1A1A1E")
        static let surfaceElevated = Color(hex: "25252A")
        
        // Text
        static let textPrimary = Color.white
        static let textSecondary = Color(hex: "9CA3AF")
        static let textTertiary = Color(hex: "6B7280")
        
        // Accents
        static let accentBlue = Color(hex: "3A8BFF")
        static let accentGreen = Color(hex: "4EDF9B")
        static let accentRed = Color(hex: "EF4444")
        static let accentOrange = Color(hex: "F97316")

        // Device brand colors
        static let garminBlue = Color(hex: "007ACC")
        static let amazfitOrange = Color(hex: "FF6B00")
        
        // Borders
        static let borderLight = Color(hex: "2D2D32")
        static let borderMedium = Color(hex: "3F3F46")
    }
    
    // MARK: - Typography
    struct Typography {
        // Display
        static let largeTitle = Font.system(size: 32, weight: .bold, design: .default)
        static let title1 = Font.system(size: 24, weight: .semibold, design: .default)
        static let title2 = Font.system(size: 20, weight: .semibold, design: .default)
        static let title3 = Font.system(size: 17, weight: .semibold, design: .default)
        
        // Body
        static let body = Font.system(size: 15, weight: .regular, design: .default)
        static let bodyBold = Font.system(size: 15, weight: .semibold, design: .default)
        static let caption = Font.system(size: 13, weight: .regular, design: .default)
        static let captionBold = Font.system(size: 13, weight: .medium, design: .default)
        static let footnote = Font.system(size: 12, weight: .regular, design: .default)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
