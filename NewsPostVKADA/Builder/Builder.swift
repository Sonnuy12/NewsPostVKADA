//
//  Builder.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import UIKit
import VKID

class Builder {
    
    static func CreateAuthorizationView(vkid: VKID) -> UIViewController {
          let view = AuthorizationView()
          let presenter = AuthorizationPresenter(view: view)
          presenter.configureVKID(vkid: vkid) // Передаем VKID в Presenter
          view.presenter = presenter
          view.vkid = vkid
          return view
      }
    
    static func CreateNewsView(vkid: VKID) -> UIViewController {
        let view = NewsView()
        let model = NewsModel()
        let presenter = NewsPresenter(view: view, model: model)
        presenter.configureVKID(vkid: vkid)
        view.presenter = presenter
        return view
    }
    
    static func CreateErrorNilVkView() -> UIViewController {
        let view = ErrorNilVkView()
        let vkApiService = VKApiService()
        let presenter = ErrorNilVkPresenter(view: view, apiService: vkApiService)
        view.presenter = presenter
        return view
    }
    
    static func CreateFavoritesStorageView() -> UIViewController {
        let view = FavoritesStorageView()
        let presenter = FavoritesStoragePresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func createSecondNewsView(newsData:NewsArticle) -> UIViewController {
        let view = SecondNewsView()
        let presenter = SecondNewsPresenter(view: view, newsData: newsData)
        view.presenter = presenter
        return view
    }
}
