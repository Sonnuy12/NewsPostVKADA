//
//  NewsPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import VKID

protocol NewsPresenterProtocol: AnyObject {
    func loadData()
    var newsList: [NewsEntity] {get set}
    func filterNews(_ keyword: String)
    func numberOfItems() -> Int
    
    var nameUser: String {get set}
    
    func handleActionButtonTap()
    func logOut()
    func configureVKID(vkid: VKID)
    
    
}
class NewsPresenter: NewsPresenterProtocol {
    
    
    // MARK: - Properties
    var scene: SceneDelegate?
    
    
    var filteredNews: [NewsEntity] = []
    var newsList: [NewsEntity] = []
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
}

