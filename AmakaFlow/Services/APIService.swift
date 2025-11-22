//
//  APIService.swift
//  AmakaFlow
//
//  API service for fetching workouts from mapper-api
//  Placeholder for future implementation
//

import Foundation

/// Service for API communication with backend
class APIService {
    static let shared = APIService()
    
    // TODO: Configure base URL from environment
    private let baseURL = "http://localhost:8001"
    
    private init() {}
    
    /// Fetch workouts from backend
    /// - Returns: Array of workouts
    /// - Throws: APIError if request fails
    func fetchWorkouts() async throws -> [Workout] {
        // TODO: Implement API call to GET /workouts
        // For now, return empty array
        // This will be implemented when Clerk auth is added
        throw APIError.notImplemented
    }
    
    /// Sync workout to backend
    /// - Parameter workout: Workout to sync
    /// - Throws: APIError if sync fails
    func syncWorkout(_ workout: Workout) async throws {
        // TODO: Implement API call to POST /workouts
        // This will be implemented when Clerk auth is added
        throw APIError.notImplemented
    }
    
    /// Get workout export in Apple WorkoutKit format
    /// - Parameter workoutId: ID of workout to export
    /// - Returns: JSON string in WKPlanDTO format
    /// - Throws: APIError if export fails
    func getAppleExport(workoutId: String) async throws -> String {
        // TODO: Implement API call to GET /export/apple/{workoutId}
        // This will return JSON in WKPlanDTO format ready for WorkoutKitSync
        throw APIError.notImplemented
    }
}

// MARK: - API Errors
enum APIError: LocalizedError {
    case notImplemented
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case unauthorized
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "API feature not yet implemented"
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized - please sign in"
        case .serverError(let code):
            return "Server error: \(code)"
        }
    }
}

