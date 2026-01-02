//
//  SentryService.swift
//  AmakaFlow
//
//  Centralized error tracking and crash reporting using Sentry (AMA-225)
//
//  SETUP INSTRUCTIONS:
//  1. In Xcode: File → Add Package Dependencies
//  2. Enter URL: https://github.com/getsentry/sentry-cocoa
//  3. Select "Up to Next Major Version" with 8.0.0
//  4. Add "Sentry" to AmakaFlowCompanion target
//  5. Add "Sentry" to AmakaFlowWatch Watch App target
//  6. Update the DSN below with your Sentry project DSN
//  7. Uncomment the Sentry import and SENTRY_ENABLED flag
//

import Foundation

// MARK: - Sentry SDK Integration
// Uncomment after adding Sentry package to project:
// import Sentry
// private let SENTRY_ENABLED = true

// Remove this line after adding Sentry package:
private let SENTRY_ENABLED = false

/// Centralized service for error tracking, crash reporting, and user feedback
@MainActor
final class SentryService {
    static let shared = SentryService()

    // MARK: - Configuration

    /// Sentry DSN - get from Sentry project settings
    /// Format: https://<key>@<org>.ingest.sentry.io/<project>
    private let dsn = "https://YOUR_DSN_HERE@sentry.io/YOUR_PROJECT_ID"

