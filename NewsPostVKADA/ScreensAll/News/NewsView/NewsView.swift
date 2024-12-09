//
//  NewsView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit

protocol NewsViewProtocol: AnyObject {
    func updateUI()
}

class NewsView: UIViewController, NewsViewProtocol {
   
    lazy var newsCollection: UICollectionView = {
        
        $0.delegate = self
        $0.dataSource = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CustomNewsCell.self, forCellWithReuseIdentifier: CustomNewsCell.reuseId)
        
        return $0
    }(UICollectionView())
    
    
    // MARK: - Properties
    var presenter: NewsPresenterProtocol?
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новости"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(newsCollection)
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
    
    func updateUI() {
        //тут будет код для обновления UI:)
    }
}
// MARK: - extension для коллекции
extension NewsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomNewsCell.reuseId, for: indexPath) as! CustomNewsCell
        return cell
    }
    
    
}
