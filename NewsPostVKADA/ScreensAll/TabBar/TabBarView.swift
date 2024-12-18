//
//  TabBarView.swift
//  NewsPostVKADA
//
//  Created by сонный on 15.12.2024.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    private var news = Builder.CreateNewsView()
    private var errorNilVk = Builder.CreateErrorNilVkView()
    private var favoritesStorage = Builder.CreateFavoritesStorageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = UIColor.newLightGrey
        
        tabBar.tintColor = UIColor.black
        tabBar.unselectedItemTintColor = UIColor.lightGray
        
        let news = UINavigationController(rootViewController: news)
        let errorNilVk = UINavigationController(rootViewController: errorNilVk)
        let favoritesStorage = UINavigationController(rootViewController: favoritesStorage)
        
        news.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(named: "myStar"), tag: 0)
        errorNilVk.tabBarItem = UITabBarItem(title: "Error Nil VK", image: UIImage(named: "vk"), tag: 1)
        favoritesStorage.tabBarItem = UITabBarItem(title: "Хранилище", image: UIImage(named: "myStarFill"), tag: 2)
        
        setViewControllers([news, errorNilVk, favoritesStorage], animated: true)
    }
}
