//
//  ErrorNilVkPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import VKID

protocol ErrorNilVkPresenterProtocol: AnyObject {
    var VKNewsList: [VKResponseItem] { get set }
    
    func configureVKID(vkid: VKID)
    func handleActionButtonTap()
    func logOut()
    
    func gettingWallLink()
    
    func fetchVKWallPublic()
}

class ErrorNilVkPresenter: ErrorNilVkPresenterProtocol {
    
    // MARK: - Properties
    weak var view: ErrorNilVkViewProtocol?
    var VKNewsList: [VKResponseItem] = []
    
    var vkid: VKID?
    private let vkWallServicePublic: VKWallServicePublic
    
    
    init(view: ErrorNilVkViewProtocol, vkWallServicePublic: VKWallServicePublic) {
        self.view = view
        
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
        guard let requestURLString = UserDefaults.standard.string(forKey: "VKWallRequestURLPublic"),
              let url = URL(string: requestURLString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                print("Ошибка при получении данных: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                return
            }

            do {
                let decoder = JSONDecoder()
                let vkNewsResponse = try decoder.decode(VKObject.self, from: data)

                let newsItems = vkNewsResponse.response.items

                DispatchQueue.main.async {
                    self?.view?.updateUI(with: newsItems)
                    self?.view?.myUpdate()
                }
            } catch {
                print("Ошибка при парсинге данных: \(error.localizedDescription)")
            }
        }
        task.resume()
       
    }
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
    func gettingWallLink() {
        let userDefaults = UserDefaults.standard
        if let requestURLString = userDefaults.string(forKey: "VKWallRequestURL") {
            print("Полученная ссылка: \(requestURLString)")
        } else {
            print("Ссылка не найдена в UserDefaults.")
        }
    }
}
