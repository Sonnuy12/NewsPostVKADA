//
//  NewsPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import VKID

protocol NewsPresenterProtocol: AnyObject {
    var newsList: [NewsArticle] {get set}
    func toggleFavorite(for news: NewsArticle)
    func loadData()
//    func filterNews(_ keyword: String)
//    func numberOfItems() -> Int
    
    func refreshNews(for query: String)
    func loadInitialNews()
    var nameUser: String {get set}
    
    func handleActionButtonTap()
    func logOut()
    func configureVKID(vkid: VKID)
}
class NewsPresenter: NewsPresenterProtocol {
    
    // MARK: - Properties
    var scene: SceneDelegate?
    
    var favouriteNews: [NewsArticle] = CoreDataManager.shared.fetchFavorites()
    var newsList: [NewsArticle] = []
    var vkid: VKID!
    
    var nameUser: String = "пустота"
    
    weak var view: NewsViewProtocol?
 
    
    init(view: NewsViewProtocol) {
        self.view = view
    }
    // MARK: - Func
    
    func configureVKID(vkid: VKID) {
        self.vkid = vkid
        print("VKID передан в презентер: \(String(describing: self.vkid))")
    }
    
    func loadData() {
        view?.updateNewsList(newsList)
    }
    
    func loadInitialNews() {
        let networkManager = NewsAPIManager()
        let country = "ru" // Пример страны, которую вы хотите указать
        
        networkManager.fetchNews(for: country) { [weak self] result in
            switch result {
            case .success(let articles):
                // Обрабатываем успешно загруженные данные
                self?.newsList = articles.map { article in
                    var modifiedArticle = article
                    modifiedArticle.isFavorite = self?.favouriteNews.contains {
                        $0.title == article.title } ?? false
                    return modifiedArticle
                }
                DispatchQueue.main.async {
                    // self?.filteredNews = articles
                    self?.view?.updateNewsList(self?.newsList ?? [])  // Обновляем интерфейс
                }
            case .failure(let error):
                // Обрабатываем ошибку
                print("Error fetching news: \(error.localizedDescription)")
            }
        }
    }
    
    //????? - нужно ли?
//    func saveToFavorites(article: NewsArticle) {
//            CoreDataManager.shared.saveToFavorites(news: article)
//        }
//
//    func fetchFavorites() -> [NewsArticle] {
//            return CoreDataManager.shared.fetchFavorites()
//        }
   
    
    func toggleFavorite(for news: NewsArticle) {
        if let index = favouriteNews.firstIndex(where: { $0.url == news.url }) {
            favouriteNews.remove(at: index)
            CoreDataManager.shared.deleteNews(news)
        } else {
            favouriteNews.append(news)
            CoreDataManager.shared.addNews(news)
        }
    }
    
    func refreshNews(for query: String) {
        let networkManager = NewsAPIManager()
        // let country = "ru" // Пример страны, которую вы хотите указать
        
        networkManager.fetchNews(for: query ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    // Обрабатываем успешно загруженные данные
                    self?.newsList = articles
                    //self?.favouriteNews = articles
                    self?.view?.reloadData() // Обновляем интерфейс
                    self?.view?.stopRefreshing() // Останавливаем анимацию refresh control
                case .failure(let error):
                    // Обрабатываем ошибку
                    print("Error fetching news: \(error.localizedDescription)")
                    self?.view?.stopRefreshing() // Останавливаем анимацию в случае ошибки
                }
            }
        }
    }
    
//    func filterNews(_ keyword: String) {
//        if keyword.isEmpty {
//            filteredNews = newsList
//        } else {
//            filteredNews = newsList.filter { news in
//                news.title.localizedCaseInsensitiveContains(keyword) == true ||
//                news.description.localizedCaseInsensitiveContains(keyword) == true
//            }
//        }
//        view?.reloadData()
   // }
    
//    func numberOfItems() -> Int {
//        return filteredNews.count
//    }
    
//    func news(at indexPath: IndexPath) -> NewsArticle {
//        return filteredNews[indexPath.item]
//    }
    
    func handleActionButtonTap() {
        print("алерт")
        view?.showAlert()  //даем команду view показать алерт
    }
    func logOut() {
        LogoutManager.shared.logOut(vkid: vkid) { result in
            switch result {
            case .success:
                print("Выход успешно выполнен через презентер")
                // Дополнительная логика для конкретного презентера (если нужно)
            case .failure(let error):
                print("Ошибка при выходе через презентер: \(error.localizedDescription)")
            }
        }
    }
}

