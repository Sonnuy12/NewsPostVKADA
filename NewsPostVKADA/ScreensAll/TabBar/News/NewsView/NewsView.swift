//
//  NewsView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit
import VKID

protocol NewsViewProtocol: AnyObject {
    func updateNewsList(_ news: [NewsEntity])
    func reloadData()
    func showAlert()
    func out()
}

class NewsView: UIViewController, NewsViewProtocol, UISearchBarDelegate {
    
    // MARK: - Properties
    //желательно использовать опционал и потом все адаптировать под его исп(добавить "?" и "??")
    var presenter: NewsPresenterProtocol!
    
    lazy var newsCollection: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 20, height: view.frame.height - 180)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .red // в процессе появления коллекций с данными изменить цвет на белый
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CustomNewsCell.self, forCellWithReuseIdentifier: CustomNewsCell.reuseId)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
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
    
    
    lazy var newsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "  Новости"
        $0.textAlignment = .left
        $0.textColor = .black
        //$0.backgroundColor = .red
        $0.font = .systemFont(ofSize: 34, weight: .bold)
        $0.numberOfLines = 0
        $0.backgroundColor = .red
        return $0
    }(UILabel())
    
    private func setupNavigationBar() {
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //1)фотка
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 17.5
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: presenter.imageUser)
        profileImageView.backgroundColor = .systemGray5
        profileImageView.contentMode = .scaleAspectFill
        //2)имя
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = presenter.nameUser
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .black
        
        //3)добавляемя фотку и имя в контейнер
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        //4)настраиваем положнеи фотки и имени
        NSLayoutConstraint.activate([
            // Картинка слева
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -30),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            // Лейбл справа от картинки
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
        ])
        //5)устанавливаем контейнер с фоткой и именем в navigationItem.titleView
        containerView.backgroundColor = .red
        self.navigationItem.titleView = containerView
        
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
    }
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationController?.navigationBar.barTintColor = UIColor.red
        //        navigationController?.navigationItem.titleView?.backgroundColor = .blue
        view.addSubViews(searchBar, newsCollection, newsLabel)
        view.backgroundColor = .newLightGrey
        presenter?.loadData()
        setupNavigationBar()
        setupConstaints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            //SearchBar
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            //Лейбл "Новости"
            newsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            //            newsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            //            newsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newsLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            newsLabel.heightAnchor.constraint(equalToConstant: 70),
            
            //Коллекция
            newsCollection.topAnchor.constraint(equalTo: newsLabel.bottomAnchor),
            newsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func updateNewsList(_ news: [NewsEntity]) {
        presenter?.newsList = news
        newsCollection.reloadData()
    }
    func showAlert() {
        let alertController = UIAlertController(
            title: "Заголовок",
            message: "Вы хотите выполнить действие?",
            preferredStyle: .alert
        )
        
        // Кнопка "ОК"
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
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
    
    
//Функция для выхода из акка 
    func out() {
        //здесь или в презенторе должна быть функция для выхода из акка, но он не работает, нужно преедавать переменные и тд
//        sessions.logout { result in
//            print("Did logout from \(sessions) with \(result)")
//        }
        
        print("Отпустите меня пожалуйста")
    }
    
    @objc func actionButtonTapped() {
        print("Кнопка нажата")
        presenter.handleActionButtonTap()
    }
    
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterNews(searchText) // Обновляем данные при изменении текста
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.filterNews("") // Сбрасываем фильтр при отмене поиска
    }
    
    func reloadData() {
        newsCollection.reloadData()
    }
}
// MARK: - extension для коллекции
extension NewsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomNewsCell.reuseId, for: indexPath) as! CustomNewsCell
        let news = presenter.newsList[indexPath.item]
        cell.newsImage.image = UIImage(named: news.imageURL)
        cell.datePublication.text = news.datePublicationPost?.description
        cell.mainLabel.text = news.title
        cell.descriptionLabel.text = news.descriptionText
        cell.websiteLabel.text = news.website
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = presenter.newsList[indexPath.item]
        print(selectedNews)
    }
}


