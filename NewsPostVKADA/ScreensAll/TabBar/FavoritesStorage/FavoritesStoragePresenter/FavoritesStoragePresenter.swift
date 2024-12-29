//
//  FavoritesStoragePresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import CoreData
import VKID

protocol FavoritesStoragePresenterProtocol: AnyObject {
    var favorites: [NewsArticle] {get set}
    func loadFavorites() // Загрузить список избранных новостей
    func deleteFavoriteNews(_ news: NewsArticle) // Удалить новость из избранного
    func configureVKID(vkid: VKID)
    func logOut()
    func handleActionButtonTap()
    
    func searchFavorites(by keyword: String)
}

class FavoritesStoragePresenter: NSObject, FavoritesStoragePresenterProtocol, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    private weak var view: FavoritesStorageViewProtocol?
    private let coreDataManager: CoreDataManager
    internal var favorites: [NewsArticle] = CoreDataManager.shared.fetchFavorites()
    
    var vkid: VKID!
    
    init(view: FavoritesStorageViewProtocol, coreDataManager: CoreDataManager = .shared) {
        self.view = view
        self.coreDataManager = coreDataManager
    }
    // MARK: - Methods
    func configureVKID(vkid: VKID) {
        self.vkid = vkid
        print("VKID передан в презентер: \(String(describing: self.vkid))")
    }
    
    func loadFavorites() { // загрузка избранных новостей
       let newsFavorites = coreDataManager.fetchFavorites()
        view?.filteredFavorites = newsFavorites
    }
    
    func deleteFavoriteNews(_ news: NewsArticle) {
        coreDataManager.deleteNews(news)
       
        // Обновляем данные после удаления
    }
    //функции для кнопочки выхода
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
    
    func searchFavorites(by keyword: String) {
        let lowercasedKeyword = keyword.lowercased()
        let filteredNews = favorites.filter { news in
            news.title.lowercased().contains(lowercasedKeyword)
        }
        view?.displaySavedNews(filteredNews)
    }
//    // MARK: - NSFetchedResultsControllerDelegate
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        if let updatedFavorites = coreDataManager.getAllNews() {
//            self.favorites = updatedFavorites
//            view?.displaySavedNews(updatedFavorites)  // Обновляем UI с новыми данными
//        }
//    }
}

