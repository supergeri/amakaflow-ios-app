//
//  ScheduleCalendarSheet.swift
//  AmakaFlow
//
//  Calendar picker sheet for scheduling workouts
//

import SwiftUI

struct ScheduleCalendarSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let workout: Workout
    let onSchedule: (Date, String) -> Void
    
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 9
        components.minute = 0
        return calendar.date(from: components) ?? Date()
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Schedule to Calendar")
                                .font(Theme.Typography.title2)
                                .foregroundColor(Theme.Colors.textPrimary)
                            
                            Text("Choose when you'd like to do \"\(workout.name)\"")
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.top, Theme.Spacing.md)
                        
                        // Date Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(Theme.Typography.bodyBold)
                                .foregroundColor(Theme.Colors.textPrimary)
                            
                            DatePicker(
                                "",
                                selection: $selectedDate,
                                in: Date()...,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .tint(Theme.Colors.accentBlue)
                            .background(Theme.Colors.surface)
                            .cornerRadius(Theme.CornerRadius.xl)
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        
                        // Time Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time")
                                .font(Theme.Typography.bodyBold)
                                .foregroundColor(Theme.Colors.textPrimary)
                            
                            DatePicker(
                                "",
                                selection: $selectedTime,
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(height: 120)
                            .background(Theme.Colors.surface)
                            .cornerRadius(Theme.CornerRadius.xl)
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        
                        // Info Box
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.Colors.textSecondary)
                            
                            Text("This will create an event in your Apple Calendar with a notification reminder at the scheduled time.")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(Theme.Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.Colors.surfaceElevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                                .stroke(Theme.Colors.borderLight, lineWidth: 1)
                        )
                        .cornerRadius(Theme.CornerRadius.md)
                        .padding(.horizontal, Theme.Spacing.lg)
                        
                        // Action Buttons
                        HStack(spacing: 12) {
                            Button("Cancel") {
                                dismiss()
                            }
                            .font(Theme.Typography.bodyBold)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Theme.Colors.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                                    .stroke(Theme.Colors.borderLight, lineWidth: 1)
                            )
                            .cornerRadius(Theme.CornerRadius.md)
                            
                            Button("Add to Calendar") {
                                let timeString = formatTime(selectedTime)
                                onSchedule(selectedDate, timeString)
                                dismiss()
                            }
                            .font(Theme.Typography.bodyBold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Theme.Colors.accentBlue)
                            .cornerRadius(Theme.CornerRadius.md)
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.bottom, Theme.Spacing.lg)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    ScheduleCalendarSheet(
        workout: Workout(
            name: "Full Body Strength",
            sport: .strength,
            duration: 1890,
            intervals: [
                .warmup(seconds: 300, target: nil)
            ],
            source: .coach
        ),
        onSchedule: { date, time in
            print("Scheduled for \(date) at \(time)")
        }
    )
    .preferredColorScheme(.dark)
}
