//
//  VKWallService.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//


import Foundation
class VKWallServicePublic {

    //ссылка
    func createWallRequestURL(token: String, ownerId: String, count: Int = 10) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/wall.get"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: ownerId),
            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        return urlComponents.url
    }
    
    // запрос
    func performWallRequest(with url: URL, completion: @escaping (Result<[VKResponseItem], Error>) -> Void) {
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(VKObject.self, from: data)
                let newsItems = decodedResponse.response.items
                completion(.success(newsItems))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

