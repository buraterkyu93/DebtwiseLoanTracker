import SwiftUI
import Combine

protocol ThemeManagerProtocol {
    var currentTheme: AppTheme { get set }
}

final class ThemeManager: ObservableObject, ThemeManagerProtocol {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: themeKey)
        }
    }
    
    private let themeKey = "appTheme"
    
    private init() {
        if let savedTheme = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppTheme(rawValue: savedTheme) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .system
        }
    }
}
