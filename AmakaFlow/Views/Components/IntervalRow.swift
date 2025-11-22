//
//  IntervalRow.swift
//  AmakaFlow
//
//  Individual interval row component
//

import SwiftUI

struct IntervalRow: View {
    let interval: WorkoutInterval
    let stepNumber: Int
    let isLast: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: Theme.Spacing.md) {
                // Step number badge
                Text("\(stepNumber)")
                    .font(Theme.Typography.captionBold)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .frame(width: 28, height: 28)
                    .background(Theme.Colors.surfaceElevated)
                    .overlay(
                        Circle()
                            .stroke(Theme.Colors.borderMedium, lineWidth: 1)
                    )
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    // Interval Type & Main Info
                    HStack(spacing: 8) {
                        Image(systemName: intervalIcon)
                            .font(.system(size: 14))
                            .foregroundColor(intervalColor)
                        
                        Text(intervalTitle)
                            .font(Theme.Typography.bodyBold)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Spacer()
                        
                        Text(intervalDuration)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .frame(height: 20)
                    
                    // Additional Details
                    if let details = intervalDetails {
                        Text(details)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .padding(.leading, 22)
                            .frame(height: 16)
                    } else {
                        // Placeholder to maintain consistent height
                        Text("")
                            .font(Theme.Typography.caption)
                            .frame(height: 16)
                            .opacity(0)
                    }
                    
                    // Nested Intervals (for repeat type)
                    if case .repeat(_, let intervals) = interval {
                        VStack(spacing: 8) {
                            ForEach(Array(intervals.enumerated()), id: \.offset) { index, subInterval in
                                NestedIntervalRow(interval: subInterval)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.leading, 22)
                    }
                }
                .frame(minHeight: 44) // Consistent minimum height for main content
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.vertical, Theme.Spacing.md)
            .frame(minHeight: 60) // Consistent minimum height for entire row
            
            if !isLast {
                Divider()
                    .background(Theme.Colors.borderLight)
                    .padding(.leading, 60)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var intervalIcon: String {
        switch interval {
        case .warmup: return "flame"
        case .cooldown: return "wind"
        case .time: return "clock"
        case .reps: return "arrow.clockwise"
        case .distance: return "location"
        case .repeat: return "repeat"
        }
    }
    
    private var intervalColor: Color {
        switch interval {
        case .warmup: return .orange
        case .cooldown: return .blue
        case .time: return Theme.Colors.accentBlue
        case .reps: return Theme.Colors.accentGreen
        case .distance: return .purple
        case .repeat: return .yellow
        }
    }
    
    private var intervalTitle: String {
        switch interval {
        case .warmup: return "Warm Up"
        case .cooldown: return "Cool Down"
        case .time(_, let target):
            return target ?? "Work"
        case .reps(_, let name, _, _):
            return name
        case .distance:
            return "Run"
        case .repeat(let reps, _):
            return "Repeat \(reps)x"
        }
    }
    
    private var intervalDuration: String {
        switch interval {
        case .warmup(let seconds, _), .cooldown(let seconds, _), .time(let seconds, _):
            return WorkoutHelpers.formatDuration(seconds: seconds)
        case .reps(let reps, _, _, _):
            return "\(reps) reps"
        case .distance(let meters, _):
            return WorkoutHelpers.formatDistance(meters: meters)
        case .repeat(_, let intervals):
            // Calculate total time for repeat block
            let totalSeconds = intervals.reduce(0) { total, interval in
                switch interval {
                case .warmup(let s, _), .cooldown(let s, _), .time(let s, _):
                    return total + s
                case .reps(_, _, _, let rest):
                    return total + (rest ?? 0)
                default:
                    return total
                }
            }
            return WorkoutHelpers.formatDuration(seconds: totalSeconds)
        }
    }
    
    private var intervalDetails: String? {
        switch interval {
        case .warmup(_, let target), .cooldown(_, let target), .time(_, let target), .distance(_, let target):
            return target
        case .reps(_, _, let load, let restSec):
            var details: [String] = []
            if let load = load {
                details.append("Load: \(load)")
            }
            if let rest = restSec {
                details.append("Rest: \(WorkoutHelpers.formatDuration(seconds: rest))")
            }
            return details.isEmpty ? nil : details.joined(separator: " • ")
        case .repeat:
            return nil
        }
    }
}

// MARK: - Nested Interval Row
struct NestedIntervalRow: View {
    let interval: WorkoutInterval
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Theme.Colors.textSecondary)
                .frame(width: 4, height: 4)
            
            HStack {
                Text(intervalTitle)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text(intervalDuration)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, 8)
        .background(Theme.Colors.surfaceElevated)
        .cornerRadius(Theme.CornerRadius.sm)
    }
    
    private var intervalTitle: String {
        switch interval {
        case .warmup: return "Warm Up"
        case .cooldown: return "Cool Down"
        case .time(_, let target): return target ?? "Work"
        case .reps(_, let name, _, _): return name
        case .distance: return "Run"
        case .repeat: return "Repeat"
        }
    }
    
    private var intervalDuration: String {
        switch interval {
        case .warmup(let seconds, _), .cooldown(let seconds, _), .time(let seconds, _):
            return WorkoutHelpers.formatDuration(seconds: seconds)
        case .reps(let reps, _, _, _):
            return "\(reps) reps"
        case .distance(let meters, _):
            return WorkoutHelpers.formatDistance(meters: meters)
        case .repeat(let reps, _):
            return "\(reps)x"
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        IntervalRow(
            interval: .warmup(seconds: 300, target: nil),
            stepNumber: 1,
            isLast: false
        )
        
        IntervalRow(
            interval: .reps(reps: 8, name: "Squat", load: "80% 1RM", restSec: 90),
            stepNumber: 2,
            isLast: false
        )
        
        IntervalRow(
            interval: .repeat(reps: 3, intervals: [
                .reps(reps: 10, name: "Push Up", load: nil, restSec: 60),
                .time(seconds: 60, target: "Rest")
            ]),
            stepNumber: 3,
            isLast: true
        )
    }
    .background(Theme.Colors.surface)
    .cornerRadius(Theme.CornerRadius.xl)
    .padding()
    .background(Theme.Colors.background)
    .preferredColorScheme(.dark)
}
