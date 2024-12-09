//
//  CustomNewsCell.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 10.12.2024.
//

import UIKit
// MARK: - протокол для создания кастомной ячейки
protocol SetupNewCell: AnyObject {
    static var reuseId: String { get }
    
    func setupElements()
    func setupConstraints()
}
// MARK: - создание кастомной ячейки
class CustomNewsCell: UICollectionViewCell, SetupNewCell {
    static var reuseId: String = "CustomNewsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    
   
    
    func setupElements() {
        setupConstraints()
    }
    
    func setupConstraints() {
        <#code#>
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
