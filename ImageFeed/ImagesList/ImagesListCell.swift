import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!

    //Функция для обнуления gradientView
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
        self.gradientView.layer.sublayers = nil
    }
    
    func setupCellConfig(with photo: Photo, completion: @escaping () -> Void) {
        guard let thumbPhotoUrl = URL(string: photo.thumbImageURL),
              let imagePlaceholder = UIImage(named: "ImagePlaceholder") else {
            return
        }
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: thumbPhotoUrl, placeholder: imagePlaceholder) { _,_ in
           completion()
        }
    }
    
    func setIsLiked(_ isLiked: Bool) {
        guard
            let activeLikeImage = UIImage(named: "ActiveLikeButton"),
            let notActiveLikeImage = UIImage(named: "NotActiveLikeButton")
        else { return }
        
        let likeIcon = isLiked ? activeLikeImage : notActiveLikeImage
        likeButton.setImage(likeIcon, for: .normal)
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
