//
//  SecondNewsPresenter.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 21.12.2024.
//

import Foundation

protocol SecondNewsPresenterProtocol: AnyObject {
    var newsData: NewsArticle {get set}
    func viewDidTapOpenWebsite()
}

class SecondNewsPresenter:SecondNewsPresenterProtocol {
    
    var newsData: NewsArticle
   
    weak var view: SecondNewsViewProtocol?
    init(view: SecondNewsViewProtocol, newsData: NewsArticle) {
        self.view = view
        self.newsData = newsData
    }
    
    // Возвращаем URL сайта
       func getWebsiteURL() -> URL? {
           return URL(string: newsData.url)
       }

       // Обрабатываем нажатие кнопки
       func viewDidTapOpenWebsite() {
           guard let url = getWebsiteURL() else {
               view?.showError("Некорректный URL сайта")
               return
           }
           view?.openWebsite(url: url)
       }
}
