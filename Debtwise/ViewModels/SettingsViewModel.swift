import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var currentTheme: AppTheme
    @Published var showResetAlert: Bool = false
    
    private let themeManager: ThemeManager
    private let debtRepository: DebtRepositoryProtocol
    private let storageService: StorageService
    private var cancellables = Set<AnyCancellable>()
    
    init(
        themeManager: ThemeManager = .shared,
        debtRepository: DebtRepositoryProtocol = DebtRepository.shared,
        storageService: StorageService = .shared
    ) {
        self.themeManager = themeManager
        self.debtRepository = debtRepository
        self.storageService = storageService
        self.currentTheme = themeManager.currentTheme
        
        setupBindings()
    }
    
    private func setupBindings() {
        $currentTheme
            .dropFirst()
            .sink { [weak self] theme in
                self?.themeManager.currentTheme = theme
            }
            .store(in: &cancellables)
    }
    
    func resetAllData() {
        storageService.clearData()
        debtRepository.clearAll()
    }
}
