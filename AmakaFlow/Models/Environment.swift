import Foundation

enum AppEnvironment {
    case development
    case staging
    case production

    static var current: AppEnvironment {
        #if DEBUG
        return .staging
        #else
        return .production
        #endif
    }

    var mapperAPIURL: String {
        switch self {
        case .development: return "http://localhost:8001"
        case .staging: return "https://mapper-api.staging.amakaflow.com"
        case .production: return "https://mapper-api.amakaflow.com"
        }
    }

    var ingestorAPIURL: String {
        switch self {
        case .development: return "http://localhost:8004"
        case .staging: return "https://workout-ingestor-api.staging.amakaflow.com"
        case .production: return "https://workout-ingestor-api.amakaflow.com"
        }
    }

    var calendarAPIURL: String {
        switch self {
        case .development: return "http://localhost:8003"
        case .staging: return "https://calendar-api.staging.amakaflow.com"
        case .production: return "https://calendar-api.amakaflow.com"
        }
    }
}
