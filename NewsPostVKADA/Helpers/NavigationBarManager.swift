//
//  NavigationBarManager.swift
//  NewsPostVKADA
//
//  Created by сонный on 21.12.2024.
//
//ЭТО ПОКА НЕ РАБОТАЕТ 
import UIKit
import VKID

protocol NavigationBarConfigurable {
    func setupNavigationBar(userDetails: [(firstName: String?, lastName: String?, avatar: String?)])
}

extension NavigationBarConfigurable where Self: UIViewController {
    func setupNavigationBar(userDetails: [(firstName: String?, lastName: String?, avatar: String?)]) {
        NavigationBarManager.setupNavigationBar(for: self, userDetails: userDetails)
    }
}

class NavigationBarManager {
    static func setupNavigationBar(for viewController: UIViewController, userDetails: [(firstName: String?, lastName: String?, avatar: String?)]) {
        // Создаем контейнер для фото и имени
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // Фото профиля
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 17.5
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .systemGray5
        profileImageView.contentMode = .scaleAspectFill

        // Имя пользователя
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .black

        if let user = userDetails.first {
            let fullUserName = "\(user.firstName ?? "Unknown") \(user.lastName ?? "Unknown")"
            nameLabel.text = fullUserName
            
            if let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {
                URLSession.shared.dataTask(with: avatarURL) { data, _, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        profileImageView.image = UIImage(data: data)
                    }
                }.resume()
            } else {
                profileImageView.image = UIImage(systemName: "person.circle")
            }
        } else {
            nameLabel.text = "Гость"
            profileImageView.image = UIImage(systemName: "person.circle")
        }

        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])

        let leftBarButton = UIBarButtonItem(customView: containerView)
        viewController.navigationItem.leftBarButtonItem = leftBarButton

        // Кнопка справа
        let actionButton = UIButton(type: .system)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        actionButton.tintColor = .black
        
        // Важная часть: проверяем, какой класс сейчас
        if let newsView = viewController as? NewsView {
            actionButton.addTarget(newsView, action: #selector(newsView.actionButtonTapped), for: .touchUpInside)
        } else if let errorNilVkViewController = viewController as? ErrorNilVkView  {
            actionButton.addTarget(errorNilVkViewController, action: #selector(errorNilVkViewController.actionButtonTapped), for: .touchUpInside)
        } else if let favoritesStorageView = viewController as? FavoritesStorageView {
            actionButton.addTarget(favoritesStorageView, action: #selector(favoritesStorageView.actionButtonTapped), for: .touchUpInside)
        }

        let rightBarButton = UIBarButtonItem(customView: actionButton)
        viewController.navigationItem.rightBarButtonItem = rightBarButton
    }
}
