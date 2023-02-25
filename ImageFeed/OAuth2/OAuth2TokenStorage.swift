import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let keyChainStorage = KeychainWrapper.standard
    
    var token: String? {
        get {
            keyChainStorage.string(forKey: .bearerToken)
        }
        set {
            if let token = newValue {
                keyChainStorage.set(token, forKey: .bearerToken)
            } else {
                keyChainStorage.removeObject(forKey: .bearerToken)
            }
        }
    }
}

extension String {
    static let bearerToken = "bearerToken"
}
