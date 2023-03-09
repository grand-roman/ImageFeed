import UIKit

final class SingleViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var fullImageView: UIImageView!
    
    var image: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        setImage()
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton() {
        let items = [image]
        let activityVC = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    func showError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать еще раз?",
            preferredStyle: .alert)
        let nopeButton = UIAlertAction(
            title: "Не надо",
            style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
            }
        let againButton = UIAlertAction(
            title: "Повторить",
            style: .default) { [weak self] _ in
                self?.setImage()
            }
        alert.addAction(nopeButton)
        alert.addAction(againButton)
        present(alert, animated: true)
    }
    
    func setImage() {
        UIBlockingProgressHUD.show()
        fullImageView.kf.setImage(with: image) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let imageModel):
                self.rescaleAndCenterImageInScrollView(image: imageModel.image)
            case .failure(let error):
                print(error)
                self.showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        fullImageView
    }
    
    //Метод для центровки изображения после зума
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0.0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}
