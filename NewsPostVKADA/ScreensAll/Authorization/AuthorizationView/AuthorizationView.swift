//
//  AuthorizationView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit

protocol AuthorizationViewProtocol: AnyObject {
    
}

class AuthorizationView: UIViewController, AuthorizationViewProtocol {
    // MARK: - Properties
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
    }
    
    func createBackround() {
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "BackroundAuthorization")
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
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
