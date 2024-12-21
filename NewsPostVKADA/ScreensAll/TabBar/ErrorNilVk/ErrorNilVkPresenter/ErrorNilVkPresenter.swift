//
//  ErrorNilVkPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import VKID

protocol ErrorNilVkPresenterProtocol: AnyObject {
    var VKNewsList: [ModelVKNews] { get set }
    func fetchVKNews()
    
    func configureVKID(vkid: VKID)
    func handleActionButtonTap()
    func logOut()
}

class ErrorNilVkPresenter: ErrorNilVkPresenterProtocol {
    
    // MARK: - Properties
    weak var view: ErrorNilVkViewProtocol?
    var VKNewsList: [ModelVKNews] = []
    var apiService: VKApiServiceProtocol
    var vkid: VKID?
    
    init(view: ErrorNilVkViewProtocol, apiService: VKApiServiceProtocol) {
        self.view = view
        self.apiService = apiService
    }
    // MARK: - Func
    func fetchVKNews() {
        apiService.fetchNews { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                self.VKNewsList = news
                self.view?.updateVKNews(news)
            case .failure(let error):
                self.view?.showError("Failed to load news: \(error.localizedDescription)")
            }
        }
    }
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
}
