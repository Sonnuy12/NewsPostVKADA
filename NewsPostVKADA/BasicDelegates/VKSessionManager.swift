//
//  VKSessionManager.swift
//  NewsPostVKADA
//
//  Created by сонный on 22.12.2024.
//


import Foundation
import VKID 
import UIKit
import VKIDCore

class VKSessionManager {
    private var vkid: VKID!

    func handleSessions(sessions: [UserSession]) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.vkid = appDelegate.vkid
        }
        
        guard let vkid = self.vkid else {
            print("VKID не инициализирован")
            return
        }
        guard !sessions.isEmpty else {
            NotificationCenter.default.post(name: Notification.Name("setVC"), object: nil, userInfo: ["vc": NotificationEnum.authorization])
            print("Сессии отсутствуют")
            return
        }

        for result in sessions {
            if sessions.contains(where: { $0.idToken == result.idToken }) {
                NotificationCenter.default.post(name: Notification.Name("setVC"), object: nil, userInfo: ["vc": NotificationEnum.tabBar])
                print("Найдена сессия: \(result)")

                if let token = vkid.currentAuthorizedSession?.accessToken.value {
                    print("Токен пользователя: \(token)")

                    // Получение данных пользователя
                    vkid.currentAuthorizedSession?.fetchUser { [weak self] result in
                        self?.handleFetchUserResult(result, token: token)
                    }
                }
                break
            }
        }
    }

    private func handleFetchUserResult<E: Error>(_ result: Result<User, E>, token: String) {
        do {
            let user = try result.get()
            saveUserDataToCoreData(user: user)
            saveUserDataToUserDefaults(user: user, token: token)
            createVKWallRequestURL(token: token)
        } catch {
            print("Не удалось получить данные пользователя: \(error.localizedDescription)")
        }
    }

    private func saveUserDataToCoreData(user: User) {
        CoreDataManager.shared.addUserData(
            firstName: user.firstName ?? "nil",
            lastName: user.lastName ?? "nil",
            avatarURL: user.avatarURL?.absoluteString
        )
        print("Сохранено в Core Data: \(user.firstName ?? "nil") \(user.lastName ?? "nil"), \(String(describing: user.avatarURL))")
    }

    private func saveUserDataToUserDefaults(user: User, token: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(user.firstName, forKey: "UserFirstName")
        userDefaults.set(user.lastName, forKey: "UserLastName")
        userDefaults.set(user.avatarURL?.absoluteString, forKey: "UserAvatarURL")
        userDefaults.set(token, forKey: "vkToken")
        userDefaults.synchronize()

        print("Сохранено в UserDefaults: \(user.firstName ?? "nil") \(user.lastName ?? "nil")")
    }

    private func createVKWallRequestURL(token: String) {
        let parameters = [
            "count": "10",  // Количество записей на стене
            "access_token": token,
            "v": "5.131"
        ]

        guard let requestURL = createVKAPIRequestURL(token: token, method: "wall.get", parameters: parameters) else {
            print("Не удалось сформировать ссылку для стены.")
            return
        }

        let requestURLString = requestURL.absoluteString
        let userDefaults = UserDefaults.standard
        userDefaults.set(requestURLString, forKey: "VKWallRequestURL")
        userDefaults.synchronize()

        print("Сформированная ссылка для стены: \(requestURLString)")
    }

    private func createVKAPIRequestURL(token: String, method: String, parameters: [String: String]) -> URL? {
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
        return urlComponents.url
    }
}
