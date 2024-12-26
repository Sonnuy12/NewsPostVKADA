//
//  ModelNewtworkManager.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 21.12.2024.
//

import Foundation

struct NewsResponse: Codable {
    let articles: [NewsArticle]
}

struct NewsArticle: Codable {
    let title: String
    let description: String
    let urlToImage: String?
    let publishedAt: String
    let url: String
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case urlToImage
        case publishedAt
        case url
    }
}
