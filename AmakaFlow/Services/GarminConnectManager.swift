//
//  GarminConnectManager.swift
//  AmakaFlow
//
//  Manages communication between iPhone and Garmin watches via Connect IQ SDK
//
//  SDK Integration Required:
//  1. Add to Podfile: pod 'ConnectIQ', '~> 1.0'
//  2. Run: pod install
//  3. Add URL scheme "amakaflow-ciq" to Info.plist
//  4. Uncomment the ConnectIQ imports and implementation below
//

import Foundation
import Combine

// MARK: - Garmin Connect Manager

/// Manages Garmin watch connectivity via Garmin Connect Mobile SDK
/// Mirrors functionality of WatchConnectivityManager for Apple Watch
@MainActor
class GarminConnectManager: NSObject, ObservableObject {
    static let shared = GarminConnectManager()

    // MARK: - Published State

    @Published private(set) var isConnected = false
    @Published private(set) var isAppInstalled = false
    @Published private(set) var connectedDeviceName: String?
    @Published private(set) var lastError: Error?

    // MARK: - Connect IQ References
    // Uncomment when ConnectIQ SDK is integrated:
    // private var connectIQ: ConnectIQ?
    // private var connectedDevice: IQDevice?
    // private var myApp: IQApp?

    /// AmakaFlow Connect IQ App UUID (must match manifest.xml in Garmin app)
    /// Generate a new UUID for production: https://www.uuidgenerator.net/
    private let appUUID = UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567890")!

    /// URL scheme for handling Garmin Connect IQ callbacks
    static let urlScheme = "amakaflow-ciq"

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    override init() {
        super.init()
        setupConnectIQ()
    }

    // MARK: - Setup

    private func setupConnectIQ() {
        // TODO: Uncomment when ConnectIQ SDK is integrated
        /*
        connectIQ = ConnectIQ.sharedInstance()
        connectIQ?.initialize(withUrlScheme: Self.urlScheme, uiOverrideDelegate: nil)
        connectIQ?.delegate = self
        */

        print("⌚ GarminConnectManager initialized (SDK integration pending)")
    }

    // MARK: - Device Discovery

    /// Shows the Garmin device selection UI
    /// User can select which Garmin watch to connect
    func showDeviceSelection() {
        // TODO: Uncomment when ConnectIQ SDK is integrated
        /*
        connectIQ?.showDeviceSelection()
        */

        print("⌚ Garmin device selection requested (SDK not integrated)")
    }

    /// Returns available Garmin devices
    func getKnownDevices() -> [String] {
        // TODO: Uncomment when ConnectIQ SDK is integrated
        /*
        guard let devices = connectIQ?.knownDevices() as? [IQDevice] else {
            return []
        }
        return devices.map { $0.friendlyName ?? $0.uuid.uuidString }
        */

        return []
    }

    // MARK: - Send State to Watch

    /// Broadcasts workout state to connected Garmin watch
    /// - Parameter state: Current workout state from WorkoutEngine
    func sendWorkoutState(_ state: WorkoutState) {
        guard isConnected else {
            print("⌚ Garmin not connected, skipping state broadcast")
            return
        }

        let message = buildStateMessage(from: state)

        // TODO: Uncomment when ConnectIQ SDK is integrated
        /*
        guard let device = connectedDevice,
              let app = myApp else {
            print("⌚ Garmin device or app not available")
            return
        }

        connectIQ?.sendMessage(message, to: device, with: app) { result in
            if result != .success {
                print("⌚ Failed to send state to Garmin: \(result)")
                Task { @MainActor in
                    self.lastError = GarminConnectError.messageFailed
                }
            }
        }
        */

        print("⌚ Would send Garmin state: \(message)")
    }

    /// Sends acknowledgment to watch after processing command
    func sendAck(_ ack: CommandAck) {
        guard isConnected else { return }

        let message: [String: Any] = [
            "action": "commandAck",
            "commandId": ack.commandId,
            "status": ack.status.rawValue,
            "errorCode": ack.errorCode ?? ""
        ]

        // TODO: Uncomment when ConnectIQ SDK is integrated
        /*
        guard let device = connectedDevice,
              let app = myApp else { return }

        connectIQ?.sendMessage(message, to: device, with: app, progress: nil) { _ in }
        */

        print("⌚ Would send Garmin ACK: \(message)")
    }

    // MARK: - Message Building

    private func buildStateMessage(from state: WorkoutState) -> [String: Any] {
        return [
            "action": "stateUpdate",
            "version": state.stateVersion,
            "workoutId": state.workoutId,
            "workoutName": state.workoutName,
            "phase": state.phase.rawValue,
            "stepIndex": state.stepIndex,
            "stepCount": state.stepCount,
            "stepName": state.stepName,
            "stepType": state.stepType.rawValue,
            "remainingMs": state.remainingMs ?? 0,
            "roundInfo": state.roundInfo ?? ""
        ]
    }

    // MARK: - Handle Messages from Watch

    /// Handles incoming messages from Garmin watch
    /// - Parameter message: Dictionary containing action and parameters
    func handleMessage(_ message: [String: Any]) {
        guard let action = message["action"] as? String else {
            print("⌚ Garmin message missing action: \(message)")
            return
        }

        print("⌚ Received Garmin message: \(action)")

        switch action {
        case "command":
            handleCommandMessage(message)

        case "requestState":
            handleStateRequest()

        default:
            print("⌚ Unknown Garmin action: \(action)")
        }
    }

