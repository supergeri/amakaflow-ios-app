//
//  WorkoutCompleteView.swift
//  AmakaFlow
//
//  Celebration screen shown after completing a workout
//

import SwiftUI

struct WorkoutCompleteView: View {
    let workout: Workout
    let elapsedTime: Int
    let deviceMode: DevicePreference
    let calories: Int?
    let avgHeartRate: Int?
    let onClose: () -> Void
    let onShare: (() -> Void)?
    let onViewInHealth: (() -> Void)?

    @State private var showPulse = true

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    Spacer(minLength: Theme.Spacing.xl)

                    // Success icon
                    successIcon

                    // Title and workout name
                    VStack(spacing: Theme.Spacing.sm) {
                        Text("Workout Complete!")
                            .font(Theme.Typography.title1)
                            .foregroundColor(Theme.Colors.textPrimary)

                        Text(workout.name)
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }

                    // Stats grid
                    statsGrid

                    // Device tracking badge
                    deviceBadge

                    Spacer(minLength: Theme.Spacing.xl)

                    // Action buttons
                    actionButtons

                    // View in Health link
                    healthLink
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.vertical, Theme.Spacing.xl)
            }
        }
        .onAppear {
            // Stop pulse animation after initial effect
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showPulse = false
                }
            }
        }
    }

    // MARK: - Success Icon

    private var successIcon: some View {
        ZStack {
            // Pulse animation
            if showPulse {
                Circle()
                    .fill(Theme.Colors.accentGreen.opacity(0.3))
                    .frame(width: 128, height: 128)
                    .scaleEffect(showPulse ? 1.3 : 1)
                    .opacity(showPulse ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.5).repeatForever(autoreverses: false),
                        value: showPulse
                    )
            }

            // Outer ring
            Circle()
                .fill(Theme.Colors.accentGreen.opacity(0.2))
                .frame(width: 128, height: 128)

            // Inner circle
            Circle()
                .fill(Theme.Colors.accentGreen)
                .frame(width: 96, height: 96)

            // Checkmark
            Image(systemName: "checkmark")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
        }
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: Theme.Spacing.sm),
            GridItem(.flexible(), spacing: Theme.Spacing.sm)
        ]

        return LazyVGrid(columns: columns, spacing: Theme.Spacing.sm) {
            // Duration
            StatCard(
                icon: "clock",
                iconColor: Theme.Colors.accentBlue,
                label: "Duration",
                value: formatTime(elapsedTime)
            )

            // Exercises
            StatCard(
                icon: "bolt.fill",
                iconColor: Theme.Colors.accentGreen,
                label: "Exercises",
                value: "\(totalExercises)/\(totalExercises) completed"
            )

            // Calories (if available)
            if let calories = calories {
                StatCard(
                    icon: "flame.fill",
                    iconColor: Theme.Colors.accentOrange,
                    label: "Calories",
                    value: "\(calories) kcal"
                )
            }

            // Avg Heart Rate (if available)
            if let avgHeartRate = avgHeartRate {
                StatCard(
                    icon: "heart.fill",
                    iconColor: Theme.Colors.accentRed,
                    label: "Avg HR",
                    value: "\(avgHeartRate) bpm"
                )
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
    }

    // MARK: - Device Badge

    private var deviceBadge: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: deviceMode.iconName)
                .font(.system(size: 16))
                .foregroundColor(deviceMode.accentColor)

            Text(deviceMode.trackingDescription)
                .font(Theme.Typography.caption)
                .foregroundColor(deviceMode.accentColor)
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, Theme.Spacing.sm)
        .background(deviceMode.accentColor.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                .stroke(deviceMode.accentColor.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(Theme.CornerRadius.md)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: Theme.Spacing.sm) {
            // Done button
            Button(action: onClose) {
                Text("Done")
                    .font(Theme.Typography.bodyBold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(Theme.Colors.accentBlue)
                    .cornerRadius(Theme.CornerRadius.md)
            }

            // Share button (if available)
            if let onShare = onShare {
                Button(action: onShare) {
                    HStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 14))
                        Text("Share Workout")
                            .font(Theme.Typography.bodyBold)
                    }
                    .foregroundColor(Theme.Colors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.sm)
                    .background(Theme.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                            .stroke(Theme.Colors.borderLight, lineWidth: 1)
                    )
                    .cornerRadius(Theme.CornerRadius.md)
                }
            }
        }
    }

    // MARK: - Health Link

    @ViewBuilder
    private var healthLink: some View {
        if let onViewInHealth = onViewInHealth {
            let (text, color) = healthLinkInfo
            Button(action: onViewInHealth) {
                Text(text)
                    .font(Theme.Typography.caption)
                    .foregroundColor(color)
            }
        }
    }

    private var healthLinkInfo: (String, Color) {
        switch deviceMode {
        case .appleWatchPhone, .appleWatchOnly:
            return ("View in Apple Health →", Theme.Colors.accentBlue)
        case .garminPhone:
            return ("View in Garmin Connect →", Theme.Colors.garminBlue)
        case .amazfitPhone:
            return ("View in Zepp →", Theme.Colors.amazfitOrange)
        case .phoneOnly:
            return ("", .clear)
        }
    }

    // MARK: - Helpers

    private var totalExercises: Int {
        countExercises(workout.intervals)
    }

    private func countExercises(_ intervals: [WorkoutInterval]) -> Int {
        intervals.reduce(0) { count, interval in
            switch interval {
            case .repeat(let reps, let nestedIntervals):
                return count + countExercises(nestedIntervals) * reps
            default:
                return count + 1
            }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60

        if hours > 0 {
            return "\(hours)h \(mins)m \(secs)s"
        }
        return "\(mins)m \(secs)s"
    }
}

// MARK: - Stat Card

private struct StatCard: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(iconColor)

                Text(label)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Text(value)
                .font(Theme.Typography.title3)
                .foregroundColor(Theme.Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.surface)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                .stroke(Theme.Colors.borderLight, lineWidth: 1)
        )
        .cornerRadius(Theme.CornerRadius.md)
    }
}

// MARK: - Preview

#Preview {
    WorkoutCompleteView(
        workout: Workout(
            name: "Full Body Strength",
            sport: .strength,
            duration: 1800,
            intervals: [
                .warmup(seconds: 300, target: nil),
                .reps(reps: 10, name: "Squats", load: nil, restSec: 60, followAlongUrl: nil),
                .reps(reps: 10, name: "Push-ups", load: nil, restSec: 60, followAlongUrl: nil),
                .cooldown(seconds: 300, target: nil)
            ],
            description: nil,
            source: .coach
        ),
        elapsedTime: 1823,
        deviceMode: .appleWatchPhone,
        calories: 245,
        avgHeartRate: 142,
        onClose: {},
        onShare: {},
        onViewInHealth: {}
    )
    .preferredColorScheme(.dark)
}
