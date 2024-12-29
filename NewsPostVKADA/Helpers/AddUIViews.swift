//
//  File.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 11.12.2024.
//

import UIKit
 
extension UIView {
    func addSubViews(_ view: UIView...) {
        view.forEach{
            self.addSubview($0)
        }
    }
}
