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
