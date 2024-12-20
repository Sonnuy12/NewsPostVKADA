//
//  NewsModel.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation

protocol NewsModelProtocol {
    func fetchNews() -> [NewsEntity]
    
    func addNews(_ news: NewsEntity)
    
    func deleteNews(_ news: NewsEntity)
}

class NewsModel: NewsModelProtocol {
    private let coreDataManager = CoreDataManager.shared
    
    func fetchNews() -> [NewsEntity] {
        return coreDataManager.fetchNews()
    }
    
    func addNews(_ news: NewsEntity){
        coreDataManager.addNews(news)
    }
    
    func deleteNews(_ news: NewsEntity) {
        coreDataManager.deleteNews(news)
    }
}

