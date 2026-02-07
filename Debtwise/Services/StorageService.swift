import Foundation

final class StorageService {
    static let shared = StorageService()
    
    private let tokenKey = "savedToken"
    private let linkKey = "savedLink"
    private let ratingShownKey = "ratingDialogShown"
    
    private init() {}
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func saveLink(_ link: String) {
        UserDefaults.standard.set(link, forKey: linkKey)
    }
    
    func getLink() -> String? {
        UserDefaults.standard.string(forKey: linkKey)
    }
    
    func clearData() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: linkKey)
    }
    
    func wasRatingDialogShown() -> Bool {
        UserDefaults.standard.bool(forKey: ratingShownKey)
    }
    
    func markRatingDialogShown() {
        UserDefaults.standard.set(true, forKey: ratingShownKey)
    }
}
