//
//  ErrorNilVkView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit
import VKID

protocol ErrorNilVkViewProtocol: AnyObject {
    func updateVKNews(_ news: [VKResponseItem])
    func updateUI(with news: [VKResponseItem])
    func showError(_ message: String)
    func showAlert()
    func myUpdate()
}

class ErrorNilVkView: UIViewController, ErrorNilVkViewProtocol {
    // MARK: - Properties
    var presenter:  ErrorNilVkPresenterProtocol!
    var vkid: VKID!
    var newsItems: [VKResponseItem] = []
    
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
        view.addSubViews(newsLabel, VkNewsCollection, scrollToTopButton)
        //presenter.
        presenter?.fetchVKWallPublic()
        setupConstaints()
        myUpdate()
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            // Лейбл "Новости"
            newsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            newsLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            newsLabel.heightAnchor.constraint(equalToConstant: 70),
            
            scrollToTopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.maxX / 2 - 30),
            scrollToTopButton.topAnchor.constraint(equalTo: newsLabel.bottomAnchor, constant: 10),
            scrollToTopButton.widthAnchor.constraint(equalToConstant: 60),
            scrollToTopButton.heightAnchor.constraint(equalToConstant: 20),
            
            // Коллекция под лейблом
            VkNewsCollection.topAnchor.constraint(equalTo: newsLabel.bottomAnchor),
            VkNewsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            VkNewsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            VkNewsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func updateVKNews(_ news: [VKResponseItem]) {
        presenter.VKNewsList = news
        VkNewsCollection.reloadData()
    }

    func updateUI(with news: [VKResponseItem]) {
        if news.isEmpty {
            print("Нет новостей для отображения")
        } else {
            updateVKNews(news)
            print("Новости для отображения: \(news)")
            VkNewsCollection.reloadData()
        }
    }
    func myUpdate() {
        VkNewsCollection.reloadData()
        print("выполнил myUpdate myUpdate myUpdate")
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldShowButton = scrollView.contentOffset.y > 470
        scrollToTopButton.isHidden = !shouldShowButton
    }
    
    @objc func actionButtonTapped() {
        print("Кнопка нажата")
        presenter.handleActionButtonTap()
    }
    
    // кнопочка вверх
    @objc private func scrollToTop() {
        VkNewsCollection.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
// MARK: - extension для коллекции
extension ErrorNilVkView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.VKNewsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomVKNewsCell.reuseId, for: indexPath) as! CustomVKNewsCell
            let newsItem = presenter.VKNewsList[indexPath.item]
            cell.configure(with: newsItem)
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = presenter.VKNewsList[indexPath.item]
        print("Выбранная новость: \(selectedNews)")
    }
}
extension ErrorNilVkView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 400) // Пример
    }
}



