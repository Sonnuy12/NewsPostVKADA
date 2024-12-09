//
//  AuthorizationPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation

protocol AuthorizationPresenterProtocol: AnyObject {
    
}

class AuthorizationPresenter: AuthorizationPresenterProtocol {

// MARK: - Properties
    weak var view: AuthorizationViewProtocol?
    
    init(view: AuthorizationViewProtocol) {
        self.view = view
    }
// MARK: - Func
}
