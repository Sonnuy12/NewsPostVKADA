//
//  ErrorNilVkView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit
import VKID

protocol ErrorNilVkViewProtocol: AnyObject {
    func updateVKNews(_ news: [ModelVKNews])
    func showError(_ message: String)
    
    func showAlert()
}

class ErrorNilVkView: UIViewController, ErrorNilVkViewProtocol {
    // MARK: - Properties
    var presenter:  ErrorNilVkPresenterProtocol!
    var vkid: VKID!
  
    //MARK: - Создание кастомной коллекции
    lazy var VkNewsCollection: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 20, height: view.frame.height - 180)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        $0.delegate = self
        $0.dataSource = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CustomVKNewsCell.self, forCellWithReuseIdentifier: CustomVKNewsCell.reuseId)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новости"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(VkNewsCollection)
        view.backgroundColor = .green
        presenter?.fetchVKNews()
        setupNavigationBar()
        setupConstaints()

    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            VkNewsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            VkNewsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            VkNewsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            VkNewsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func updateVKNews(_ news: [ModelVKNews]) {
        presenter?.VKNewsList = news
        VkNewsCollection.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupNavigationBar() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //1)фотка
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 17.5
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .systemGray5
        profileImageView.contentMode = .scaleAspectFill
        //2)имя
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .black
        
        let userDetails = CoreDataManager.shared.fetchUserDetails()
        
        if let user = userDetails.first {
            // Отображение имени пользователя
            let fullUserName = "\(user.firstName ?? "Unknown") \(user.lastName ?? "Unknown")"
            nameLabel.text = fullUserName
            nameLabel.layoutIfNeeded()
            
            // Отображение аватара пользователя
            if let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {
                // Загрузка изображения асинхронно
                URLSession.shared.dataTask(with: avatarURL) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Ошибка загрузки изображения: \(String(describing: error))")
                        return
                    }
                    DispatchQueue.main.async {
                        profileImageView.image = UIImage(data: data)
                        profileImageView.layoutIfNeeded()
                    }
                    //profileImageView.image = UIImage(data: data)
                }.resume()
            } else {
                profileImageView.image = UIImage(systemName: "person.circle") // Изображение по умолчанию
            }
        } else {
            // Действия по умолчанию, если данных в Core Data нет
            nameLabel.text = "Гость"
            profileImageView.image = UIImage(systemName: "person.circle")
        }
        
        //3)добавляемя фотку и имя в контейнер
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        //4)настраиваем положнеи фотки и имени
        NSLayoutConstraint.activate([
            // Картинка слева
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            // Лейбл справа от картинки
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
        ])
        //5)устанавливаем контейнер с фоткой и именем в navigationItem.titleView
        containerView.backgroundColor = .red
        let barButtonItem = UIBarButtonItem(customView: containerView)
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        //6)создаем кнопочку
        let actionButton = UIButton(type: .system)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        actionButton.tintColor = .black
        actionButton.imageView?.contentMode = .scaleAspectFill
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        //7)лепим кнопочку вправо
        let rightBarButton = UIBarButtonItem(customView: actionButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        func updateUserProfile() {
            let userDetails = CoreDataManager.shared.fetchUserDetails()
            
            if let user = userDetails.first {
                let fullUserName = "\(user.firstName ?? "Unknown") \(user.lastName ?? "Unknown")"
                nameLabel.text = fullUserName
                
                if let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {
                    URLSession.shared.dataTask(with: avatarURL) { data, response, error in
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
        }
    }
    func showAlert() {
        let alertController = UIAlertController(
            title: "Выйти",
            message: "Вы действительно хотите выйти из аккаунта?",
            preferredStyle: .alert
        )
        // Кнопка "ОК"
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            //            self.presenter.configureVKID(vkid: self.vkid)
            self.presenter.logOut()
        }
        // Кнопка "Отмена"
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            print("Отмена нажата")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Показать алерт
        present(alertController, animated: true, completion: nil)
    }
   
    
    @objc func actionButtonTapped() {
        print("Кнопка нажата")
        presenter.handleActionButtonTap()
    }
}
// MARK: - extension для коллекции
extension ErrorNilVkView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.VKNewsList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomNewsCell.reuseId, for: indexPath) as! CustomVKNewsCell
        let news = presenter.VKNewsList[indexPath.item]
        cell.configure(with: news)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = presenter.VKNewsList[indexPath.item]
        print(selectedNews)
    }
   
}
