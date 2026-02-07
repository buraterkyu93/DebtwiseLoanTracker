import Foundation
import Combine
import UIKit
import StoreKit

enum AppState {
    case loading
    case browser(String)
    case main
}

final class RootViewModel: ObservableObject {
    @Published private(set) var appState: AppState = .loading
    
    private let storageService: StorageService
    private let networkService: NetworkService
    
    init(
        storageService: StorageService = .shared,
        networkService: NetworkService = .shared
    ) {
        self.storageService = storageService
        self.networkService = networkService
    }
    
    func checkInitialState() {
        if storageService.getToken() != nil,
           let savedLink = storageService.getLink() {
            appState = .browser(savedLink)
            
            if !storageService.wasRatingDialogShown() {
                storageService.markRatingDialogShown()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.requestAppReview()
                }
            }
            return
        }
        
        Task {
            await fetchServerData()
        }
    }
    
    private func requestAppReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    @MainActor
    private func fetchServerData() async {
        do {
            let response = try await networkService.fetchServerData()
            
            if response.contains("#") {
                let components = response.components(separatedBy: "#")
                if components.count == 2 {
                    let token = components[0]
                    let link = components[1]
                    
                    storageService.saveToken(token)
                    storageService.saveLink(link)
                    
                    appState = .browser(link)
                    return
                }
            }
            
            appState = .main
        } catch {
            appState = .main
        }
    }
}
