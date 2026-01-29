import UIKit
import OneSignalFramework
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        application.applicationIconBadgeNumber = 0
        
        UNUserNotificationCenter.current().delegate = self
                
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
            
        }
        
        OneSignal.initialize("dcb225d5-9a70-4449-b7b4-57dcf025423c", withLaunchOptions: launchOptions)
        
        OneSignal.Notifications.requestPermission({ accepted in
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }, fallbackToSettings: true)
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {}
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {}
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
}
