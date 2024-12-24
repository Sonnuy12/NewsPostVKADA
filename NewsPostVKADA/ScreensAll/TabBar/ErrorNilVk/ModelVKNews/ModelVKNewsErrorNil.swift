//
//  ModelVKNews.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//
import Foundation

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
