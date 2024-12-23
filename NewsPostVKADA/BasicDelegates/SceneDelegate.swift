//
//  SceneDelegate.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit
import VKID

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var vkid: VKID!
    
    var userFirstName: String?
    var userLastName: String?
    var userAvatarImage: URL?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        // Получаем vkid из AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.vkid = appDelegate.vkid
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(transition(nt: )), name: Notification.Name("setVC"), object: nil)
        
        // Создаем экран авторизации через Builder
        guard let vkid = self.vkid else {
            print("VKID не инициализирован")
            return
        }
        // let authorizationView = Builder.CreateAuthorizationView(vkid: vkid)
        
        // Настройка окна
        self.window = UIWindow(windowScene: scene)
        var sessions: [UserSession] = vkid.authorizedSessions
        let sessions1: UserSession? = vkid.currentAuthorizedSession
        
        var token = vkid.currentAuthorizedSession?.accessToken
        
        if !sessions.isEmpty {
            NotificationCenter.default.post(name: Notification.Name("setVC"), object: nil, userInfo: ["vc": NotificationEnum.tabBar])
            print("Авторизация прошла успешно, переходим на TabBarController")
            for result in sessions {
                if sessions.contains(where: { $0.idToken == result.idToken }) {
                    print("ЭТО ТО ЧТО НУЖНО: \(session)")
                    NotificationCenter.default.post(name: Notification.Name("setVC"), object: nil, userInfo: ["vc": NotificationEnum.tabBar])
                    print("ТОТ САМЫЙ SESSIONS: \(sessions) блямблии")
                    print("ТОТ САМЫЙ SESSIONS: \(sessions1) дададададад")
                    print("ТОТ САМЫЙ ТОКЕН : \(String(describing: token)) ВСЁ")
                    
                    if let token = vkid.currentAuthorizedSession?.accessToken.value {
                        print("Это личный токен пользователя: \(token)")
                    }
                    vkid.currentAuthorizedSession?.fetchUser { result in
                        do {
                            let user = try result.get()
                            CoreDataManager.shared.addUserData(
                                firstName: user.firstName ?? "nil",
                                lastName: user.lastName ?? "nil",
                                avatarURL: user.avatarURL?.absoluteString
                            )
                            
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(user.firstName, forKey: "UserFirstName")
                            userDefaults.set(user.lastName, forKey: "UserLastName")
                            userDefaults.set(user.avatarURL?.absoluteString, forKey: "UserAvatarURL")
                            
                            // Сохраняем токен в UserDefaults
                            if let token = vkid.currentAuthorizedSession?.accessToken.value {
                                userDefaults.set(token, forKey: "vkToken")
                                print("Токен сохранен: \(token)")
                            } else {
                                print("Не удалось получить токен.")
                            }
                            
                            userDefaults.synchronize()
                            
                            print("Сохранено в Core Data и UserDefaults: \(user.firstName ?? "nil") \(user.lastName ?? "nil"), \(String(describing: user.avatarURL))")
                            
                            // Используем токен для формирования запроса
                            if let token = vkid.currentAuthorizedSession?.accessToken.value {
                                print("Это личный токен пользователя: \(token)")
                                
                                // Формирование запроса для получения стены пользователя
                                let parameters = [
                                    "count": "10"  // Количество записей на стене
                                ]
                                
                                func createVKAPIRequestURL(token: String, method: String, parameters: [String: String]) -> URL? {
                                    var urlComponents = URLComponents()
                                    urlComponents.scheme = "https"
                                    urlComponents.host = "api.vk.com"
                                    urlComponents.path = "/method/\(method)"
                                    
                                    var queryItems = [
                                        URLQueryItem(name: "access_token", value: token), // Сохраняем только один токен
                                        URLQueryItem(name: "v", value: "5.131") // Версия API
                                    ]
                                    
                                    parameters.forEach { key, value in
                                        queryItems.append(URLQueryItem(name: key, value: value))
                                    }
                                    
                                    urlComponents.queryItems = queryItems
                                    return urlComponents.url
                                }
                                
                                // Запрос стены пользователя
                                if let requestURL = createVKAPIRequestURL(token: token, method: "wall.get", parameters: parameters) {
                                    let requestURLString = requestURL.absoluteString
                                    print("Сформированная ссылка для стены: \(requestURL)")
                                    
                                    // Сохраняем ссылку в UserDefaults
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(requestURLString, forKey: "VKWallRequestURL")
                                    userDefaults.synchronize()
                                    print("Сохранено в UserDefaults нужная ссылка для получения новостей со стены:  \(String(describing: requestURL))")
                                } else {
                                    print("Не удалось сформировать ссылку для стены.")
                                }
                            }
                        } catch {
                            print("Failed to fetch user info: \(error.localizedDescription)")
                        }
                    }
                }
            }
            
        } else {
            NotificationCenter.default.post(name: Notification.Name("setVC"), object: nil, userInfo: ["vc": NotificationEnum.authorization])
            print("ТОТ САМЫЙ SESSIONS: \(sessions) блямблии2.0")
        }
        
        
        self.window?.makeKeyAndVisible()
    }
    
    func setVC(_ vc: NotificationEnum) -> UIViewController {
        switch vc {
        case .authorization:
            return  UINavigationController(rootViewController: Builder.CreateAuthorizationView(vkid: vkid))
        case .tabBar:
            return TabBarController(vkid: vkid)
        }
    }
    
    @objc func transition(nt: Notification) {
        guard let userInfo = nt.userInfo, let vc = userInfo["vc"] as? NotificationEnum else { return }
        self.window?.rootViewController = setVC(vc)
    }
    //    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    //        guard let scene = (scene as? UIWindowScene) else { return }
    //        self.window = UIWindow(windowScene: scene)
    //        self.window?.makeKeyAndVisible()
    //        self.window?.rootViewController = UINavigationController(rootViewController: Builder.CreateAuthorizationView())
    //    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

