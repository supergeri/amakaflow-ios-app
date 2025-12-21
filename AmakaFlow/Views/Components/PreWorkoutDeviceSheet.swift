//
//  PreWorkoutDeviceSheet.swift
//  AmakaFlow
//
//  Device selection sheet shown before starting a workout
//

import SwiftUI

struct PreWorkoutDeviceSheet: View {
    let workout: Workout
    let appleWatchConnected: Bool
    let garminConnected: Bool
    let amazfitConnected: Bool
    let onSelectDevice: (DevicePreference) -> Void
    let onClose: () -> Void
    let onChangeSettings: () -> Void

    private var deviceOptions: [DeviceOption] {
        [
            DeviceOption(
                preference: .appleWatchPhone,
                connected: appleWatchConnected,
                available: appleWatchConnected
            ),
            DeviceOption(
                preference: .phoneOnly,
                connected: nil,
                available: true
            ),
            DeviceOption(
                preference: .garminPhone,
                connected: garminConnected,
                available: garminConnected
            ),
            DeviceOption(
                preference: .amazfitPhone,
                connected: amazfitConnected,
                available: amazfitConnected
            )
        ]
    }

    private var availableOptions: [DeviceOption] {
        deviceOptions.filter { $0.available }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header

            // Device options
            ScrollView {
                VStack(spacing: Theme.Spacing.sm) {
                    ForEach(availableOptions) { option in
                        DeviceOptionRow(
                            option: option,
                            isRecommended: option.preference == .appleWatchPhone && appleWatchConnected,
                            onSelect: { onSelectDevice(option.preference) }
                        )
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.vertical, Theme.Spacing.lg)
            }

            // Footer
            footer
        }
        .background(Theme.Colors.surface)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Start Workout")
                    .font(Theme.Typography.title2)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("Choose how to follow along")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.textSecondary)
                    .frame(width: 36, height: 36)
                    .background(Theme.Colors.surfaceElevated)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.md))
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.vertical, Theme.Spacing.lg)
        .background(Theme.Colors.surface)
        .overlay(
            Rectangle()
                .fill(Theme.Colors.borderLight)
                .frame(height: 1),
            alignment: .bottom
        )
    }

    // MARK: - Footer

    private var footer: some View {
        Button(action: onChangeSettings) {
            Text("Change default in Settings →")
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(.vertical, Theme.Spacing.md)
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.surface)
        .overlay(
            Rectangle()
                .fill(Theme.Colors.borderLight)
                .frame(height: 1),
            alignment: .top
        )
    }
}

// MARK: - Device Option Model

private struct DeviceOption: Identifiable {
    let preference: DevicePreference
    let connected: Bool?
    let available: Bool

    var id: String { preference.id }
}

// MARK: - Device Option Row

private struct DeviceOptionRow: View {
    let option: DeviceOption
    let isRecommended: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: Theme.Spacing.md) {
                // Icon
                deviceIcon

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: Theme.Spacing.sm) {
                        Text(option.preference.title)
                            .font(Theme.Typography.bodyBold)
                            .foregroundColor(Theme.Colors.textPrimary)

                        if isRecommended {
                            Text("Recommended")
                                .font(Theme.Typography.footnote)
                                .foregroundColor(Theme.Colors.accentBlue)
                                .padding(.horizontal, Theme.Spacing.sm)
                                .padding(.vertical, 2)
                                .background(Theme.Colors.accentBlue.opacity(0.1))
                                .cornerRadius(Theme.CornerRadius.sm)
                        }

                        if option.connected == true {
                            Text("Connected")
                                .font(Theme.Typography.footnote)
                                .foregroundColor(option.preference.accentColor)
                                .padding(.horizontal, Theme.Spacing.sm)
                                .padding(.vertical, 2)
                                .background(option.preference.accentColor.opacity(0.1))
                                .cornerRadius(Theme.CornerRadius.sm)
                        }
                    }

                    Text(option.preference.subtitle)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.textTertiary)
            }
            .padding(Theme.Spacing.md)
            .background(Theme.Colors.surfaceElevated)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                    .stroke(Theme.Colors.borderLight, lineWidth: 1)
            )
            .cornerRadius(Theme.CornerRadius.md)
        }
        .buttonStyle(.plain)
    }

    private var deviceIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                .fill(option.preference.accentColor.opacity(0.1))
                .frame(width: 48, height: 48)

            Image(systemName: option.preference.iconName)
                .font(.system(size: 22))
                .foregroundColor(option.preference.accentColor)

            // Phone badge for watch + phone options
            if option.preference != .phoneOnly && option.preference != .appleWatchOnly {
                Image(systemName: "iphone")
                    .font(.system(size: 10))
                    .foregroundColor(option.preference.accentColor)
                    .padding(3)
                    .background(Theme.Colors.surfaceElevated)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Theme.Colors.borderLight, lineWidth: 1)
                    )
                    .offset(x: 14, y: 14)
            }

            // Connection indicator
            if option.connected == true {
                Circle()
                    .fill(option.preference.accentColor)
                    .frame(width: 10, height: 10)
                    .overlay(
                        Circle()
                            .stroke(Theme.Colors.surfaceElevated, lineWidth: 2)
                    )
                    .offset(x: 16, y: -16)
            }
        }
        .frame(width: 48, height: 48)
    }
}

// MARK: - Preview

#Preview {
    PreWorkoutDeviceSheet(
        workout: Workout(
            name: "Full Body Strength",
            sport: .strength,
            duration: 1800,
            intervals: [],
            description: nil,
            source: .coach
        ),
        appleWatchConnected: true,
        garminConnected: false,
        amazfitConnected: false,
        onSelectDevice: { _ in },
        onClose: {},
        onChangeSettings: {}
    )
    .presentationDetents([.medium])
    .preferredColorScheme(.dark)
}
