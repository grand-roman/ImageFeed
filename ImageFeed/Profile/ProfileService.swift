import Foundation

typealias ProfileBlock = (Result<ProfileService.Profile, Error>) -> Void

class ProfileService {
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    struct ProfileResult: Decodable {
        let username: String
        let firstName: String?
        let lastName: String?
        let bio: String?
        
        var profile: Profile {
            let name = [firstName, lastName].compactMap { $0 }.joined(separator: " ")
            return Profile(username: username,
                    name: name,
                    loginName: "@\(username)",
                    bio: bio)
        }
    }
    
    struct Profile {
        let username: String
        let name: String?
        let loginName: String?
        let bio: String?
    }
    func fetchProfile(completion: @escaping ProfileBlock) {
        let request = URLRequest.makeHTTPRequest(path: "me", token: OAuth2TokenStorage.shared.token)
        
        URLSession.shared.dataTask(type: ProfileResult.self, for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                completion(.success(model.profile))
                self.profile = model.profile
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
