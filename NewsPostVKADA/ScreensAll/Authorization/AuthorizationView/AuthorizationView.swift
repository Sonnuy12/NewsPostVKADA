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
    func setupOneTapButton(_ oneTapView: UIView)
    func displayAuthSuccess(user: String, token: String)
    func displayAuthError(message: String)
    func displayAuthCancelled()
}

class AuthorizationView: UIViewController, AuthorizationViewProtocol {
    // MARK: - Properties
    var vkid: VKID!
    var presenter: AuthorizationPresenterProtocol?
    
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackround()
        setupAuthorizationLabels()
        presenter?.setupOneTapButton()
    }
    
    func createBackround() {
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "BackroundAuthorization")
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
    
    func createLabelAvtorization() -> UIStackView {
        // Создаем первый лейбл
        let errorLabel = UILabel()
        errorLabel.text = "Error Nil"
        errorLabel.font = .systemFont(ofSize: 35, weight: .bold)
        errorLabel.textColor = .white
        errorLabel.textAlignment = .left
        
        // Создаем второй лейбл
        let teamLabel = UILabel()
        teamLabel.text = "Team DA"
        teamLabel.font = .systemFont(ofSize: 20, weight: .medium)
        teamLabel.textColor = .white
        teamLabel.textAlignment = .left
        
        // Создаем стек и добавляем лейблы
        let stackView = UIStackView(arrangedSubviews: [errorLabel, teamLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        return stackView
    }
    func setupAuthorizationLabels() {
        let authorizationLabels = createLabelAvtorization()
        authorizationLabels.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authorizationLabels)
        
        NSLayoutConstraint.activate([
            authorizationLabels.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            authorizationLabels.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorizationLabels.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    func setupOneTapButton(_ oneTapView: UIView) {
        oneTapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oneTapView)
        
        NSLayoutConstraint.activate([
            oneTapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oneTapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            oneTapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            oneTapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            oneTapView.heightAnchor.constraint(equalToConstant: 56),
            
        ])
    }
    
    func displayAuthSuccess(user: String, token: String) {
        print("Авторизация успешна! Token: \(token), User ID: \(user)")
       // print("ТОТ САМЫЙ SESSIONS: \(sessions) блямблии")
        print("ТОТ САМЫЙ ТОКЕН : \(token) ВСЁ")
    }
    
    func displayAuthError(message: String) {
        print("Ошибка авторизации: \(message)")
    }
    
    func displayAuthCancelled() {
        print("Авторизация отменена пользователем")
    }
}
