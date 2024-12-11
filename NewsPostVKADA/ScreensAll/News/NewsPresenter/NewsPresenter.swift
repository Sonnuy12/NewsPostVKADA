//
//  NewsPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation


protocol NewsPresenterProtocol: AnyObject {
    func loadData()
    var newsList: [NewsEntity] {get set}
    
}

class NewsPresenter: NewsPresenterProtocol {
    
     var newsList: [NewsEntity] = []
// MARK: - Properties
    weak var view: NewsViewProtocol?
    private var model: NewsModelProtocol

    init(view: NewsViewProtocol, model: NewsModelProtocol) {
        self.view = view
        self.model = model
    }
    
// MARK: - Func
    func loadData() {
        let news = model.fetchNews()
        view?.updateNewsList(news)
      }
    
}
