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
    
    lazy var newsImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    lazy var HstackSiteData: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .fillEqually
        $0.spacing = 15
        $0.addArrangedSubview(websiteLabel)
        $0.addArrangedSubview(datePublication)
        return $0
    }(UIStackView())
    
    lazy var websiteLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    lazy var datePublication: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .newMediumGrey
        return $0
    }(UILabel())
    
    lazy var mainLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
        $0.textColor = .black
        return $0
    }(UILabel())
    
    lazy var descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .black
        return $0
    }(UILabel())
    
    lazy var isFavourite: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.tintColor = .black
        $0.widthAnchor.constraint(equalToConstant: 21).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 21).isActive = true
        return $0
    }(UIButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItemsInContentViews()
        
        setupElements()
    }
    
    private func setupItemsInContentViews() {
        contentView.backgroundColor = .newLightGrey
        contentView.layer.cornerRadius = 20
        contentView.addSubViews(newsImage,HstackSiteData,mainLabel,descriptionLabel)
        newsImage.addSubview(isFavourite)
        setupConstraints()
    }
    
    func setupElements() {
       
    }
    
     func setupConstraints() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
