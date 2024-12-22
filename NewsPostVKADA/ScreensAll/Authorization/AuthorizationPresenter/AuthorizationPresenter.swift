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

        // Создаем UI элемент для кнопки
        let oneTapView = vkid.ui(for: oneTap).uiView()
        view?.setupOneTapButton(oneTapView)
    }

    private func handleAuthResult(_ authResult: Result<UserSession, AuthError>) {
        switch authResult {
        case .success(let session):
            print("Аутентификация прошла успешно! Токен: \(session.accessToken), ID пользователя: \(String(describing: session.idToken))")
            // Запрос разрешений здесь, если это нужно
            self.fetchUserData()
        case .failure(AuthError.cancelled):
            print("Аутентификация отменена пользователем")
        case .failure(let error):
            print("Ошибка аутентификации: \(error.localizedDescription)")
        }
    }

    func fetchUserData() {
        // Получаем данные пользователя, включая стену, если это необходимо
        vkid.currentAuthorizedSession?.fetchUser { result in
            do {
                let user = try result.get()
                print("Информация о пользователе: \(user.firstName ?? "не указано") \(user.lastName ?? "не указано")")
                // Здесь можно запросить дополнительные данные, такие как стену пользователя
            } catch {
                print("Не удалось получить информацию о пользователе: \(error.localizedDescription)")
            }
        }
    }
    
//    func setupOneTapButton() {
//        guard let vkid = vkid else { return }
//        
//        let oneTap = OneTapButton(
//            appearance: .init(
//                title: .open,
//                style: .primary(logo: .vkidPrimary),
//                theme: .matchingColorScheme(.light)
//            ),
//            layout: .regular(
//                height: .large(.h56),
//                cornerRadius: 28
//            ),
//            presenter: .newUIWindow
//        ) { [weak self] authResult in
//            self?.handleAuthResult(authResult)
//            
//        }
//        // Создаем UI элемент кнопки
//        let oneTapView = vkid.ui(for: oneTap).uiView()
//        view?.setupOneTapButton(oneTapView)
//    }
//    private func handleAuthResult(_ authResult: Result<UserSession, AuthError>) {
//        switch authResult {
//        case .success(let session):
//            print("Авторизация успешна! Token: \(session.accessToken), User ID: \(String(describing: session.idToken))")
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "setVC"), object: nil, userInfo: ["vc": NotificationEnum.tabBar])
//        case .failure(AuthError.cancelled):
//            print("Авторизация отменена пользователем")
//        case .failure(let error):
//            print("Ошибка авторизации: \(error.localizedDescription)")
//        }
//    }
}

