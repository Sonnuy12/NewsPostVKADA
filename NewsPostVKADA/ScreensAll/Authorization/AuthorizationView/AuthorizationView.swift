//
//  AuthorizationView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//
//ID: 52848505


import UIKit
import VKID
import VKIDCore

protocol AuthorizationViewProtocol: AnyObject {
    
}

class AuthorizationView: UIViewController, AuthorizationViewProtocol {
    // MARK: - Properties
    var vkid: VKID!
    var presenter: AuthorizationPresenterProtocol?
    
    lazy var authorizationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = UIColor.black
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(authorizationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackround()
        view.addSubview(authorizationButton)
        setupButtonConstraints()
        
        createOneTap()
    }
    
    func createBackround() {
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "BackroundAuthorization")
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
    func createOneTap() {
        // Создаем конфигурацию для кнопки One Tap
        let oneTap = OneTapButton(
            appearance: .init(
                style: .primary(),
                theme: .matchingColorScheme(.system)
            ),
            layout: .regular(
                height: .large(.h56),
                cornerRadius: 28
            ),
            presenter: .newUIWindow
        ) { authResult in
            // Обработка результата авторизации.
            do {
                let session = try authResult.get()
                print("Auth succeeded with token: \(session.accessToken)")
            } catch AuthError.cancelled {
                print("Auth cancelled by user")
            } catch {
                print("Auth failed with error: \(error)")
            }
        }
        
        // Создаем кнопку One Tap и получаем UIView для неё
        let oneTapView = vkid?.ui(for: oneTap).uiView()
        // Настройка для добавления кнопки на экран
        oneTapView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(oneTapView ?? authorizationButton)
    }
    
    private func setupButtonConstraints() {
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            authorizationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            authorizationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            authorizationButton.heightAnchor.constraint(equalToConstant: 51)
        ])
    }
    // метод действия для кнопки
    @objc func authorizationButtonTapped() {
        print("Кнопка авторизации нажата!")
    }
}
