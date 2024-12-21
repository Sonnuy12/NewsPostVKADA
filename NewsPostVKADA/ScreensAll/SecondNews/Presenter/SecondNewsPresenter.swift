//
//  SecondNewsPresenter.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 21.12.2024.
//

import Foundation

protocol SecondNewsPresenterProtocol: AnyObject {
    var newsData: NewsArticle {get set}
}

class SecondNewsPresenter:SecondNewsPresenterProtocol {
    
    var newsData: NewsArticle
   
    weak var view: SecondNewsViewProtocol?
    init(view: SecondNewsViewProtocol, newsData: NewsArticle) {
        self.view = view
        self.newsData = newsData
    }
}
