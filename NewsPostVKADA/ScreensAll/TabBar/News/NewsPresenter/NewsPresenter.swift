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
   
    func loadData()
    func filterNews(_ keyword: String)
    func numberOfItems() -> Int
//    func fetchNews()
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
    
    var filteredNews: [NewsArticle] = []
    var newsList: [NewsArticle] = []
    var vkid: VKID!
    
    
    var nameUser: String = "пустота"
    
    
    weak var view: NewsViewProtocol?
    private var model: NewsModelProtocol
    
    init(view: NewsViewProtocol, model: NewsModelProtocol) {
        self.view = view
        self.model = model
    }
    
    // MARK: - Func
    
    func configureVKID(vkid: VKID) {
        self.vkid = vkid
        print("VKID передан в презентер: \(String(describing: self.vkid))")
    }
    
    func loadData() {
        //        let news = model.fetchNews()
        view?.updateNewsList(newsList)
    }
    //    func fetchNews() {
    //        let networkManager = NewsAPIManager()
    //        let country = "ru" // Пример страны, которую вы хотите указать
    //
    //        networkManager.fetchNews(for: country) { [weak self] result in
    //            DispatchQueue.main.async {
    //                switch result {
    //                case .success(let articles):
    //                    // Обрабатываем успешно загруженные данные
    //                    self?.newsList = articles
    //                    self?.filteredNews = articles
    //                    self?.view?.reloadData()
    //                case .failure(let error):
    //                    // Обрабатываем ошибку
    //                    print("Error fetching news: \(error.localizedDescription)")
    //                }
    //            }
    //        }
    //    }
    func loadInitialNews() {
        let networkManager = NewsAPIManager()
        let country = "ru" // Пример страны, которую вы хотите указать
        
        networkManager.fetchNews(for: country) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    // Обрабатываем успешно загруженные данные
                    self?.newsList = articles
                    self?.filteredNews = articles
                    self?.view?.reloadData() // Обновляем интерфейс
                case .failure(let error):
                    // Обрабатываем ошибку
                    print("Error fetching news: \(error.localizedDescription)")
                }
            }
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
                    self?.filteredNews = articles
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
    //    func fetchNews() {
    //        let networkManager = NewsAPIManager()
    //        let country = "ru" // Пример страны, которую вы хотите указать
    //
    //        networkManager.fetchNews(for: country) { [weak self] result in
    //            DispatchQueue.main.async {
    //                switch result {
    //                case .success(let articles):
    //                    // Обрабатываем успешно загруженные данные
    //                    self?.newsList = articles
    //                    self?.filteredNews = articles
    //                    self?.view?.reloadData() // Обновляем интерфейс
    //                    self?.view?.stopRefreshing() // Останавливаем анимацию refresh control
    //                case .failure(let error):
    //                    // Обрабатываем ошибку
    //                    print("Error fetching news: \(error.localizedDescription)")
    //                    self?.view?.stopRefreshing() // Останавливаем анимацию в случае ошибки
    //                }
    //            }
    //        }
    //    }
    //    func fetchNews() {
    //        // Загружаем новости (например, из CoreData или API)
    //        let networkManager = NewsAPIManager.fetchNews(<#NewsAPIManager#>)
    //       // let coreDataManager = CoreDataManager.shared
    //          newsList = networkManager.fetchNews()
    //       // newsList = coreDataManager.fetchNews()
    //        filteredNews = newsList
    //        view?.reloadData()
    //    }
    
    func filterNews(_ keyword: String) {
        if keyword.isEmpty {
            filteredNews = newsList
        } else {
            filteredNews = newsList.filter { news in
                news.title.localizedCaseInsensitiveContains(keyword) == true ||
                news.description.localizedCaseInsensitiveContains(keyword) == true
            }
        }
        view?.reloadData()
    }
    
    func numberOfItems() -> Int {
        return filteredNews.count
    }
    
    func news(at indexPath: IndexPath) -> NewsArticle {
        return filteredNews[indexPath.item]
    }
    
    func handleActionButtonTap() {
        print("алерт")
        view?.showAlert()  //даем команду view показать алерт
    }
    func logOut() {
        LogoutService.shared.logOut(vkid: vkid) { result in
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

