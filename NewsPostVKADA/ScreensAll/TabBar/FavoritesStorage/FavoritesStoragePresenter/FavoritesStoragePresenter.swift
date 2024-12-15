//
//  FavoritesStoragePresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

//import Foundation
//
//protocol FavoritesStoragePresenterProtocol: AnyObject {
////    var savedNews: [NewsEntity] {get set}
//    func removeNews(_ news: NewsEntity)
//    func fetchSavedNews()
//}
//
//class FavoritesStoragePresenter: FavoritesStoragePresenterProtocol {
//
//// MARK: - Properties
////    var savedNews: [NewsEntity] = []
//    private var favorites: [NewsEntity] = []
//    private let coreDataManager = CoreDataManager.shared
//    weak var view: FavoritesStorageViewProtocol?
//    
//    init(view: FavoritesStorageViewProtocol) {
//        self.view = view
//
//    }
//// MARK: - Func
//    func fetchSavedNews() {
//        favorites = coreDataManager.fetchNews()
//        view?.displaySavedNews(favorites)
//        }
//        
//// MARK: - Add News
//    func addNews(_ news: NewsEntity) {
//            coreDataManager.addNews(news)
//            fetchSavedNews()
//        }
//        
//// MARK: - Remove News (необходимо подумать над этой функцией, чтобы она удаляла по int)
//    func removeNews(_ news: NewsEntity) {
//        coreDataManager.deleteNews(news)
//            fetchSavedNews()
//        }
//}

import Foundation
import CoreData

protocol FavoritesStoragePresenterProtocol: AnyObject {
    var favorites: [NewsEntity] {get set}
    func loadFavorites() // Загрузить список избранных новостей
    func deleteFavoriteNews(_ news: NewsEntity) // Удалить новость из избранного
}

//class FavoritesStoragePresenter: NSObject, FavoritesStoragePresenterProtocol {
//    // MARK: - Properties
//    private weak var view: FavoritesStorageViewProtocol?
//    private let coreDataManager: CoreDataManager
//    internal var favorites: [NewsEntity] = []
//
//    // MARK: - Init
//    init(view: FavoritesStorageViewProtocol, coreDataManager: CoreDataManager = .shared) {
//        self.view = view
//        self.coreDataManager = coreDataManager
//    }
//
//    // MARK: - Methods
////    func loadFavorites() {
////        // Фильтруем избранные новости (если есть поле isFavourite)
////        favorites = coreDataManager.fetchNews().filter { $0.isFavourite }
////        view?.displaySavedNews(favorites) // Отображаем обновленный список
////    }
//    func loadFavorites() {
//           coreDataManager.setupNewsFetchedResultsController(delegate: self)  // Устанавливаем делегат
//       }
//
//    func deleteFavoriteNews(_ news: NewsEntity) {
//        coreDataManager.deleteNews(news) // Удаляем новость из CoreData
//        loadFavorites() // Обновляем данные после удаления
//    }
//}
//
//extension FavoritesStoragePresenter: NSFetchedResultsControllerDelegate {
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        if let updatedFavorites = coreDataManager.getAllNews() {
//            self.favorites = updatedFavorites
//            view?.displaySavedNews(updatedFavorites)  // Обновляем UI с новыми данными
//        }
//    }
//}


class FavoritesStoragePresenter: NSObject, FavoritesStoragePresenterProtocol, NSFetchedResultsControllerDelegate {
    private weak var view: FavoritesStorageViewProtocol?
    private let coreDataManager: CoreDataManager
    internal var favorites: [NewsEntity] = []

    init(view: FavoritesStorageViewProtocol, coreDataManager: CoreDataManager = .shared) {
        self.view = view
        self.coreDataManager = coreDataManager
    }

    func loadFavorites() {
        coreDataManager.setupNewsFetchedResultsController(delegate: self)  // Устанавливаем делегат
    }

    func deleteFavoriteNews(_ news: NewsEntity) {
        coreDataManager.deleteNews(news)
        loadFavorites()
       // Обновляем данные после удаления
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updatedFavorites = coreDataManager.getAllNews() {
            self.favorites = updatedFavorites
            view?.displaySavedNews(updatedFavorites)  // Обновляем UI с новыми данными
        }
    }
}

