//
//  FavoritesStorageView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit
import VKID

protocol FavoritesStorageViewProtocol: AnyObject {
    func displaySavedNews(_ news: [NewsEntity])
    func showAlert()
}

class FavoritesStorageView: UIViewController, FavoritesStorageViewProtocol, UISearchBarDelegate {
    // MARK: - Properties
    var presenter:  FavoritesStoragePresenterProtocol!
    
    var vkid: VKID!
    
    lazy var FavouriteCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 20, height: view.frame.height - 180)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .darkGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FavouriteCustomCell.self, forCellWithReuseIdentifier: FavouriteCustomCell.reuseId)
        
        // Настройка UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        return collectionView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = .systemGray6
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.searchTextField.rightView?.tintColor = .gray
        
        searchBar.backgroundColor = .newLightGrey
        // searchBar.searchTextField.clipsToBounds = true
        searchBar.searchBarStyle = .minimal
        // searchBar.showsCancelButton = true
        //searchBar.backgroundImage = UIImage()
        
        return searchBar
    }()
    
    lazy var FavouriteLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Избранное"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 34, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(FavouriteCollection,FavouriteLabel)
        view.backgroundColor = .white
        //        presenter.configureVKID(vkid: VKID)
        setupConstaints()
        presenter.loadFavorites()
        setupNavigationBar()
    }
    
    func displaySavedNews(_ news: [NewsEntity]) {
        presenter.favorites = news
        FavouriteCollection.reloadData()
    }
    
    private func setupConstaints() {
                NSLayoutConstraint.activate([
                    FavouriteCollection.topAnchor.constraint(equalTo: FavouriteLabel.bottomAnchor, constant: 15),
                    FavouriteCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    FavouriteCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    FavouriteCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
                    FavouriteLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    FavouriteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    FavouriteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
                    FavouriteLabel.heightAnchor.constraint(equalToConstant: 40),
        
                ])
//        NSLayoutConstraint.activate([
//            //SearchBar
//            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
//            searchBar.heightAnchor.constraint(equalToConstant: 40),
//            
//            //Лейбл "Новости"
//            FavouriteLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
//            FavouriteLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
//            FavouriteLabel.heightAnchor.constraint(equalToConstant: 70),
//            
//            //Коллекция
//            FavouriteCollection.topAnchor.constraint(equalTo: FavouriteLabel.bottomAnchor),
//            FavouriteCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            FavouriteCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            FavouriteCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
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
    
    // MARK: - @objc Func
    
    //функция для рефрешера
    @objc private func refreshData() {
        presenter.loadFavorites()
        // останавливаю анимацию прямо во view
        FavouriteCollection.refreshControl?.endRefreshing()
    }
    //для кнопочки выхода
    @objc func actionButtonTapped() {
        print("Кнопка нажата")
        presenter.handleActionButtonTap()
    }
}

// MARK: - extension для коллекции
extension FavoritesStorageView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteCustomCell.reuseId, for: indexPath) as! FavouriteCustomCell
        let savedNews = presenter.favorites[indexPath.item]
        cell.configureElements(items: savedNews)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // MARK: - выбор элемента в коллекции, здесь может быть добавлен переход к выбранной новости или ее удаление
        //Добавил метод для удаления
        let selectedNews = presenter.favorites[indexPath.item]
        presenter.deleteFavoriteNews(selectedNews)
        //
        FavouriteCollection.reloadData()
        print("Новость удалена: \(selectedNews.title ?? "Без заголовка")")
    }
}
