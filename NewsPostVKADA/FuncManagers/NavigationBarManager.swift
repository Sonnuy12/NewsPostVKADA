//
//  NavigationBarManager.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//


import UIKit

final class NavigationBarManager {
    
    static func configureNavigationBar(for viewController: UIViewController, withAction action: Selector) {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Фотография пользователя
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
        
        // Загрузка данных пользователя
        let userDetails = CoreDataManager.shared.fetchUserDetails()
        if let user = userDetails.first {
            let fullUserName = "\(user.firstName ?? "Unknown") \(user.lastName ?? "Unknown")"
            nameLabel.text = fullUserName
            
            if let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {
                URLSession.shared.dataTask(with: avatarURL) { data, _, _ in
                    guard let data = data else { return }
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
        
        // Добавление фото и имени в контейнер
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        
        // Настройка расположения
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        // Установка контейнера в navigationItem.titleView
        let barButtonItem = UIBarButtonItem(customView: containerView)
        viewController.navigationItem.leftBarButtonItem = barButtonItem
        
        // Настройка правой кнопки
        let actionButton = UIButton(type: .system)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        actionButton.tintColor = .black
        actionButton.imageView?.contentMode = .scaleAspectFill
        actionButton.addTarget(viewController, action: action, for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: actionButton)
        viewController.navigationItem.rightBarButtonItem = rightBarButton
    }
}