    /// Current environment (staging/production)
    private var environment: String {
        #if DEBUG
        return "development"
        #else
        // Check for TestFlight
        if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
            return "staging"
        }
        return "production"
        #endif
    }

    /// Whether Sentry is properly configured (DSN is set and SDK enabled)
    private var isConfigured: Bool {
        SENTRY_ENABLED && !dsn.contains("YOUR_DSN_HERE")
    }

    private init() {}

    // MARK: - Initialization

    /// Initialize Sentry SDK - call once at app launch
    func initialize() {
        guard SENTRY_ENABLED else {
            print("[Sentry] SDK not enabled - follow setup instructions in SentryService.swift")
            return
        }

        guard isConfigured else {
            print("[Sentry] Not configured - update DSN in SentryService.swift")
            return
        }

        // Uncomment after adding Sentry package:
        /*
        SentrySDK.start { options in
            options.dsn = self.dsn
            options.environment = self.environment

            // Enable automatic session tracking
            options.enableAutoSessionTracking = true

            // Attach screenshots and view hierarchy for debugging
            options.attachScreenshot = true
            options.attachViewHierarchy = true

            // Performance monitoring (sample 10% of transactions)
            options.tracesSampleRate = 0.1
            options.profilesSampleRate = 0.1

            // Enable automatic breadcrumbs
            options.enableAutoBreadcrumbTracking = true

            // Debug logging (only in DEBUG builds)
            #if DEBUG
            options.debug = true
            #endif
        }

        // Set app version and build info
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            SentrySDK.configureScope { scope in
                scope.setTag(value: version, key: "app_version")
                scope.setTag(value: build, key: "app_build")
            }
        }
        */

        print("[Sentry] Initialized for environment: \(environment)")
    }

    // MARK: - User Context

    /// Set user context after successful pairing/authentication
    func setUser(userId: String, email: String? = nil) {
        guard isConfigured else { return }

        // Uncomment after adding Sentry package:
        /*
        let user = User()
        user.userId = userId
        user.email = email
        SentrySDK.setUser(user)
        */
        print("[Sentry] User context set: \(userId)")
    }

    /// Clear user context on logout/unpair
    func clearUser() {
        guard isConfigured else { return }

        // Uncomment after adding Sentry package:
        // SentrySDK.setUser(nil)
        print("[Sentry] User context cleared")
    }

    // MARK: - Error Capturing

    /// Capture an error with optional context
    func captureError(_ error: Error, context: [String: Any]? = nil) {
        guard isConfigured else {
            print("[Sentry] Would capture error: \(error.localizedDescription)")
            return
        }

        // Uncomment after adding Sentry package:
        /*
        SentrySDK.capture(error: error) { scope in
            if let context = context {
                for (key, value) in context {
                    scope.setExtra(value: value, key: key)
                }
            }
        }
        */
    }

    /// Capture an API error with endpoint and status code
    func captureAPIError(_ error: Error, endpoint: String, statusCode: Int?, responseBody: String? = nil) {
        guard isConfigured else {
            print("[Sentry] Would capture API error: \(endpoint) - \(statusCode ?? 0)")
            return
        }

        // Uncomment after adding Sentry package:
        /*
        SentrySDK.capture(error: error) { scope in
            scope.setTag(value: endpoint, key: "api_endpoint")
            if let code = statusCode {
                scope.setTag(value: String(code), key: "status_code")
            }
            if let body = responseBody {
                scope.setExtra(value: String(body.prefix(1000)), key: "response_body")
            }
            scope.setTag(value: "api", key: "error_category")
        }
        */
    }

    /// Capture a Watch communication error
    func captureWatchError(_ error: Error, context: String) {
        guard isConfigured else {
            print("[Sentry] Would capture Watch error: \(context)")
            return
        }

        // Uncomment after adding Sentry package:
        /*
        SentrySDK.capture(error: error) { scope in
            scope.setTag(value: "watch_communication", key: "error_category")
            scope.setExtra(value: context, key: "context")
        }
        */
    }

    /// Capture a Garmin communication error
    func captureGarminError(_ error: Error, context: String) {
        guard isConfigured else {
            print("[Sentry] Would capture Garmin error: \(context)")
            return
        }

        // Uncomment after adding Sentry package:
        /*
        SentrySDK.capture(error: error) { scope in
            scope.setTag(value: "garmin_communication", key: "error_category")
            scope.setExtra(value: context, key: "context")
        }
        */
    }

    /// Capture a workout engine error
    func captureWorkoutError(_ error: Error, workoutId: String?, stepIndex: Int?) {
        guard isConfigured else {
            print("[Sentry] Would capture Workout error: \(workoutId ?? "unknown")")
            return
        }

        // Uncomment after adding Sentry package:
        /*
        SentrySDK.capture(error: error) { scope in
            scope.setTag(value: "workout", key: "error_category")
            if let id = workoutId {
                scope.setExtra(value: id, key: "workout_id")
            }
            if let step = stepIndex {
                scope.setExtra(value: step, key: "step_index")
            }
        }
        */
    }

    // MARK: - Breadcrumbs

    /// Add a navigation breadcrumb
    func trackScreen(_ name: String) {
        guard isConfigured else { return }

        // Uncomment after adding Sentry package:
        /*
        let crumb = Breadcrumb(level: .info, category: "navigation")
        crumb.message = "Viewed \(name)"
        SentrySDK.addBreadcrumb(crumb)
        */
    }

    /// Add a workout action breadcrumb
    func trackWorkoutAction(_ action: String, workoutId: String? = nil, workoutName: String? = nil) {
        guard isConfigured else { return }

        // Uncomment after adding Sentry package:
        /*
        let crumb = Breadcrumb(level: .info, category: "workout")
        crumb.message = action
        var data: [String: Any] = [:]
        if let id = workoutId { data["workout_id"] = id }
        if let name = workoutName { data["workout_name"] = name }
        if !data.isEmpty { crumb.data = data }
        SentrySDK.addBreadcrumb(crumb)
        */
    }

    /// Add a pairing action breadcrumb
    func trackPairingAction(_ action: String) {
        guard isConfigured else { return }

        // Uncomment after adding Sentry package:
        /*
        let crumb = Breadcrumb(level: .info, category: "pairing")
        crumb.message = action
        SentrySDK.addBreadcrumb(crumb)
        */
    }

    /// Add a device connection breadcrumb
    func trackDeviceConnection(_ device: String, action: String) {
        guard isConfigured else { return }

        // Uncomment after adding Sentry package:
        /*
        let crumb = Breadcrumb(level: .info, category: "device")
        crumb.message = "\(device): \(action)"
        SentrySDK.addBreadcrumb(crumb)
        */
    }

    // MARK: - User Feedback

    /// Submit user feedback for a captured event
    func submitFeedback(comments: String, email: String? = nil, name: String? = nil) {
        guard isConfigured else {
            print("[Sentry] Would submit feedback: \(comments)")
            return
        }

        // Uncomment after adding Sentry package:
        /*
        let eventId = SentrySDK.capture(message: "User Feedback")
        let feedback = UserFeedback(eventId: eventId)
        feedback.comments = comments
        feedback.email = email ?? ""
        feedback.name = name ?? ""
        SentrySDK.capture(userFeedback: feedback)
        */
        print("[Sentry] User feedback submitted")
    }

    /// Capture a message with attached debug logs
    func captureWithLogs(_ message: String, logs: String) {
        guard isConfigured else {
            print("[Sentry] Would capture message: \(message)")
            return
        }

        // Uncomment after adding Sentry package:
        /*
        SentrySDK.capture(message: message) { scope in
            scope.setExtra(value: logs, key: "debug_logs")
        }
        */
    }
}

// MARK: - Convenience Extensions

extension Error {
    /// Capture this error to Sentry with optional context
    func captureToSentry(context: [String: Any]? = nil) {
        Task { @MainActor in
            SentryService.shared.captureError(self, context: context)
        }
    }
}
