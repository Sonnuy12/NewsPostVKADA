//
//  FavoritesStorageView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit

protocol FavoritesStorageViewProtocol: AnyObject {
    
}

class FavoritesStorageView: UIViewController, FavoritesStorageViewProtocol {
    // MARK: - Properties
    var presenter:  FavoritesStoragePresenterProtocol?
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
