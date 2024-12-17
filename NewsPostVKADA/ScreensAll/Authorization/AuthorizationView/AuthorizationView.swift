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
        presenter?.setupOneTapButton()
    }
    
    func createBackround() {
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "BackroundAuthorization")
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
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
    }
    
    func displayAuthError(message: String) {
        print("Ошибка авторизации: \(message)")
    }
    
    func displayAuthCancelled() {
        print("Авторизация отменена пользователем")
    }
}
