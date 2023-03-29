import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}

struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
    
    func convertToPhoto() -> Photo {
        Photo(id: id, size: CGSize(width: width, height: height),
              createdAt: createdAt.date(format: "yyyy-MM-dd'T'HH:mm:ssZ"), welcomeDescription: description,
              thumbImageURL: self.urls.thumb, largeImageURL: self.urls.full,
              isLiked: likedByUser)
    }
}

extension String {
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func string(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
