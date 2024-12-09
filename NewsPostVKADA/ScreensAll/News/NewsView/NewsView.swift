//
//  NewsView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit

protocol NewsViewProtocol: AnyObject {
    
}

class NewsView: UIViewController, NewsViewProtocol {
    
    // MARK: - Properties
    var presenter: NewsPresenterProtocol?
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
