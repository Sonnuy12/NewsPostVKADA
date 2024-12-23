//
//  VKUserService.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//


import Foundation
import VKID

class VKUserService {
    
    // Метод для получения данных пользователя и сохранения их в CoreData и UserDefaults
    func fetchAndSaveUserData(vkid: VKID, completion: @escaping (Result<Void, Error>) -> Void) {
        vkid.currentAuthorizedSession?.fetchUser { result in
            do {
                let user = try result.get()
                
                // Сохраняем данные в CoreData
                CoreDataManager.shared.addUserData(
                    firstName: user.firstName ?? "nil",
                    lastName: user.lastName ?? "nil",
                    avatarURL: user.avatarURL?.absoluteString
                )
                
                // Сохраняем данные в UserDefaults
                let userDefaults = UserDefaults.standard
                userDefaults.set(user.firstName, forKey: "UserFirstName")
                userDefaults.set(user.lastName, forKey: "UserLastName")
                userDefaults.set(user.avatarURL?.absoluteString, forKey: "UserAvatarURL")
                
                // Сохраняем токен
                if let token = vkid.currentAuthorizedSession?.accessToken.value {
                    userDefaults.set(token, forKey: "vkToken")
                    print("Токен сохранен: \(token)")
                } else {
                    print("Не удалось получить токен.")
                }
                
                userDefaults.synchronize()
                
                print("Сохранено в Core Data и UserDefaults: \(user.firstName ?? "nil") \(user.lastName ?? "nil"), \(String(describing: user.avatarURL))")
                
                // Вызов для дальнейшего использования токена
                self.createVKAPIRequestURL(token: vkid.currentAuthorizedSession?.accessToken.value, method: "wall.get", parameters: ["count": "10"]) { url in
                    if let requestURL = url {
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(requestURL.absoluteString, forKey: "VKUserWallRequestURL")
                        userDefaults.synchronize()
                        print("Сохранено в UserDefaults нужная ссылка для получения новостей со стены: \(requestURL)")
                    } else {
                        print("Не удалось сформировать ссылку для стены.")
                    }
                }
                
                completion(.success(()))
            } catch {
                print("Failed to fetch user info: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // Метод для создания ссылки для API запроса
    func createVKAPIRequestURL(token: String?, method: String, parameters: [String: String], completion: @escaping (URL?) -> Void) {
        guard let token = token else {
            completion(nil)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/\(method)"
        
        var queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        parameters.forEach { key, value in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents.queryItems = queryItems
        completion(urlComponents.url)
    }
}
