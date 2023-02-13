import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    @IBOutlet private var logoutButton: UIButton!

    @IBAction private func didTapLogoutButton() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        configureView()
        addSubview()
        makeConstraints()
    }
    
    private func configureView() {
        let avatarImage = UIImageView()
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.image = UIImage(named: "avatar")
        self.avatarImageView = avatarImage
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .systemBackground
        nameLabel.font = .systemFont(ofSize: 23, weight: .medium)
        self.nameLabel = nameLabel
        
        let loginNameLabel = UILabel()
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.textColor = UIColor(named: "gray")
        self.loginNameLabel = loginNameLabel

        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .systemBackground
        self.descriptionLabel = descriptionLabel
        
        let logoutButton = UIButton()
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setBackgroundImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.addTarget(self, action: #selector(Self.didTapLogoutButton), for: .touchUpInside)
        self.logoutButton = logoutButton
    }
    
    private func addSubview() {
        view.addSubview(avatarImageView!)
        view.addSubview(nameLabel!)
        view.addSubview(loginNameLabel!)
        view.addSubview(descriptionLabel!)
        view.addSubview(logoutButton!)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: self.loginNameLabel.bottomAnchor, constant: 8),
            loginNameLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
