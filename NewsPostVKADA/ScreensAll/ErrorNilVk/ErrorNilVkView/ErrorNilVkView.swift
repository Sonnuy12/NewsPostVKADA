//
//  ErrorNilVkView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit

protocol ErrorNilVkViewProtocol: AnyObject {
    func updateVKNews(_ news: [ModelVKNews])
    func showError(_ message: String)
}

class ErrorNilVkView: UIViewController, ErrorNilVkViewProtocol {
    
    // MARK: - Properties
    var presenter:  ErrorNilVkPresenterProtocol!
    //MARK: - Создание кастомной коллекции 
    lazy var VkNewsCollection: UICollectionView = {
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
    
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новости"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(VkNewsCollection)
        view.backgroundColor = .newMediumGrey
        presenter?.fetchVKNews()
        setupConstaints()
    }
    
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            VkNewsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            VkNewsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            VkNewsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            VkNewsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func updateVKNews(_ news: [ModelVKNews]) {
        presenter?.VKNewsList = news
        VkNewsCollection.reloadData()
    }
    
    func showError(_ message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
}
// MARK: - extension для коллекции
extension ErrorNilVkView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.VKNewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomNewsCell.reuseId, for: indexPath) as! CustomVKNewsCell
        let news = presenter.VKNewsList[indexPath.item]
        cell.configure(with: news)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = presenter.VKNewsList[indexPath.item]
        print(selectedNews)
    }
   
}
