//
//  VKWallService.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//


import Foundation

class VKWallServicePublic {
    
    // Метод для формирования URL для запроса стены
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
    
    // Метод для выполнения запроса к стене
    func performWallRequest(with url: URL, completion: @escaping (Result<[ModelVKNewsErrorNil], Error>) -> Void) {
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
                let decodedResponse = try JSONDecoder().decode(VKNewsResponse.self, from: data)
                let news = decodedResponse.response.items.map { ModelVKNewsErrorNil(from: $0) }
                completion(.success(news))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