    private func handleCommandMessage(_ message: [String: Any]) {
        guard let commandString = message["command"] as? String,
              let commandId = message["commandId"] as? String else {
            print("⌚ Invalid command message from Garmin")
            return
        }

        Task { @MainActor in
            WorkoutEngine.shared.handleRemoteCommand(commandString, commandId: commandId)
        }
    }

    private func handleStateRequest() {
        Task { @MainActor in
            let engine = WorkoutEngine.shared
            if engine.isActive {
                engine.sendStateToGarmin()
            } else {
                // Send idle state
                let idleState = WorkoutState(
                    stateVersion: 0,
                    workoutId: "",
                    workoutName: "",
                    phase: .idle,
                    stepIndex: 0,
                    stepCount: 0,
                    stepName: "",
                    stepType: .reps,
                    remainingMs: nil,
                    roundInfo: nil,
                    lastCommandAck: nil
                )
                sendWorkoutState(idleState)
            }
        }
    }

    // MARK: - URL Handling

    /// Handle URL callbacks from Garmin Connect app
    /// Call this from AppDelegate/SceneDelegate's URL handling
    func handleURL(_ url: URL) -> Bool {
        guard url.scheme == Self.urlScheme else { return false }

        // TODO: Uncomment when ConnectIQ SDK is integrated
        /*
        return connectIQ?.handle(url) ?? false
        */

        print("⌚ Would handle Garmin URL: \(url)")
        return false
    }

    // MARK: - Connection Management

    /// Attempts to connect to a known Garmin device
    func connectToDevice(withName name: String) {
        // TODO: Uncomment when ConnectIQ SDK is integrated
        /*
        guard let devices = connectIQ?.knownDevices() as? [IQDevice],
              let device = devices.first(where: { $0.friendlyName == name }) else {
            print("⌚ Device not found: \(name)")
            return
        }

        connectIQ?.register(forDevice: device, delegate: self)
        */

        print("⌚ Would connect to Garmin device: \(name)")
    }

    /// Disconnects from current Garmin device
    func disconnect() {
        isConnected = false
        connectedDeviceName = nil

        // TODO: Uncomment when ConnectIQ SDK is integrated
        /*
        if let device = connectedDevice {
            connectIQ?.unregister(forDevice: device)
        }
        connectedDevice = nil
        myApp = nil
        */

        print("⌚ Garmin disconnected")
    }
}

// MARK: - ConnectIQ Delegate Implementation
// Uncomment when ConnectIQ SDK is integrated

/*
extension GarminConnectManager: IQDeviceEventDelegate {

    func deviceStatusChanged(_ device: IQDevice, status: IQDeviceStatus) {
        Task { @MainActor in
            switch status {
            case .connected:
                self.connectedDevice = device
                self.connectedDeviceName = device.friendlyName ?? "Garmin Watch"
                self.isConnected = true
                self.registerForAppMessages(device)
                print("⌚ Garmin connected: \(self.connectedDeviceName ?? "Unknown")")

            case .notConnected, .bluetoothNotReady, .notFound:
                self.isConnected = false
                self.connectedDeviceName = nil
                self.connectedDevice = nil
                self.myApp = nil
                print("⌚ Garmin disconnected: \(status)")

            @unknown default:
                print("⌚ Garmin unknown status: \(status.rawValue)")
            }
        }
    }

    private func registerForAppMessages(_ device: IQDevice) {
        myApp = IQApp(uuid: appUUID, store: nil, device: device)

        connectIQ?.getAppStatus(myApp) { [weak self] status in
            Task { @MainActor in
                self?.isAppInstalled = (status == .installed)

                if status == .installed {
                    self?.connectIQ?.register(forAppMessages: self?.myApp, delegate: self)
                    print("⌚ Registered for Garmin app messages")
                } else {
                    print("⌚ AmakaFlow app not installed on Garmin watch")
                }
            }
        }
    }
}

extension GarminConnectManager: IQAppMessageDelegate {

    func receivedMessage(_ message: Any, from device: IQDevice, from app: IQApp) {
        if let dict = message as? [String: Any] {
            Task { @MainActor in
                self.handleMessage(dict)
            }
        }
    }
}
*/

// MARK: - Errors

enum GarminConnectError: LocalizedError {
    case sdkNotIntegrated
    case deviceNotConnected
    case appNotInstalled
    case messageFailed
    case invalidMessage

    var errorDescription: String? {
        switch self {
        case .sdkNotIntegrated:
            return "Garmin Connect IQ SDK is not integrated. Add ConnectIQ pod and uncomment SDK code."
        case .deviceNotConnected:
            return "No Garmin watch is connected. Open Garmin Connect app and ensure your watch is paired."
        case .appNotInstalled:
            return "AmakaFlow app is not installed on your Garmin watch. Install it from the Connect IQ Store."
        case .messageFailed:
            return "Failed to send message to Garmin watch."
        case .invalidMessage:
            return "Received invalid message from Garmin watch."
        }
    }
}
