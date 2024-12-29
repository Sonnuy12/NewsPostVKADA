//
//  TabBarView.swift
//  NewsPostVKADA
//
//  Created by сонный on 15.12.2024.
//

import Foundation
import UIKit
import VKID

class TabBarController: UITabBarController {
    
    private var news: UIViewController
    private var errorNilVk: UIViewController
    private var favoritesStorage: UIViewController 
    init(vkid: VKID) {
        self.news = Builder.CreateNewsView(vkid: vkid)
        self.errorNilVk = Builder.CreateErrorNilVkView(vkid: vkid)
        self.favoritesStorage = Builder.CreateFavoritesStorageView(vkid: vkid)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
