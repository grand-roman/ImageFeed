import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get { OAuth2TokenStorage().token }
        set { OAuth2TokenStorage().token = newValue }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        let task = urlSession.dataTask(type: OAuthTokenResponseBody.self, for: request) { [weak self] result in
            switch result {
            case .success(let body):
                self?.authToken = body.accessToken
                completion(.success(body.accessToken))
                self?.task = nil
            case .failure(let error):
                completion(.failure(error))
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
    }
}

//MARK: OAuth2Servise
extension OAuth2Service {
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(myAccessKey)"
            + "&&client_secret=\(mySecretKey)"
            + "&&redirect_uri=\(myRedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: .POST,
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
    }
}




