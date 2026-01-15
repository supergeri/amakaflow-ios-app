//
//  WatchSessionProviding.swift
//  AmakaFlow
//
//  Protocol abstraction for WCSession to enable dependency injection and testing
//  of watch connectivity features without requiring a real paired watch.
//

import Foundation
import WatchConnectivity

/// Protocol defining the watch session interface for dependency injection
/// This abstracts WCSession to allow mocking in tests
protocol WatchSessionProviding: AnyObject {
    // MARK: - State Properties

    /// Whether the watch app is installed on the paired watch
    var isWatchAppInstalled: Bool { get }

    /// Whether the watch is currently reachable for immediate messaging
    var isReachable: Bool { get }

    /// Whether an Apple Watch is paired with this device
    var isPaired: Bool { get }

    /// The current activation state of the session
    var activationState: WCSessionActivationState { get }

    // MARK: - Session Lifecycle

    /// Activate the watch connectivity session
    func activate()

    // MARK: - Messaging

    /// Send a message to the watch with optional reply and error handlers
    /// - Parameters:
    ///   - message: Dictionary containing the message data
    ///   - replyHandler: Optional closure called with the watch's reply
    ///   - errorHandler: Optional closure called if sending fails
    func sendMessage(
        _ message: [String: Any],
        replyHandler: (([String: Any]) -> Void)?,
        errorHandler: ((Error) -> Void)?
    )

    /// Transfer user info to the watch (queued for background transfer)
    /// - Parameter userInfo: Dictionary containing the data to transfer
    /// - Returns: A transfer object (or mock equivalent)
    @discardableResult
    func transferUserInfo(_ userInfo: [String: Any]) -> WCSessionUserInfoTransfer?

    /// Update the application context (most recent data available to watch)
    /// - Parameter applicationContext: Dictionary containing the context data
    func updateApplicationContext(_ applicationContext: [String: Any]) throws

    // MARK: - Delegate

    /// The delegate for receiving watch session events
    var delegate: WCSessionDelegate? { get set }
}

// MARK: - Live Implementation

/// Live implementation wrapping WCSession.default
/// Uses the real WatchConnectivity framework
class LiveWatchSession: WatchSessionProviding {
    static let shared = LiveWatchSession()

    private var session: WCSession? {
        WCSession.isSupported() ? WCSession.default : nil
    }

    var isWatchAppInstalled: Bool {
        session?.isWatchAppInstalled ?? false
    }

    var isReachable: Bool {
        session?.isReachable ?? false
    }

    var isPaired: Bool {
        session?.isPaired ?? false
    }

    var activationState: WCSessionActivationState {
        session?.activationState ?? .notActivated
    }

    var delegate: WCSessionDelegate? {
        get { session?.delegate }
        set { session?.delegate = newValue }
    }

    func activate() {
        session?.activate()
    }

    func sendMessage(
        _ message: [String: Any],
        replyHandler: (([String: Any]) -> Void)?,
        errorHandler: ((Error) -> Void)?
    ) {
        session?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }

    @discardableResult
    func transferUserInfo(_ userInfo: [String: Any]) -> WCSessionUserInfoTransfer? {
        session?.transferUserInfo(userInfo)
    }

    func updateApplicationContext(_ applicationContext: [String: Any]) throws {
        try session?.updateApplicationContext(applicationContext)
    }
}
