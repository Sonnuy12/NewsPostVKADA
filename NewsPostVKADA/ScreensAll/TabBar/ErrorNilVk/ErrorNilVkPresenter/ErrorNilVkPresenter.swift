//
//  ErrorNilVkPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation

protocol ErrorNilVkPresenterProtocol: AnyObject {
    var VKNewsList: [ModelVKNews] { get set }
    func fetchVKNews()
}

class ErrorNilVkPresenter: ErrorNilVkPresenterProtocol {

// MARK: - Properties
    weak var view: ErrorNilVkViewProtocol?
    var VKNewsList: [ModelVKNews] = []
    var apiService: VKApiServiceProtocol
    init(view: ErrorNilVkViewProtocol, apiService: VKApiServiceProtocol) {
        self.view = view
        self.apiService = apiService
    }
// MARK: - Func
    func fetchVKNews() {
            apiService.fetchNews { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let news):
                    self.VKNewsList = news
                    self.view?.updateVKNews(news)
                case .failure(let error):
                    self.view?.showError("Failed to load news: \(error.localizedDescription)")
                }
            }
        }
}
