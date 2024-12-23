//
//  ErrorNilVkView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit
import VKID

protocol ErrorNilVkViewProtocol: AnyObject {
    func updateVKNews(_ news: [ModelVKNews])
    func showError(_ message: String)
    func showAlert()
}

class ErrorNilVkView: UIViewController, ErrorNilVkViewProtocol {
    // MARK: - Properties
    var presenter:  ErrorNilVkPresenterProtocol!
    var vkid: VKID!
    
    //MARK: - Создание кастомной коллекции и лейбла
    lazy var VkNewsCollection: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 20, height: view.frame.height - 180)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        $0.delegate = self
        $0.dataSource = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CustomVKNewsCell.self, forCellWithReuseIdentifier: CustomVKNewsCell.reuseId)
        $0.backgroundColor = .white
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
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
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .newLightGrey
        NavigationBarManager.configureNavigationBar(for: self, withAction: #selector(actionButtonTapped))
        view.addSubview(newsLabel)
        view.addSubview(VkNewsCollection)
        presenter?.fetchVKNews()
        setupConstaints()
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            // Лейбл "Новости"
            newsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            newsLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            newsLabel.heightAnchor.constraint(equalToConstant: 70),
            
            // Коллекция под лейблом
            VkNewsCollection.topAnchor.constraint(equalTo: newsLabel.bottomAnchor),
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
    
    @objc func actionButtonTapped() {
        print("Кнопка нажата")
        presenter.handleActionButtonTap()
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


