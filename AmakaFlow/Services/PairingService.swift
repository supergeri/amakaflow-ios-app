import Foundation
import UIKit
import Combine

@MainActor
class PairingService: ObservableObject {
    static let shared = PairingService()

    private let baseURL = AppEnvironment.current.mapperAPIURL
    private let tokenKey = "jwt_token"
    private let profileKey = "user_profile"

    @Published var isPaired: Bool = false
    @Published var userProfile: UserProfile?

    private init() {
        isPaired = getToken() != nil
        userProfile = loadProfile()
    }

    // MARK: - Pairing

    /// Exchange a pairing code (from QR or manual entry) for a JWT
    func pair(code: String) async throws -> PairingResponse {
        let url = URL(string: "\(baseURL)/mobile/pairing/pair")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = PairingRequest(
            token: code.count > 6 ? code : nil,
            shortCode: code.count == 6 ? code.uppercased() : nil,
            deviceInfo: DeviceInfo(
                model: getDeviceModel(),
                osVersion: UIDevice.current.systemVersion,
                appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
            )
        )

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw PairingError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(PairingResponse.self, from: data)
            try storeToken(result.jwt)
            if let profile = result.profile {
                storeProfile(profile)
            }
            await MainActor.run {
                self.isPaired = true
                self.userProfile = result.profile
            }
            return result
        case 400:
            let error = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw PairingError.invalidCode(error?.detail ?? "Invalid code")
        case 410:
            throw PairingError.codeExpired
        default:
            throw PairingError.serverError(httpResponse.statusCode)
        }
    }

    // MARK: - Token Management

    func storeToken(_ jwt: String) throws {
        if !KeychainHelper.shared.save(jwt, for: tokenKey) {
            throw PairingError.tokenStorageFailed
        }
    }

    func getToken() -> String? {
        return KeychainHelper.shared.readString(for: tokenKey)
    }

    func unpair() {
        KeychainHelper.shared.delete(for: tokenKey)
        KeychainHelper.shared.delete(for: profileKey)
        Task { @MainActor in
            self.isPaired = false
            self.userProfile = nil
        }
    }

    // MARK: - Profile Storage

    private func storeProfile(_ profile: UserProfile) {
        if let data = try? JSONEncoder().encode(profile) {
            _ = KeychainHelper.shared.save(data, for: profileKey)
        }
    }

    private func loadProfile() -> UserProfile? {
        guard let data = KeychainHelper.shared.read(for: profileKey) else { return nil }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }

    // MARK: - Device Info

    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
}

// MARK: - Models

struct PairingRequest: Codable {
    let token: String?
    let shortCode: String?
    let deviceInfo: DeviceInfo
}

struct DeviceInfo: Codable {
    let model: String
    let osVersion: String
    let appVersion: String
}

struct PairingResponse: Codable {
    let jwt: String
    let profile: UserProfile?
    let expiresAt: String
}

struct UserProfile: Codable {
    let id: String
    let email: String?
    let name: String?
    let avatarUrl: String?
}

struct APIErrorResponse: Codable {
    let detail: String
    let error: String?
    let message: String?
}

enum PairingError: LocalizedError {
    case invalidCode(String)
    case codeExpired
    case invalidResponse
    case serverError(Int)
    case tokenStorageFailed

    var errorDescription: String? {
        switch self {
        case .invalidCode(let msg): return msg
        case .codeExpired: return "Code has expired. Please generate a new one."
        case .invalidResponse: return "Invalid server response"
        case .serverError(let code): return "Server error: \(code)"
        case .tokenStorageFailed: return "Failed to save credentials"
        }
    }
}
