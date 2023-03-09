import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private var lastLoadedPage = 1
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        if task != nil { return }
        let nextPage = lastLoadedPage
        let request = URLRequest.makeHTTPRequest(
            path: "photos?page=\(nextPage)&per_page=10",
            token: OAuth2TokenStorage.shared.token
        )
        let task = URLSession.shared.dataTask(type: [PhotoResult].self, for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let photoResult):
                    self.lastLoadedPage += 1
                    self.photos.append(contentsOf: photoResult.map { $0.convertToPhoto() })
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    self.task = nil
                case .failure(let error):
                    print(error.localizedDescription)
                    self.task = nil
                }
            }
        }
        self.task = task
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        if task != nil { return }
        let request = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: isLike ? .POST : .DELETE,
            baseURL: defaultBaseURL,
            token: OAuth2TokenStorage.shared.token
        )
        let task = URLSession.shared.dataTask(type: LikeResult.self, for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async {
                guard
                    let self = self,
                    let index = self.photos.firstIndex(where: { $0.id == photoId })
                else { return }
                
                switch result {
                case .success(_):
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                    print("success✅")
                    self.task = nil
                    completion(.success(()))
                case .failure(let error):
                    print(error)
                    self.task = nil
                    completion(.failure(error))
                }
            }
        }
        self.task = task
    }
}

struct LikeResult: Decodable {
    let photo: PhotoResult
}
