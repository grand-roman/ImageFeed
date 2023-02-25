import Foundation

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get { userDefaults.string(forKey: .bearerToken) }
        set { userDefaults.set(newValue, forKey: .bearerToken) }
    }
}

extension String {
    static let bearerToken = "bearerToken"
}
