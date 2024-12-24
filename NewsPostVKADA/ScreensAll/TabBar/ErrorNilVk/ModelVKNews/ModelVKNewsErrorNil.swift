//
//  ModelVKNews.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//
import Foundation

//struct ModelVKNewsErrorNil {
//    let title: String
//    let description: String
//    let imageUrl: String
//}
struct ModelVKNewsErrorNil {
    let title: String
    let description: Int
    let imageUrl: String?

    init(from vkNewsItem: VKNewsItem) {
        self.title = "Новость №\(vkNewsItem.text)"
        self.description = vkNewsItem.date
        self.imageUrl = vkNewsItem.attachments?.compactMap { $0.photo?.bestPhotoUrl }.first
    }
}

// Полный ответ API
struct VKNewsResponse: Decodable {
    let response: VKNewsResponseBody
}

struct VKNewsResponseBody: Decodable {
    let count: Int
    let items: [VKNewsItem]
}

struct VKNewsItem: Decodable {
    let id: Int
    let date: Int
    let text: String
    let attachments: [VKNewsAttachment]?
}

struct VKNewsAttachment: Decodable {
    let type: String
    let photo: VKPhoto?
}

struct VKPhoto: Decodable {
    let sizes: [VKPhotoSize]

    var bestPhotoUrl: String? {
        sizes.max(by: { $0.width < $1.width })?.url
    }
}

struct VKPhotoSize: Decodable {
    let url: String
    let width: Int
    let height: Int
}

struct VKObject: Decodable{
    var response: VKResponce
}

struct VKResponce: Decodable{
    var items: [VKResponseItem]
}

struct VKResponseItem: Decodable {
    var text: String
    var attachments: [VKAttachment]?
    var date: Int
}

struct VKAttachment: Decodable{
    var type: String
    var photo: VKPhotoAttachment?
    var video: VKVideoAttachment?
}

struct VKPhotoAttachment: Decodable {
    var sizes: [VKAttachmentImageSize]?
}

struct VKVideoAttachment: Decodable{
    var image: [VKAttachmentImageSize]?
}

struct VKAttachmentImageSize: Decodable{
    var url: String
    var width: Int
    var height: Int
    
}
