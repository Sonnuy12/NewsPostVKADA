//
//  Builder.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import UIKit

class Builder {
    
    static func CreateAuthorizationView() -> UIViewController {
        let view = AuthorizationView()
        let presenter = AuthorizationPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func CreateNewsView() -> UIViewController {
        let view = NewsView()
        let presenter = NewsPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func CreateErrorNilVkView() -> UIViewController {
        let view = ErrorNilVkView() 
        let presenter = ErrorNilVkPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func CreateFavoritesStorageView() -> UIViewController {
        let view = FavoritesStorageView()
        let presenter = FavoritesStoragePresenter(view: view)
        view.presenter = presenter
        return view
    }
}
