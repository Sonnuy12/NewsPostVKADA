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
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackround()
    }
    
    func createBackround() {
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "BackroundAuthorization")
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
}

