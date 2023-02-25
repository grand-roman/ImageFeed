import Foundation

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    private let task = URLSession.shared
    private(set) var avatarURL: String?
    
    struct UserResult: Decodable {
        let profileImage: SizeImage
        
    }
    
    struct SizeImage: Decodable {
        let small: String
        let medium: String
        let large: String
    }
    
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<ProfileImageService.UserResult, Error>) -> Void) {
        let request = URLRequest.makeHTTPRequest(path: "users/\(username)", token: OAuth2TokenStorage.shared.token)
        print(request)
        task.dataTask(type: UserResult.self, for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let image):
                completion(.success(image))
                
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                object: self,
                                                userInfo: ["URL": image])
                
                self.avatarURL = image.profileImage.small
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
