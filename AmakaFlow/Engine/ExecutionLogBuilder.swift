//
//  ExecutionLogBuilder.swift
//  AmakaFlow
//
//  AMA-291: Tracks actual workout execution to build execution_log for completion submission
//

import Foundation

// MARK: - Execution Models

/// Status of an interval's execution
enum IntervalStatus: String, Codable {
    case completed
    case modified
    case skipped
    case partial
}

/// Status of a single set within an interval
enum SetStatus: String, Codable {
    case completed
    case skipped
}

/// Execution data for a single set within an interval
struct SetExecution: Codable {
    let setNumber: Int
    var status: SetStatus = .completed
    var repsCompleted: Int?
    var weight: Double?
    var unit: String?
    var durationSec: Int?
    var rpe: Int?

    enum CodingKeys: String, CodingKey {
        case setNumber = "set_number"
        case status
        case repsCompleted = "reps_completed"
        case weight
        case unit
        case durationSec = "duration_sec"
        case rpe
    }
}

/// Execution data for a single interval
struct IntervalExecution: Codable {
    let intervalIndex: Int
    let kind: String?
    let name: String?
    var status: IntervalStatus = .completed
    var plannedDurationSec: Int?
    var actualDurationSec: Int?
    var startedAt: Date?
    var endedAt: Date?
    var skipReason: String?
    var sets: [SetExecution]?

    enum CodingKeys: String, CodingKey {
        case intervalIndex = "interval_index"
        case kind
        case name
        case status
        case plannedDurationSec = "planned_duration_sec"
        case actualDurationSec = "actual_duration_sec"
        case startedAt = "started_at"
        case endedAt = "ended_at"
        case skipReason = "skip_reason"
        case sets
    }
}

/// Summary statistics for execution log
struct ExecutionSummary: Codable {
    let totalIntervals: Int
    let completed: Int
    let skipped: Int
    let modified: Int
    let completionPercentage: Double

    enum CodingKeys: String, CodingKey {
        case totalIntervals = "total_intervals"
        case completed
        case skipped
        case modified
        case completionPercentage = "completion_percentage"
    }
}

/// Skip reasons for intervals
enum SkipReason: String, CaseIterable {
    case fatigue = "fatigue"
    case timeConstraint = "time_constraint"
    case equipmentUnavailable = "equipment_unavailable"
    case pain = "pain"
    case other = "other"

    var displayName: String {
        switch self {
        case .fatigue: return "Too tired"
        case .timeConstraint: return "Running out of time"
        case .equipmentUnavailable: return "Equipment busy"
        case .pain: return "Pain/discomfort"
        case .other: return "Other"
        }
    }
}


// MARK: - ExecutionLogBuilder

/// Builds execution_log structure tracking actual workout execution
class ExecutionLogBuilder {
    private var intervals: [IntervalExecution] = []
    private var currentIntervalStartTime: Date?
    private var currentIntervalIndex: Int?

    // MARK: - Interval Tracking

    /// Start tracking a new interval
    /// - Parameters:
    ///   - index: Step index in flattened workout
    ///   - kind: Interval type (warmup, work, rest, reps, etc.)
    ///   - name: Display name for the interval
    ///   - plannedDuration: Planned duration in seconds (nil for reps-based)
    func startInterval(index: Int, kind: String?, name: String?, plannedDuration: Int?) {
        // End any previous interval that wasn't properly closed
        if currentIntervalIndex != nil {
            endCurrentInterval(actualDuration: nil)
        }

        currentIntervalStartTime = Date()
        currentIntervalIndex = index

        var interval = IntervalExecution(
            intervalIndex: index,
            kind: kind,
            name: name
        )
        interval.plannedDurationSec = plannedDuration
        interval.startedAt = currentIntervalStartTime

        intervals.append(interval)
    }

    /// End the current interval
    /// - Parameter actualDuration: Actual duration in seconds (nil to calculate from start time)
    func endCurrentInterval(actualDuration: Int?) {
        guard let currentIndex = currentIntervalIndex,
              let idx = intervals.firstIndex(where: { $0.intervalIndex == currentIndex }) else {
            return
        }

        intervals[idx].endedAt = Date()

        if let duration = actualDuration {
            intervals[idx].actualDurationSec = duration
        } else if let startTime = currentIntervalStartTime {
            intervals[idx].actualDurationSec = Int(Date().timeIntervalSince(startTime))
        }

        currentIntervalIndex = nil
        currentIntervalStartTime = nil
    }

