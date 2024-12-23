//
//  VKAPIService.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 12.12.2024.
//

import Foundation
// MARK: - в этом классе будет находится отработка запросов VK API
protocol VKApiServiceProtocol {
    func fetchNews(completion: @escaping (Result<[ModelVKNewsErrorNil], Error>) -> Void)
}

class VKApiService: VKApiServiceProtocol {
    func fetchNews(completion: @escaping (Result<[ModelVKNewsErrorNil], Error>) -> Void) {
//        let urlString = "https://example.com/vknews" // Укажите ваш URL
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            do {
//                // Декодируем JSON в массив ModelVKNews
//                let decodedData = try JSONDecoder().decode([ModelVKNews].self, from: data)
//
//                // Преобразуем в VKNews
////                let news = decodedData.map { VKNews -> VKNews in
////                    return ModelVKNews(
////                        id: VKNews.id,
////                        title: VKNews.title,
////                        content: VKNews.content,
////                        date: ISO8601DateFormatter().date(from: vkNews.date) ?? Date(),
////                        imageUrl: VKNews.imageUrl
////                    )
//                }
//
//                completion(.success(news))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
    }
}
