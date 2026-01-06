//
//  TestAuthStore.swift
//  AmakaFlow
//
//  Stores test authentication credentials for E2E testing bypass.
//  Allows manual entry of test credentials on simulators to skip QR pairing.
//

import Foundation

/// Store for E2E test authentication credentials
/// Supports both environment variables (automated tests) and runtime storage (manual testing)
class TestAuthStore {
    static let shared = TestAuthStore()

    private let authSecretKey = "e2e_test_auth_secret"
    private let userIdKey = "e2e_test_user_id"
    private let userEmailKey = "e2e_test_user_email"

    private init() {}

    // MARK: - Credential Access

    /// Get the test auth secret (checks environment first, then stored value)
    var authSecret: String? {
        #if DEBUG
        // Environment variable takes precedence (for automated tests)
        if let envSecret = ProcessInfo.processInfo.environment["TEST_AUTH_SECRET"],
           !envSecret.isEmpty {
            return envSecret
        }
        // Fall back to stored value (for manual testing)
        return UserDefaults.standard.string(forKey: authSecretKey)
        #else
        return nil
        #endif
    }

    /// Get the test user ID (checks environment first, then stored value)
    var userId: String? {
        #if DEBUG
        // Environment variable takes precedence
        if let envUserId = ProcessInfo.processInfo.environment["TEST_USER_ID"],
           !envUserId.isEmpty {
            return envUserId
        }
        // Fall back to stored value
        return UserDefaults.standard.string(forKey: userIdKey)
        #else
        return nil
        #endif
    }

    /// Get the test user email (checks environment first, then stored value)
    var userEmail: String? {
        #if DEBUG
        // Environment variable takes precedence
        if let envEmail = ProcessInfo.processInfo.environment["TEST_USER_EMAIL"],
           !envEmail.isEmpty {
            return envEmail
        }
        // Fall back to stored value
        return UserDefaults.standard.string(forKey: userEmailKey)
        #else
        return nil
        #endif
    }

    /// Check if test mode is enabled (either via env vars or stored credentials)
    var isTestModeEnabled: Bool {
        #if DEBUG
        return authSecret != nil && userId != nil
        #else
        return false
        #endif
    }

    /// Check if using stored credentials (not environment variables)
    var isUsingStoredCredentials: Bool {
        #if DEBUG
        // Check if we have stored credentials and NOT environment variables
        let hasEnvCredentials = ProcessInfo.processInfo.environment["TEST_AUTH_SECRET"] != nil
        let hasStoredCredentials = UserDefaults.standard.string(forKey: authSecretKey) != nil
        return hasStoredCredentials && !hasEnvCredentials
        #else
        return false
        #endif
    }

    // MARK: - Credential Storage

    /// Store test credentials for manual E2E testing
    /// - Parameters:
    ///   - authSecret: The test auth secret
    ///   - userId: The test user ID
    ///   - email: Optional user email
    func storeCredentials(authSecret: String, userId: String, email: String? = nil) {
        #if DEBUG
        UserDefaults.standard.set(authSecret, forKey: authSecretKey)
        UserDefaults.standard.set(userId, forKey: userIdKey)
        if let email = email {
            UserDefaults.standard.set(email, forKey: userEmailKey)
        }
        print("[TestAuthStore] Stored E2E test credentials for user: \(userId)")
        #endif
    }

    /// Clear stored test credentials
    func clearCredentials() {
        #if DEBUG
        UserDefaults.standard.removeObject(forKey: authSecretKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        print("[TestAuthStore] Cleared E2E test credentials")
        #endif
    }
}
