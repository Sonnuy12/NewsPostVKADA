//
//  LogoutService.swift
//  NewsPostVKADA
//
//  Created by сонный on 21.12.2024.
//


import Foundation
import VKID

final class LogoutService {
    static let shared = LogoutService()
    
    private init() {}
    
    func logOut(vkid: VKID?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let vkid = vkid else {
            print("VKID не инициализирован")
            completion(.failure(NSError(domain: "LogoutError", code: -1, userInfo: [NSLocalizedDescriptionKey: "VKID не инициализирован"])))
            return
        }
        
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
                
                // Удаление пользовательских данных из CoreData
                CoreDataManager.shared.deleteUserDetails()
                
                // Уведомление об успешном выходе
                NotificationCenter.default.post(name: Notification.Name("setVC"), object: nil, userInfo: ["vc": NotificationEnum.authorization])
                
                completion(.success(()))
            case .failure(let error):
                print("Ошибка при выходе: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
