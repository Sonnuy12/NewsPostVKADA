//
//  NewsView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit

protocol NewsViewProtocol: AnyObject {
    func updateNewsList(_ news: [NewsEntity])
    func reloadData()
    func showAlert()
}

class NewsView: UIViewController, NewsViewProtocol, UISearchBarDelegate {
    
    // MARK: - Properties
    lazy var newsCollection: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 20, height: view.frame.height - 180)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .darkGray // в процессе появления коллекций с данными изменить цвет на белый
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CustomNewsCell.self, forCellWithReuseIdentifier: CustomNewsCell.reuseId)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    //    lazy var searchControll: UISearchController = {
    //        $0.searchBar.delegate = self
    //        $0.obscuresBackgroundDuringPresentation = false
    //        $0.searchBar.placeholder = "Search"
    //        $0.searchBar.searchTextField.backgroundColor = .systemGray6
    //        $0.searchBar.searchTextField.leftView?.tintColor = .gray
    //        $0.searchBar.searchTextField.rightView?.tintColor = .gray
    //        navigationItem.searchController = $0
    //        definesPresentationContext = true
    //        return $0
    //    }(UISearchController(searchResultsController: nil))
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = .systemGray6
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.searchTextField.rightView?.tintColor = .gray
        return searchBar
    }()
    
    lazy var NewsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Новости"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 34, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 17.5
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: presenter.imageUser)
        profileImageView.backgroundColor = .systemGray5
        profileImageView.contentMode = .scaleAspectFill
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = presenter.nameUser
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .black
        
        let actionButton = UIButton(type: .system)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        actionButton.tintColor = UIColor.black
        //actionButton.setTitleColor(.systemBlue, for: .normal)
        //actionButton.frame.size = CGSize(width: 20.0, height: 6.0)
       // actionButton.backgroundColor = .red
        actionButton.imageView?.contentMode = .scaleAspectFill
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(actionButton)
        
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 10),
            actionButton.widthAnchor.constraint(equalToConstant: 24)
            
        ])
        
        return view
    }()
    //желательно использовать опционал и потом все адаптировать под его исп(добавить "?" и "??")
    var presenter: NewsPresenterProtocol!
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(headerView, searchBar, newsCollection,NewsLabel)
        view.backgroundColor = .white
        presenter?.loadData()
        setupConstaints()
    }
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            // HeaderView
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            // SearchBar
            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            // Лейбл "Новости"
            NewsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            NewsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            NewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            NewsLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Коллекция
            newsCollection.topAnchor.constraint(equalTo: NewsLabel.bottomAnchor, constant: 15),
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
            print("ОК нажата")
        }
        
        // Кнопка "Отмена"
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            print("Отмена нажата")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        
        // Показать алерт
        present(alertController, animated: true, completion: nil)
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


