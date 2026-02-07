import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $viewModel.currentTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.showResetAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Reset All Data")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Data", isPresented: $viewModel.showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    viewModel.resetAllData()
                }
            } message: {
                Text("Are you sure you want to reset all data? This action cannot be undone.")
            }
        }
    }
}
