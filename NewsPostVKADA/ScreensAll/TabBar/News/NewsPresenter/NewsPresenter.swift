//
//  NewsPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation


protocol NewsPresenterProtocol: AnyObject {
    func loadData()
    var newsList: [NewsEntity] {get set}
    func filterNews(_ keyword: String)
    func numberOfItems() -> Int
    
    var nameUser: String {get set}
    var imageUser: String {get set}
    func handleActionButtonTap()
}

class NewsPresenter: NewsPresenterProtocol {
    
    var filteredNews: [NewsEntity] = []
    var newsList: [NewsEntity] = []
    
    var nameUser = "Загруз Ожиданов"
    var imageUser: String = "BackroundAuthorization"
    
    // MARK: - Properties
    weak var view: NewsViewProtocol?
    private var model: NewsModelProtocol
    
    init(view: NewsViewProtocol, model: NewsModelProtocol) {
        self.view = view
        self.model = model
    }
    
    // MARK: - Func
    func loadData() {
        let news = model.fetchNews()
        view?.updateNewsList(news)
    }
    
    func fetchNews() {
        // Загружаем новости (например, из CoreData или API)
        let coreDataManager = CoreDataManager.shared
        newsList = coreDataManager.fetchNews()
        filteredNews = newsList
        view?.reloadData()
    }
    
    func filterNews(_ keyword: String) {
        if keyword.isEmpty {
            filteredNews = newsList
        } else {
            filteredNews = newsList.filter { news in
                news.title?.localizedCaseInsensitiveContains(keyword) == true ||
                news.descriptionText?.localizedCaseInsensitiveContains(keyword) == true
            }
        }
        view?.reloadData()
    }
    
    func numberOfItems() -> Int {
        return filteredNews.count
    }
    
    func news(at indexPath: IndexPath) -> NewsEntity {
        return filteredNews[indexPath.item]
    }
    
    func handleActionButtonTap() {
        print("алерт  але алерталерталерталерталерталерталерталертрт")
           view?.showAlert()  // Даем команду представлению показать алерт
       }
}
