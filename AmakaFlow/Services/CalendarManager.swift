//
//  CalendarManager.swift
//  AmakaFlow
//
//  Manages EventKit integration for scheduling workouts
//

import Foundation
import EventKit

class CalendarManager {
    private let eventStore = EKEventStore()
    
    // MARK: - Request Calendar Access
    func requestAccess() async throws -> Bool {
        if #available(iOS 17.0, *) {
            return try await eventStore.requestFullAccessToEvents()
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                eventStore.requestAccess(to: .event) { granted, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: granted)
                    }
                }
            }
        }
    }
    
    // MARK: - Schedule Workout
    func scheduleWorkout(workout: Workout, date: Date, time: String) async throws -> Bool {
        // Request access first
        let granted = try await requestAccess()
        guard granted else {
            throw CalendarError.accessDenied
        }
        
        // Parse time string (format: "09:00")
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            throw CalendarError.invalidTimeFormat
        }
        
        // Create start date by combining date and time
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        guard let startDate = Calendar.current.date(from: dateComponents) else {
            throw CalendarError.invalidDate
        }
        
        // Calculate end date (start date + workout duration)
        let endDate = startDate.addingTimeInterval(TimeInterval(workout.duration))
        
        // Create calendar event
        let event = EKEvent(eventStore: eventStore)
        event.title = workout.name
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        // Add notes with workout details
        var notes = ""
        if let description = workout.description {
            notes += "\(description)\n\n"
        }
        notes += "Sport: \(workout.sport.rawValue.capitalized)\n"
        notes += "Duration: \(workout.formattedDuration)\n"
        notes += "Steps: \(workout.intervalCount)\n"
        notes += "\nCreated by AmakaFlow Companion"
        event.notes = notes
        
        // Add reminder (15 minutes before)
        let alarm = EKAlarm(relativeOffset: -15 * 60) // 15 minutes before
        event.addAlarm(alarm)
        
        // Save event
        do {
            try eventStore.save(event, span: .thisEvent)
            print("📅 Workout scheduled: \(workout.name) at \(startDate)")
            return true
        } catch {
            print("📅 Failed to save event: \(error.localizedDescription)")
            throw CalendarError.saveFailed(error)
        }
    }
    
    // MARK: - Delete Event
    func deleteWorkoutEvent(title: String, date: Date) async throws {
        let granted = try await requestAccess()
        guard granted else {
            throw CalendarError.accessDenied
        }
        
        // Search for event
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = eventStore.predicateForEvents(
            withStart: startOfDay,
            end: endOfDay,
            calendars: nil
        )
        
        let events = eventStore.events(matching: predicate)
        
        // Find matching event
        if let event = events.first(where: { $0.title == title }) {
            try eventStore.remove(event, span: .thisEvent)
            print("📅 Deleted event: \(title)")
        }
    }
    
    // MARK: - Check Authorization Status
    var authorizationStatus: EKAuthorizationStatus {
        if #available(iOS 17.0, *) {
            return EKEventStore.authorizationStatus(for: .event)
        } else {
            return EKEventStore.authorizationStatus(for: .event)
        }
    }
}

// MARK: - Calendar Errors
enum CalendarError: LocalizedError {
    case accessDenied
    case invalidTimeFormat
    case invalidDate
    case saveFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Calendar access denied. Please enable calendar access in Settings > AmakaFlow Companion."
        case .invalidTimeFormat:
            return "Invalid time format. Please use HH:MM format."
        case .invalidDate:
            return "Invalid date selected."
        case .saveFailed(let error):
            return "Failed to save workout to calendar: \(error.localizedDescription)"
        }
    }
}
