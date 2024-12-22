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
                userDefaults.removeObject(forKey: "VKWallRequestURL")
                
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
//ФУНКЦИЯ ИЗ NEWSVIEW (может пригодиться)
//выбрал более оптимальный способ через базу данных
//        //получение данных из UserDefaults
//        let userDefaults = UserDefaults.standard
//          if let imageURLString = userDefaults.string(forKey: "UserAvatarURL"),
//             let imageURL = URL(string: imageURLString) {
//              // Загрузка изображения асинхронно
//              URLSession.shared.dataTask(with: imageURL) { data, response, error in
//                  guard let data = data, error == nil else {
//                      print("Ошибка загрузки изображения: \(String(describing: error))")
//                      return
//                  }
//                  DispatchQueue.main.async {
//                      profileImageView.image = UIImage(data: data)
//                  }
//              }.resume()
//          } else {
//              profileImageView.image = UIImage(systemName: "Person")
//          }
//
//        if let userName = userDefaults.string(forKey: "UserFirstName"), let userLastName = userDefaults.string(forKey: "UserLastName")  {
//            let fullUserName = userName + " " + userLastName
//            nameLabel.text = fullUserName
//          } else {
//              nameLabel.text = "Гость" // Имя по умолчанию
//          }
