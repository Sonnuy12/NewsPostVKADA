//
//  ModelVKNews.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 12.12.2024.
//

import UIKit

struct ModelVKNews: Decodable {
    var datePublicationPost: Date
    var descriptionText: String?
    var imageURL: String?
    var title: String?
    var website: String?
}


//extension ModelVKNews {
//    init(post: VKPost) {
//        self.datePublicationPost = Date() // Можно заменить на значение из данных VKPost, если оно доступно
//        self.descriptionText = post.text
//        self.imageURL = post.attachments?.compactMap { $0.photo?.largestSize?.url }.first
//        self.title = nil // Если в посте есть отдельное поле для заголовка, укажите его
//        self.website = "vk.com"
//    }
//}
