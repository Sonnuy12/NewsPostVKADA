//
//  ErrorNilVkPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation

protocol ErrorNilVkPresenterProtocol: AnyObject {
    
}

class ErrorNilVkPresenter: ErrorNilVkPresenterProtocol {

// MARK: - Properties
    weak var view: ErrorNilVkViewProtocol?
    
    init(view: ErrorNilVkViewProtocol) {
        self.view = view
    }
// MARK: - Func
}
