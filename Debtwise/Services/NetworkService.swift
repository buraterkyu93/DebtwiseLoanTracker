import Foundation
import UIKit

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchServerData() async throws -> String {
        let osVersion = UIDevice.current.systemVersion
        let language = getSystemLanguage()
        let deviceModel = getDeviceModel()
        let country = getCountryCode()
        
        var components = URLComponents(string: "https://aprulestext.site/ios-debtwise-loantracker/server.php")!
        components.queryItems = [
            URLQueryItem(name: "p", value: "Bs2675kDjkb5Ga"),
            URLQueryItem(name: "os", value: osVersion),
            URLQueryItem(name: "lng", value: language),
            URLQueryItem(name: "devicemodel", value: deviceModel),
            URLQueryItem(name: "country", value: country)
        ]
        
        guard let link = components.url else {
            throw NetworkError.invalidLink
        }
        
        var request = URLRequest(url: link)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let response = String(data: data, encoding: .utf8) else {
            throw NetworkError.invalidResponse
        }
        
        return response
    }
    
    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0)
            }
        }
        return modelCode ?? "iPhone"
    }
    
    private func getSystemLanguage() -> String {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        if let languageCode = preferredLanguage.components(separatedBy: "-").first {
            return languageCode
        }
        return "en"
    }
    
    private func getCountryCode() -> String {
        return Locale.current.region?.identifier ?? "US"
    }
}

enum NetworkError: Error {
    case invalidLink
    case invalidResponse
}
