import Foundation

extension URLRequest {
    
    enum HTTPMethod: String { case GET, POST, DELETE, PUT }
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: HTTPMethod = .GET,
        baseURL: URL = defaultBaseURL,
        token: String? = nil
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod.rawValue
        if let token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

