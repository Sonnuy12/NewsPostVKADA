//
//  ErrorNilVkPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import VKID

protocol ErrorNilVkPresenterProtocol: AnyObject {
    var VKNewsList: [ModelVKNewsErrorNil] { get set }
    //func fetchVKNews()
    
    func configureVKID(vkid: VKID)
    func handleActionButtonTap()
    func logOut()
    
    func GettingWallLink()
    
    func fetchVKWallPublic()
}

class ErrorNilVkPresenter: ErrorNilVkPresenterProtocol {
   
      
      
    // MARK: - Properties
    weak var view: ErrorNilVkViewProtocol?
    var VKNewsList: [ModelVKNewsErrorNil] = []
    var apiService: VKApiServiceProtocol
    var vkid: VKID?
    private let vkWallServicePublic: VKWallServicePublic
    
    
    init(view: ErrorNilVkViewProtocol, apiService: VKApiServiceProtocol, vkWallServicePublic: VKWallServicePublic) {
        self.view = view
        self.apiService = apiService
        self.vkWallServicePublic = vkWallServicePublic
    }
    // MARK: - Func
    
    // Структуры для парсинга ответа
    struct NewsFeedResponse: Codable {
        let response: NewsFeedData
    }
    
    struct NewsFeedData: Codable {
        let items: [NewsFeedItem]
    }
    
    
    struct NewsFeedItem: Codable {
        let id: Int
        let text: String
        // Добавьте другие поля в зависимости от нужных данных
    }
    
    func fetchVKWallPublic() {
            // Получаем URL из UserDefaults
            if let requestURLString = UserDefaults.standard.string(forKey: "VKWallRequestURLPublic"),
               let requestURL = URL(string: requestURLString) {
                
                // Выполняем запрос с использованием полученного URL
                vkWallServicePublic.performWallRequest(with: requestURL) { result in
                    switch result {
                    case .success(let news):
                        print("Полученные записи: \(news)")
                    case .failure(let error):
                        print("Ошибка запроса стены: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Не удалось получить ссылку для запроса стены.")
            }
        }
//    func fetchVKNews() {
//        apiService.fetchNews { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let news):
//                self.VKNewsList = news
//                self.view?.updateVKNews(news)
//            case .failure(let error):
//                self.view?.showError("Failed to load news: \(error.localizedDescription)")
//            }
//        }
//    }
    //
    func configureVKID(vkid: VKID) {
        self.vkid = vkid
        print("VKID передан в презентер: \(String(describing: self.vkid))")
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
    //получение ссылки на стену
    func GettingWallLink() {
        let userDefaults = UserDefaults.standard
        if let requestURLString = userDefaults.string(forKey: "VKWallRequestURL") {
            print("Полученная ссылка: \(requestURLString)")
        } else {
            print("Ссылка не найдена в UserDefaults.")
        }
    }
}
