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
import VKID

protocol FavoritesStoragePresenterProtocol: AnyObject {
    var favorites: [NewsEntity] {get set}
    func loadFavorites() // Загрузить список избранных новостей
    func deleteFavoriteNews(_ news: NewsEntity) // Удалить новость из избранного
    
    func configureVKID(vkid: VKID)
    func logOut()
    func handleActionButtonTap()
}

class FavoritesStoragePresenter: NSObject, FavoritesStoragePresenterProtocol, NSFetchedResultsControllerDelegate {
    
// MARK: - Properties
    private weak var view: FavoritesStorageViewProtocol?
    private let coreDataManager: CoreDataManager
    internal var favorites: [NewsEntity] = []
    
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

    func loadFavorites() {
        coreDataManager.setupNewsFetchedResultsController(delegate: self)  // Устанавливаем делегат
    }

    func deleteFavoriteNews(_ news: NewsEntity) {
        coreDataManager.deleteNews(news)
        loadFavorites()
       // Обновляем данные после удаления
    }
    //функции для кнопочки выхода
    func handleActionButtonTap() {
        print("алерт")
        view?.showAlert()  //даем команду view показать алерт
    }
    
    func logOut() {
        guard let vkid = vkid else {
            print("VKID не инициализирован")
            return
        }

        // Используем вашу функцию logout
        logout(vkid: vkid) { result in
            switch result {
            case .success:
                print("Выход успешно выполнен через презентер")
                CoreDataManager.shared.deleteUserDetails()
                // Отправляем уведомление об успешном выходе
                NotificationCenter.default.post(name: Notification.Name("setVC"), object: nil, userInfo: ["vc": NotificationEnum.authorization])
            case .failure(let error):
                print("Ошибка при выходе через презентер: \(error.localizedDescription)")
            }
        }
    }
    // Ваша функция logout остается без изменений
    private func logout(vkid: VKID, completion: @escaping (Result<Void, Error>) -> Void) {
        let session: UserSession? = vkid.currentAuthorizedSession
        session?.logout { result in
            switch result {
            case .success:
                print("Выход выполнен успешно")
                // Очистка данных из UserDefaults
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "UserFirstName")
                userDefaults.removeObject(forKey: "UserLastName")
                userDefaults.removeObject(forKey: "UserAvatarURL")
                
                // Синхронизируем изменения
                userDefaults.synchronize()
                print("Данные пользователя удалены из UserDefaults")
                completion(.success(()))
            case .failure(let error):
                print("Ошибка при выходе: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updatedFavorites = coreDataManager.getAllNews() {
            self.favorites = updatedFavorites
            view?.displaySavedNews(updatedFavorites)  // Обновляем UI с новыми данными
        }
    }
}

