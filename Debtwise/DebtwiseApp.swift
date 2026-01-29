import SwiftUI

@main
struct DebtwiseApp: App {
    @StateObject private var themeManager = ThemeManager.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(themeManager.currentTheme.colorScheme)
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                }
        }
    }
}
