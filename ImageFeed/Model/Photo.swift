import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
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
              createdAt: createdAt, welcomeDescription: description,
              thumbImageURL: self.urls.thumb, largeImageURL: self.urls.full,
              isLiked: likedByUser)
        
    }

}
