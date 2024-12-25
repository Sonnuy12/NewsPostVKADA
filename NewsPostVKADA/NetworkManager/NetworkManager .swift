//
//  NetworkManager .swift
//  NewsPostVKADA
//
//  Created by сонный on 20.12.2024.
//6acd36096d444a868a642a4c80ae7056 мой api ключ
//https://newsapi.org/v2/top-headlines?country=ru&apiKey=6acd36096d444a868a642a4c80ae7056 ссылка 
// 272febfd86b748d8a596bb715e43fdb6 my API-key
import Foundation


//protocol NewsAPIManagerProtocol: AnyObject {
//    func fetchNews()
//}

class NewsAPIManager {

    private let apiKey = "272febfd86b748d8a596bb715e43fdb6"
    private let baseURL = "https://newsapi.org/v2/everything"
    
    func fetchNews(for country: String, completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: country),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = urlComponents.url else { return }
        print("НУЖАЯ ССЫЛКА НА API: \(url) ")
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(response.articles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

