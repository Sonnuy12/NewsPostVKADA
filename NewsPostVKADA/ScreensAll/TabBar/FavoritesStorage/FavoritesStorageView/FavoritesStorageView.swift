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
    //нужно для поиска, пока не понимаю как работает
    private var isSearchActive: Bool = false
    private var filteredFavorites: [NewsEntity] = []
    
    lazy var favouriteCollection: UICollectionView = {
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
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .newLightGrey
        NavigationBarManager.configureNavigationBar(for: self, withAction: #selector(actionButtonTapped))
        view.addSubViews(favouriteCollection, favouriteLabel, searchBar)
        setupConstaints()
        presenter.loadFavorites()
    }
    
    func displaySavedNews(_ news: [NewsEntity]) {
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
    
    // MARK: - @objc Func
    
    //функция для рефрешера
    @objc private func refreshData() {
        presenter.loadFavorites()
        // останавливаю анимацию прямо во view
        favouriteCollection.refreshControl?.endRefreshing()
    }
    //для кнопочки выхода
    @objc func actionButtonTapped() {
        print("Кнопка нажата")
        presenter.handleActionButtonTap()
    }
}

// MARK: - extension для коллекции
extension FavoritesStorageView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // MARK: - выбор элемента в коллекции, здесь может быть добавлен переход к выбранной новости или ее удаление
        //Добавил метод для удаления
        let selectedNews = presenter.favorites[indexPath.item]
        presenter.deleteFavoriteNews(selectedNews)
        //
        favouriteCollection.reloadData()
        print("Новость удалена: \(selectedNews.title ?? "Без заголовка")")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchActive ? filteredFavorites.count : presenter.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteCustomCell.reuseId, for: indexPath) as! FavouriteCustomCell
        let savedNews = isSearchActive ? filteredFavorites[indexPath.item] : presenter.favorites[indexPath.item]
        cell.configureElements(items: savedNews)
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
        presenter.loadFavorites()
        favouriteCollection.reloadData()
    }
}
