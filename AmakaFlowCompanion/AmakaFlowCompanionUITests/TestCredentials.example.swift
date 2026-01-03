//
//  TestCredentials.example.swift
//  AmakaFlowCompanionUITests
//
//  TEMPLATE FILE - Copy to TestCredentials.swift and fill in your test credentials
//
//  To generate a test JWT, run from the mapper-api directory:
//  python3 -c "
//  import jwt
//  from datetime import datetime, timedelta, timezone
//  JWT_SECRET = 'amakaflow-mobile-jwt-secret-change-in-production'
//  now = datetime.now(timezone.utc)
//  expiry = now + timedelta(days=365)
//  payload = {'sub': 'YOUR_TEST_USER_ID', 'iat': int(now.timestamp()), 'exp': int(expiry.timestamp()), 'iss': 'amakaflow', 'aud': 'ios_companion', 'email': 'YOUR_TEST_EMAIL', 'name': 'YOUR_TEST_NAME'}
//  print(jwt.encode(payload, JWT_SECRET, algorithm='HS256'))
//  "
//

import Foundation

/// Test credentials for E2E UI testing
/// Copy this file to TestCredentials.swift and fill in your credentials
/// NOTE: Rename this enum to TestCredentials after copying
enum _TestCredentialsTemplate {
    /// Long-lived JWT for test account
    static let pairingToken = "YOUR_JWT_TOKEN_HERE"

    /// Test user ID matching the JWT 'sub' claim
    static let userId = "YOUR_TEST_USER_ID"

    /// Test user email
    static let userEmail = "your_test_email@example.com"

    /// Test user display name
    static let userName = "Test User"

    /// API base URL for testing
    static let apiBaseURL = "https://mapper-api.staging.amakaflow.com"
}
