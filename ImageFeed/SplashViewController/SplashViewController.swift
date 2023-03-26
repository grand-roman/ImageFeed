import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    static let shared = SplashViewController()
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let ypLaunchLogo = UIImageView(image: .ypLaunchLogo).withConstraints()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkToken()
    }
    //MARK: SetupUI
    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(ypLaunchLogo)
        
        NSLayoutConstraint.activate([
            ypLaunchLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ypLaunchLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    //MARK: Private Methods
    private func checkToken() {
        if oAuth2TokenStorage.token != nil {
            fetchProfile()
        } else {
            switchToAuthViewController()
        }
    }
    
    private func fetchProfile() {
        profileService.fetchProfile { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                self.showAlert(on: self)
                print(error.localizedDescription)
            }
        }
    }
    
    private func switchToAuthViewController() {
        guard let authVC = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authVC.delegate = self
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarController")
        window.rootViewController = tabBarController
    }
    
    func showAlert(on vc: UIViewController) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ок", style: .cancel)
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}
//MARK: Extension SplashVC
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let token):
                print("✅ token - \(token)")
                self.oAuth2TokenStorage.token = token
                self.fetchProfile()
            case .failure(let error):
                print(error)
                UIBlockingProgressHUD.dismiss()
                self.showAlert(on: self)
            }
        }
    }
}
