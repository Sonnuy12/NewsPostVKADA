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
}

class NewsView: UIViewController, NewsViewProtocol, UISearchBarDelegate {
   
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
    
    lazy var searchControll: UISearchController = {
        $0.searchBar.delegate = self
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.placeholder = "Search"
        $0.searchBar.searchTextField.backgroundColor = .systemGray6
        $0.searchBar.searchTextField.leftView?.tintColor = .gray
        $0.searchBar.searchTextField.rightView?.tintColor = .gray
        navigationItem.searchController = $0
        definesPresentationContext = true
        return $0
    }(UISearchController(searchResultsController: nil))
    
    lazy var NewsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Новости"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 34, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    // MARK: - Properties
    //желательно использовать опционал и потом все адаптировать под его исп(добавить "?" и "??")
    var presenter: NewsPresenterProtocol!
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchControll
        view.addSubViews(newsCollection,NewsLabel)
        view.backgroundColor = .white
        presenter?.loadData()
        setupConstaints()
    }
        private func setupConstaints() {
        NSLayoutConstraint.activate([
            newsCollection.topAnchor.constraint(equalTo: NewsLabel.bottomAnchor, constant: 15),
            newsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            NewsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            NewsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            NewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            NewsLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func updateNewsList(_ news: [NewsEntity]) {
        presenter?.newsList = news
        newsCollection.reloadData()
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
