//
//  AppDelegate.swift
//  AmakaFlowCompanion
//
//  Handles APNs push notification registration and silent push delivery (AMA-567).
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    /// Weak reference to the workouts view model, set by AmakaFlowCompanionApp on launch.
    /// Used to await sync completion before calling the silent push completion handler.
    weak var workoutsViewModel: WorkoutsViewModel?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        // Skip push registration in E2E test mode
        #if DEBUG
        if TestAuthStore.shared.isTestModeEnabled {
            print("[AppDelegate] Test mode — skipping push notification registration")
            return true
        }
        #endif

        requestPushPermission(application)
        return true
    }

    // MARK: - Push Permission

    private func requestPushPermission(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            if let error = error {
                print("[AppDelegate] Push permission error: \(error.localizedDescription)")
                return
            }
            print("[AppDelegate] Push permission granted: \(granted)")
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }

    // MARK: - APNs Token Registration

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("[AppDelegate] APNs token: \(tokenString.prefix(16))...")

        Task {
            await PairingService.shared.registerAPNsToken(tokenString)
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("[AppDelegate] Failed to register for push: \(error.localizedDescription)")
    }

    // MARK: - Silent Push Handling

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print("[AppDelegate] Silent push received: \(userInfo)")

        // Post notification for any foreground observers
        NotificationCenter.default.post(name: .refreshPendingWorkouts, object: nil, userInfo: userInfo)

        // Await the actual sync before telling iOS we're done,
        // so the system doesn't suspend us mid-fetch
        Task { @MainActor in
            if let vm = self.workoutsViewModel {
                await vm.checkPendingWorkouts()
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
        }
    }
}

// MARK: - Notification Name

extension Notification.Name {
    static let refreshPendingWorkouts = Notification.Name("refreshPendingWorkouts")
}
