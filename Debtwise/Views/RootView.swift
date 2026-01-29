import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Group {
            switch viewModel.appState {
            case .loading:
                ProgressView()
                    .onAppear {
                        viewModel.checkInitialState()
                    }
            case .browser(let link):
                BrowserView(destination: link)
            case .main:
                TabBarView()
            }
        }
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}
