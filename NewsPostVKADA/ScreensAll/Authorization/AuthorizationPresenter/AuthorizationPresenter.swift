//
//  AuthorizationPresenter.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import VKID
import VKIDCore

protocol AuthorizationPresenterProtocol: AnyObject {
    func configureVKID(vkid: VKID)
    func setupOneTapButton()
}

class AuthorizationPresenter: AuthorizationPresenterProtocol {
    
    // MARK: - Properties
    weak var view: AuthorizationViewProtocol?
    private var vkid: VKID!
    
    init(view: AuthorizationViewProtocol) {
        self.view = view
    }
    // MARK: - Func
    func configureVKID(vkid: VKID) {
        self.vkid = vkid
    }
    
    func setupOneTapButton() {
        guard let vkid = vkid else { return }
        
        let oneTap = OneTapButton(
            appearance: .init(
                title: .open,
                style: .primary(logo: .vkidPrimary),
                theme: .matchingColorScheme(.light)
            ),
            layout: .regular(
                height: .large(.h56),
                cornerRadius: 28
            ),
            presenter: .newUIWindow
        ) { [weak self] authResult in
            self?.handleAuthResult(authResult)
        }
        // Создаем UI элемент кнопки
        let oneTapView = vkid.ui(for: oneTap).uiView()
        view?.setupOneTapButton(oneTapView)
    }
    
    private func handleAuthResult(_ authResult: Result<UserSession, AuthError>) {
        switch authResult {
        case .success(let session):
            print("Авторизация успешна! Token: \(session.accessToken), User ID: \(String(describing: session.user))")
        case .failure(AuthError.cancelled):
            print("Авторизация отменена пользователем")
        case .failure(let error):
            print("Ошибка авторизации: \(error.localizedDescription)")
        }
    }
}

