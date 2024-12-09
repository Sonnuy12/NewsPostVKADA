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
    private var model: NewsModelProtocol?

    init(view: NewsViewProtocol, model: NewsModelProtocol) {
        self.view = view
        self.model = model
    }
    
// MARK: - Func
    func loadData() {
        let news = model?.fetchNews()
          view?.updateUI()
      }
}
