//
//  NewsPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation


protocol NewsPresenterProtocol: AnyObject {
    
}

class NewsPresenter: NewsPresenterProtocol {

// MARK: - Properties
    weak var view: NewsViewProtocol?
    
    init(view: NewsViewProtocol) {
        self.view = view
    }
    
// MARK: - Func
}
