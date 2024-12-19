//
//  AppDelegate.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit
import VKID

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //шаг второй 2
    var vkid: VKID?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        //Шаг первый 1
        // Override point for customization after application launch.
        do {
            self.vkid = try VKID(
                config: Configuration(
                    appCredentials: AppCredentials(
                        clientId: "52851134",
                        clientSecret: "eAVPARleqv1sg8o53F7S"
                    ),
                    loggingEnabled: false
                )
            )
        } catch {
            preconditionFailure("Failed to initialize VKID: \(error)")
        }
        return true
    }
    //шаг второй 2
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        // Переадресация URL в VKID
        return vkid?.open(url: url) ?? false
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

