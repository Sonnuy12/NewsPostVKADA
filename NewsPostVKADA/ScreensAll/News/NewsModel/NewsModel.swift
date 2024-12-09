//
//  NewsModel.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation

protocol NewsModelProtocol {
    func fetchNews() -> [NewsEntity]
    
    func addNews(title: String, description: String, imageURL: String)
    
    func deleteNews(_ news: NewsEntity)
}

class NewsModel: NewsModelProtocol {
    private let coreDataManager = CoreDataManager.shared
    
    func fetchNews() -> [NewsEntity] {
        return coreDataManager.fetchNews()
    }
    
    func addNews(title: String, description: String, imageURL: String) {
        coreDataManager.addNews(title: title, descriptionText: description, imageURL: imageURL)
    }
    
    func deleteNews(_ news: NewsEntity) {
        coreDataManager.deleteNews(news)
    }
}
