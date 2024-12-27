//
//  FavoritesStorageView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit
import VKID

protocol FavoritesStorageViewProtocol: AnyObject {
    func displaySavedNews(_ news: [NewsArticle])
    func showAlert()
    var filteredFavorites: [NewsArticle] {get set}
    func reloadCollection()
}

class FavoritesStorageView: UIViewController, FavoritesStorageViewProtocol, UISearchBarDelegate, UIScrollViewDelegate {
    // MARK: - Properties
    var presenter:  FavoritesStoragePresenterProtocol!
    var vkid: VKID!
    //нужно для поиска, пока не понимаю как работает
    private var isSearchActive: Bool = false
     var filteredFavorites: [NewsArticle] = []
    
    lazy var favouriteCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 450)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FavouriteCustomCell.self, forCellWithReuseIdentifier: FavouriteCustomCell.reuseId)
        
        // Настройка UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        return collectionView
    }()
    
    lazy var favouriteLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "  Избранное"
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 34, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
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
        view.addSubViews(favouriteCollection, favouriteLabel, searchBar, scrollToTopButton)
        setupConstaints()
       
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        presenter.loadFavorites()
        favouriteCollection.reloadData()
       }
    
    func reloadCollection() {
        favouriteCollection.reloadData()
    }
       
    
    func displaySavedNews(_ news: [NewsArticle]) {
        presenter.favorites = news
        favouriteCollection.reloadData()
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            //SearchBar
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            //Лейбл "Изб"
            favouriteLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            favouriteLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            favouriteLabel.heightAnchor.constraint(equalToConstant: 70),
            
            scrollToTopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.maxX / 2 - 30),
            scrollToTopButton.topAnchor.constraint(equalTo: favouriteLabel.bottomAnchor, constant: 10),
            scrollToTopButton.widthAnchor.constraint(equalToConstant: 60),
            scrollToTopButton.heightAnchor.constraint(equalToConstant: 20),
            
            //Коллекция
            favouriteCollection.topAnchor.constraint(equalTo: favouriteLabel.bottomAnchor),
            favouriteCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favouriteCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favouriteCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldShowButton = scrollView.contentOffset.y > 460
        scrollToTopButton.isHidden = !shouldShowButton
    }
    
    // MARK: - @objc Func
    
    //функция для рефрешера
    @objc private func refreshData() {
       // presenter.loadFavorites()
        // останавливаю анимацию прямо во view
        reloadCollection()
        favouriteCollection.refreshControl?.endRefreshing()
    }
    //для кнопочки выхода
    @objc func actionButtonTapped() {
        print("Кнопка нажата")
        presenter.handleActionButtonTap()
    }
    
    // кнопочка вверх
    @objc private func scrollToTop() {
        favouriteCollection.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

// MARK: - extension для коллекции
extension FavoritesStorageView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(filteredFavorites.count)
        return filteredFavorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteCustomCell.reuseId, for: indexPath) as! FavouriteCustomCell
        let savedNews = filteredFavorites[indexPath.item]
        cell.configureElements(items: savedNews)
        cell.isFavourite.isSelected = savedNews.isFavorite
        cell.favoriteButtonAction = { [weak self] in
            self?.presenter.deleteFavoriteNews(savedNews)
            self?.filteredFavorites.remove(at: indexPath.item)
            print("новость удалена \(savedNews.title)")
            self?.favouriteCollection.reloadData()
            print("Обновил таблицу ")
        }
        return cell
    }
}

extension FavoritesStorageView {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = !searchText.isEmpty
        if isSearchActive {
            presenter.searchFavorites(by: searchText)
        } else {
            filteredFavorites = []
            favouriteCollection.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        searchBar.text = ""
        //presenter.loadFavorites()
        favouriteCollection.reloadData()
    }
}
