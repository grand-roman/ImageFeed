import UIKit

final class ProfileViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    //Общий метод для отображения всех View на экране
    func setupUI() {
        
        //Отображение изображения профиля
        let profileImage = UIImage(named: "ProfilePhoto")
        let profileImageView = UIImageView(image: profileImage)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
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
        
        //Настройка имени пользователя
        let profileNameLabel = UILabel()
        profileNameLabel.text = "Екатерина Новикова"
        profileNameLabel.textColor = .ypWhite
        profileNameLabel.font = UIFont(name: "YandexSansDisplay-Bold", size: 23)
        
        //Настройка никнейма пользователя
        let userNameLabel = UILabel()
        userNameLabel.text = "@ekaterina_nov"
        userNameLabel.textColor = .ypGray
        userNameLabel.font = UIFont(name: "YandexSansDisplay-Regular", size: 13)
        
        //Настройка описания профиля пользователя
        let profileDescription = UILabel()
        profileDescription.text = "Описание"
        profileDescription.textColor = .ypWhite
        profileDescription.font = UIFont(name: "YandexSansDisplay-Regular", size: 13)
        
        //Настройка StackView для всех Label(Имя, Ник, Описание)
        let profileLabelStackView = UIStackView(arrangedSubviews: [profileNameLabel,
                                                                   userNameLabel,
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
    
    //Заглушка для настройки кнопки. Пока не используется
    @objc
    private func didTapLogoutButton() {}
}