    /// Mark an interval as skipped
    /// - Parameters:
    ///   - index: Step index in flattened workout
    ///   - kind: Interval type
    ///   - name: Display name
    ///   - reason: Reason for skipping
    func skipInterval(index: Int, kind: String?, name: String?, reason: SkipReason) {
        // End any current interval first
        if currentIntervalIndex != nil {
            endCurrentInterval(actualDuration: nil)
        }

        var interval = IntervalExecution(
            intervalIndex: index,
            kind: kind,
            name: name
        )
        interval.status = .skipped
        interval.skipReason = reason.rawValue
        interval.startedAt = Date()
        interval.endedAt = Date()

        intervals.append(interval)
    }

    /// Mark the current interval as modified (duration changed from plan)
    func markCurrentAsModified() {
        guard let currentIndex = currentIntervalIndex,
              let idx = intervals.firstIndex(where: { $0.intervalIndex == currentIndex }) else {
            return
        }
        intervals[idx].status = .modified
    }

    // MARK: - Set Tracking

    /// Log a set execution for an interval
    /// - Parameters:
    ///   - intervalIndex: The interval this set belongs to
    ///   - setNumber: Set number (1-based)
    ///   - weight: Weight used (nil if skipped)
    ///   - unit: Weight unit ("lbs" or "kg")
    ///   - reps: Reps completed
    ///   - skipped: Whether set was skipped
    func logSet(
        intervalIndex: Int,
        setNumber: Int,
        weight: Double?,
        unit: String?,
        reps: Int?,
        skipped: Bool = false
    ) {
        guard let idx = intervals.firstIndex(where: { $0.intervalIndex == intervalIndex }) else {
            return
        }

        var setExec = SetExecution(setNumber: setNumber)
        setExec.status = skipped ? .skipped : .completed
        setExec.weight = weight
        setExec.unit = unit
        setExec.repsCompleted = reps

        if intervals[idx].sets == nil {
            intervals[idx].sets = []
        }
        intervals[idx].sets?.append(setExec)
    }

    // MARK: - Build Output

    /// Build the final execution_log dictionary for API submission
    func build() -> [String: Any] {
        // End any unclosed interval
        if currentIntervalIndex != nil {
            endCurrentInterval(actualDuration: nil)
        }

        let summary = calculateSummary()

        // Convert intervals to dictionaries
        let intervalDicts: [[String: Any]] = intervals.map { interval in
            var dict: [String: Any] = [
                "interval_index": interval.intervalIndex,
                "status": interval.status.rawValue
            ]

            if let kind = interval.kind { dict["kind"] = kind }
            if let name = interval.name { dict["name"] = name }
            if let plannedDuration = interval.plannedDurationSec { dict["planned_duration_sec"] = plannedDuration }
            if let actualDuration = interval.actualDurationSec { dict["actual_duration_sec"] = actualDuration }
            if let startedAt = interval.startedAt { dict["started_at"] = ISO8601DateFormatter().string(from: startedAt) }
            if let endedAt = interval.endedAt { dict["ended_at"] = ISO8601DateFormatter().string(from: endedAt) }
            if let skipReason = interval.skipReason { dict["skip_reason"] = skipReason }

            if let sets = interval.sets {
                dict["sets"] = sets.map { set -> [String: Any] in
                    var setDict: [String: Any] = [
                        "set_number": set.setNumber,
                        "status": set.status.rawValue
                    ]
                    if let weight = set.weight { setDict["weight"] = weight }
                    if let unit = set.unit { setDict["unit"] = unit }
                    if let reps = set.repsCompleted { setDict["reps_completed"] = reps }
                    if let duration = set.durationSec { setDict["duration_sec"] = duration }
                    if let rpe = set.rpe { setDict["rpe"] = rpe }
                    return setDict
                }
            }

            return dict
        }

        return [
            "intervals": intervalDicts,
            "summary": [
                "total_intervals": summary.totalIntervals,
                "completed": summary.completed,
                "skipped": summary.skipped,
                "modified": summary.modified,
                "completion_percentage": summary.completionPercentage
            ]
        ]
    }

    /// Calculate summary statistics
    private func calculateSummary() -> ExecutionSummary {
        let completed = intervals.filter { $0.status == .completed }.count
        let skipped = intervals.filter { $0.status == .skipped }.count
        let modified = intervals.filter { $0.status == .modified }.count
        let total = intervals.count

        let completionPct = total > 0 ? Double(completed + modified) / Double(total) * 100.0 : 0.0

        return ExecutionSummary(
            totalIntervals: total,
            completed: completed,
            skipped: skipped,
            modified: modified,
            completionPercentage: round(completionPct * 10) / 10  // Round to 1 decimal
        )
    }

    /// Reset the builder for a new workout
    func reset() {
        intervals = []
        currentIntervalStartTime = nil
        currentIntervalIndex = nil
    }

    /// Get current interval count (for debugging)
    var intervalCount: Int {
        intervals.count
    }
}
