import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private let profileImageView = UIImageView(image: .profileImage).withConstraints()
    private let profileNameLabel = UILabel(text: "", font: .ysBold(23))
    private let loginNameLabel = UILabel(text: "", textColor: .ypGray)
    private let profileDescription = UILabel(text: "")
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self else { return }
                    self.updateAvatar()
                }
        updateAvatar()
        setupUI()
        updateProfileInfo(profile: profileService.profile)
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: profileImageView.frame.size.height / 2)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "ProfilePlaceholder"),
                                     options: [.processor(processor)]) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                self.profileImageView.image = model.image
                self.profileImageView.backgroundColor = .clear
            case .failure(let error):
                print(error)
                self.updateAvatar()
            }
        }
    }
    
    private func updateProfileInfo(profile: ProfileService.Profile?) {
        profileNameLabel.text = profile?.name ?? "Your name"
        loginNameLabel.text = profile?.loginName ?? "@user"
        profileDescription.text = profile?.bio
    }
    
    //Общий метод для отображения всех View на экране
    func setupUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
        view.backgroundColor = .ypBlack
        view.addSubview(profileImageView)
        //Проверка на наличие изображения для кнопки Logout. Если ее нет, метод ничего не отобразит, но в консоль напечатает из-за чего это произошло.
        let buttonImage = UIImage(named: "ProfileExitImage")
        guard let buttonImage else {
            print("Ошибка загрузки изображения для кнопки Logout")
            return
        }
        //Настройка кнопки выхода из профиля
        let button = UIButton.systemButton(with: buttonImage,
                                           target: self,
                                           action: #selector(didTapLogoutButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        //Настройка StackView для всех Label(Имя, Ник, Описание)
        let profileLabelStackView = UIStackView(arrangedSubviews: [profileNameLabel,
                                                                   loginNameLabel,
                                                                   profileDescription])
        profileLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLabelStackView)
        profileLabelStackView.spacing = 8
        profileLabelStackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.centerYAnchor.constraint(equalTo:  profileImageView.centerYAnchor ),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            profileLabelStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileLabelStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileLabelStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])
    }
    
    private func logout() {
        OAuth2TokenStorage().clearToken()
        WebViewViewController.clean()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration")}
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    @objc
    private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Выход из профиля",
            message: "Вы уверены?",
            preferredStyle: .alert)
        let noButton = UIAlertAction(title: "Нет", style: .cancel)
        let yesButton = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            self.logout()
        }
        alert.addAction(noButton)
        alert.addAction(yesButton)
        present(alert, animated: true)
    }
}
