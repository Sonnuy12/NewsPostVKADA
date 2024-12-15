//
//  FavoritesStorageView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit

protocol FavoritesStorageViewProtocol: AnyObject {
    func displaySavedNews(_ news: [NewsEntity])
}

class FavoritesStorageView: UIViewController, FavoritesStorageViewProtocol {
    // MARK: - Properties
    var presenter:  FavoritesStoragePresenterProtocol!
    
    lazy var FavouriteCollection: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 20, height: view.frame.height - 180)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .darkGray // в процессе появления коллекций с данными, изменить цвет на белый
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(FavouriteCustomCell.self, forCellWithReuseIdentifier: FavouriteCustomCell.reuseId)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
        
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
            setupConstaints()
            presenter.loadFavorites()
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
        print("Новость удалена: \(selectedNews.title ?? "Без заголовка")")
    }
}
