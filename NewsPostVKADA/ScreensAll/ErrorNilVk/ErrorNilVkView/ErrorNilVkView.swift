//
//  ErrorNilVkView.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import UIKit

protocol ErrorNilVkViewProtocol: AnyObject {
    
}

class ErrorNilVkView: UIViewController, ErrorNilVkViewProtocol {
    // MARK: - Properties
    var presenter:  ErrorNilVkPresenterProtocol?
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
