//
//  FavoritesStoragePresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation

protocol FavoritesStoragePresenterProtocol: AnyObject {
    var savedNews: [NewsEntity] {get set}
    //func removeNews(_ news: NewsEntity)
    func fetchSavedNews()
}

class FavoritesStoragePresenter: FavoritesStoragePresenterProtocol {

// MARK: - Properties
     var savedNews: [NewsEntity] = []
    private let coreDataManager = CoreDataManager.shared
    weak var view: FavoritesStorageViewProtocol?
    
    init(view: FavoritesStorageViewProtocol) {
        self.view = view
    }
// MARK: - Func
    func fetchSavedNews() {
            savedNews = coreDataManager.fetchNews()
            view?.displaySavedNews(savedNews)
        }
        
        // MARK: - Add News
    func addNews(_ news: NewsEntity) {
            coreDataManager.addNews(news)
            fetchSavedNews()
        }
        
        // MARK: - Remove News (необходимо подумать над этой функцией, чтобы она удаляла по int)
    func removeNews(_ news: NewsEntity) {
        coreDataManager.deleteNews(news)
            fetchSavedNews()
        }
}
