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
    
    private let vkWallServicePublic = VKWallServicePublic()
    private let vkUserService = VKUserService()
    
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
        let sessions: [UserSession] = vkid.authorizedSessions
        let _: UserSession? = vkid.currentAuthorizedSession
        _ = vkid.currentAuthorizedSession?.accessToken
        
        if !sessions.isEmpty {
            NotificationCenter.default.post(name: Notification.Name("setVC"), object: nil, userInfo: ["vc": NotificationEnum.tabBar])
            print("Авторизация прошла успешно, переходим на TabBarController")
            for _ in sessions {
                // все что выше нужно для получения ссылки на сообщество
                if let token = vkid.currentAuthorizedSession?.accessToken.value {
                    let communityId = "-222251367"
                    let postCount = 10
                    
                    if let requestURL = vkWallServicePublic.createWallRequestURL(token: token, ownerId: communityId, count: postCount) {
                        print("Ссылка для запроса стены сообщества: \(requestURL)")
                        
                        // Сохраняем ссылку в UserDefaults
                        UserDefaults.standard.set(requestURL.absoluteString, forKey: "VKWallRequestURLPublic")
                        
                        // Выполняем запрос
                        vkWallServicePublic.performWallRequest(with: requestURL) { result in
                            switch result {
                            case .success(let news):
                                print("Полученные записи: \(news)")
                            case .failure(let error):
                                print("Ошибка запроса стены: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        print("Не удалось сформировать ссылку для запроса стены.")
                    }
                }
                
                
                if let token = vkid.currentAuthorizedSession?.accessToken.value {
                    print("Это личный токен пользователя: \(token)")
                }
                vkUserService.fetchAndSaveUserData(vkid: vkid) { result in
                    switch result {
                    case .success():
                        print("Данные пользователя успешно сохранены.")
                    case .failure(let error):
                        print("Ошибка при получении и сохранении данных пользователя: \(error.localizedDescription)")
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

