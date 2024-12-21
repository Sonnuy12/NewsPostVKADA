//
//  ModelNewtworkManager.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 21.12.2024.
//

import Foundation

struct NewsResponse: Decodable {
    let articles: [NewsArticle]
}

struct NewsArticle: Decodable {
    let title: String
    let description: String
    let urlToImage: String?
    let publishedAt: String
    let url: String
}
