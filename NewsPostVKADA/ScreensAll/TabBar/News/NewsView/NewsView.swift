//
//  NewsView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit
import VKID
import SDWebImage

protocol NewsViewProtocol: AnyObject {
    func updateNewsList(_ news: [NewsArticle])
    func reloadData()
    func showAlert()
    func stopRefreshing()
    
}

class NewsView: UIViewController, NewsViewProtocol, UISearchBarDelegate, UIScrollViewDelegate {
    
    // MARK: - Properties
    var presenter: NewsPresenterProtocol!
    var vkid: VKID!
    
    lazy var newsCollection: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 450)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CustomNewsCell.self, forCellWithReuseIdentifier: CustomNewsCell.reuseId)
        
        //Добавление Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        $0.refreshControl = refreshControl // Привязываем refreshControl к коллекции
        
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
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    
    lazy var newsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "  Новости"
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 34, weight: .bold)
        $0.numberOfLines = 0
        $0.backgroundColor = .white
        return $0
    }(UILabel())
    
    // кнопочка вверх
    lazy var scrollToTopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("↑", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .newMediumGrey
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .newLightGrey
        NavigationBarManager.configureNavigationBar(for: self, withAction: #selector(actionButtonTapped))
        view.addSubViews(searchBar, newsCollection, newsLabel, scrollToTopButton)
        presenter.loadInitialNews()
        presenter?.loadData()
        setupConstaints()
        //setupScrollToTopButtonConstraints()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let favoriteArray = CoreDataManager.shared.fetchFavorites()
              
              for favoriteNews in favoriteArray {
                  for (index, var news) in presenter.newsList.enumerated() {
                      if news.url == favoriteNews.url {
                          news.isFavorite = favoriteNews.isFavorite  //changeFaroriteState(favoriteNews.isFavorite)
                          presenter.newsList[index] = news
                      } else {
                          news.isFavorite = false
                          presenter.newsList[index] = news
                      }
                  }
              }
        newsCollection.reloadData()
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            //SearchBar
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            //Лейбл "Новости"
            newsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            newsLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            newsLabel.heightAnchor.constraint(equalToConstant: 70),
            
            scrollToTopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.maxX / 2 - 30),
            scrollToTopButton.topAnchor.constraint(equalTo: newsLabel.bottomAnchor, constant: 10),
            scrollToTopButton.widthAnchor.constraint(equalToConstant: 60),
            scrollToTopButton.heightAnchor.constraint(equalToConstant: 20),
            //Коллекция
            newsCollection.topAnchor.constraint(equalTo: newsLabel.bottomAnchor),
            newsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldShowButton = scrollView.contentOffset.y > 460
        scrollToTopButton.isHidden = !shouldShowButton
    }
    func updateNewsList(_ news: [NewsArticle]) {
        presenter?.newsList = news
        newsCollection.reloadData()
    }
    
    func showAlert() {
        AlertManager.showAlert(
            on: self,
            title: "Выйти",
            message: "Вы действительно хотите выйти из аккаунта?",
            confirmHandler: { [weak self] in
                self?.presenter.logOut()
            },
            cancelHandler: {
                print("Отмена нажата")
            }
        )
    }
    
    // MARK: - UISearchBarDelegate
    @objc func actionButtonTapped() {
        print("Кнопка нажата")
        presenter.handleActionButtonTap()
    }
    // Обработчик обновления данных
    @objc private func refreshData() {
        newsCollection.refreshControl?.endRefreshing() // Вызываем метод для получения новых данных
    }
    // кнопочка вверх
    @objc private func scrollToTop() {
        newsCollection.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        
        // Запускаем поиск
        presenter.refreshNews(for: query)
        stopRefreshing()
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        presenter.filterNews("") // Сбрасываем фильтр при отмене поиска
//    }
    
    func reloadData() {
        newsCollection.reloadData()
    }
}
// MARK: - extension для коллекции
extension NewsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("количество новостей из NewsApi: \(presenter.newsList.count)")
        return presenter.newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomNewsCell.reuseId, for: indexPath) as! CustomNewsCell
        let news = presenter.newsList[indexPath.item]
        guard let url = URL(string: news.urlToImage ?? "") else { return cell }
        cell.newsImage.sd_setImage(with: url)
        cell.update(model: news)
//        cell.datePublication.text =  news.publishedAt.toReadableDate() ?? "Неизвестная дата"
//        cell.mainLabel.text = news.title
//        cell.descriptionLabel.text = news.description
//        cell.websiteLabel.text = news.url
//        cell.isFavourite.isSelected = news.isFavorite 
        cell.favoriteButtonAction = { [weak self] in
            self?.presenter.toggleFavorite(for: news)
            print("Saved to favorites: \(news.title)")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = presenter.newsList[indexPath.item]
        let secondView = Builder.createSecondNewsView(newsData: selectedNews)
        
        navigationController?.pushViewController(secondView.self, animated: true)
    }
}
//refresh
extension NewsView {
    func stopRefreshing() {
        self.newsCollection.reloadData()
        newsCollection.refreshControl?.endRefreshing()
    }
}

