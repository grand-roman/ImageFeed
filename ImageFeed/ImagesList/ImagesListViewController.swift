import UIKit

final class ImagesListViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet private var tableView: UITableView!
    //MARK: Private
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photosName = [String]()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var photos: [Photo] = []
    private var imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
            })
        imagesListService.fetchPhotosNextPage()
        
    }
    //MARK: Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleViewController
            let indexPath = sender as! IndexPath
            let imageURL = URL(string: photos[indexPath.row].largeImageURL)
            viewController.image = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCountPhoto = photos.count
        let newCountPhoto = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCountPhoto != newCountPhoto {
            tableView.performBatchUpdates {
                let indexPaths = (oldCountPhoto..<newCountPhoto).map { index in
                    IndexPath(row: index, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.prepareForReuse()
        let photo = photos[indexPath.row]
        cell.setupCellConfig(with: photo) { [weak self] in 
            guard let self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.dateLabel.text = photo.createdAt?.string(format: "dd MMMM yyyy")
        cell.setIsLiked(photo.isLiked)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.gradientView.bounds
        gradientLayer.colors = [UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0).cgColor, UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0.2).cgColor]
        cell.gradientView.layer.addSublayer(gradientLayer)
    }
}
//MARK: Extensions
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                UIBlockingProgressHUD.dismiss()
                SplashViewController.shared.showAlert(on: self)
            }
        }
    }
}
