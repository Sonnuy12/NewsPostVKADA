//
//  NewsView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit

protocol NewsViewProtocol: AnyObject {
    func updateNewsList(_ news: [NewsEntity])
}

class NewsView: UIViewController, NewsViewProtocol {
    
    lazy var newsCollection: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 20, height: view.frame.height - 180)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        $0.delegate = self
        $0.dataSource = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CustomNewsCell.self, forCellWithReuseIdentifier: CustomNewsCell.reuseId)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    
    // MARK: - Properties
    var presenter: NewsPresenterProtocol!
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новости"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(newsCollection)
        view.backgroundColor = .newMediumGrey
        presenter?.loadData()
        setupConstaints()
    }
    
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            newsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func updateNewsList(_ news: [NewsEntity]) {
        presenter?.newsList = news
        newsCollection.reloadData()
    }
}
// MARK: - extension для коллекции
extension NewsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.newsList.count
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
