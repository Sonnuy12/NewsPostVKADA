//
//  FavoritesStoragePresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation

protocol FavoritesStoragePresenterProtocol: AnyObject {
    
}

class FavoritesStoragePresenter: FavoritesStoragePresenterProtocol {

// MARK: - Properties
    weak var view: FavoritesStorageViewProtocol?
    
    init(view: FavoritesStorageViewProtocol) {
        self.view = view
    }
// MARK: - Func
}
