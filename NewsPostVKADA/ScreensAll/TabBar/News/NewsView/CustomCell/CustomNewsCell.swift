//
//  CustomNewsCell.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 10.12.2024.
//

import UIKit

// MARK: - создание кастомной ячейки
class CustomNewsCell: UICollectionViewCell, SetupNewCell {
    
    static var reuseId: String = "CustomNewsCell"
    var favoriteButtonAction: (() -> Void)?
    var model: NewsArticle? {
        willSet(model){
            datePublication.text =  model?.publishedAt.toReadableDate() ?? "Неизвестная дата"
            mainLabel.text = model?.title
            descriptionLabel.text = model?.description
            websiteLabel.text = model?.url
            
            if let model, model.isFavorite {
                isFavourite.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
                isFavourite.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .selected)
                isFavourite.layoutIfNeeded()
                print("set btn")
            } else {
                isFavourite.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
                isFavourite.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
                isFavourite.layoutIfNeeded()
            }
            
        }
    }
    lazy var newsImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        return $0
    }(UIImageView())
    
    lazy var HstackSiteData: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = 15
        $0.addArrangedSubview(websiteLabel)
        $0.addArrangedSubview(datePublication)
        return $0
    }(UIStackView())
    
    lazy var websiteLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 150).isActive = true
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
        
        $0.widthAnchor.constraint(equalToConstant: 48).isActive = true
        $0.tintColor = .black

        $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
        $0.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return $0
    }(UIButton())
    
    override func prepareForReuse() {
        model = nil
        isFavourite.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        isFavourite.layoutIfNeeded()
        print("reuse")
    }
    
    @objc private func toggleFavorite() {
        isFavourite.isSelected.toggle()
        favoriteButtonAction?()
        print("Кнопка нажата")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItemsInContentViews()
    }
    
    
//    func update(model: NewsArticle) {
//
//            datePublication.text =  model.publishedAt.toReadableDate() ?? "Неизвестная дата"
//            mainLabel.text = model.title
//            descriptionLabel.text = model.description
//            websiteLabel.text = model.url
//            if model.isFavorite {
//                isFavourite.setImage(UIImage(named: "myStarFill"), for: .selected)
//            } else {
//                isFavourite.setImage(UIImage(named: "myStar"), for: .normal)
//            }
//        }
    private func setupItemsInContentViews() {
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 20
        contentView.addSubViews(newsImage,HstackSiteData,mainLabel,descriptionLabel)
        contentView.addSubview(isFavourite)
        setupConstraints()
    }
    
    func setupConstraints() {
       
        NSLayoutConstraint.activate([
            
            newsImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            newsImage.heightAnchor.constraint(equalToConstant: 200),
        
            
            isFavourite.topAnchor.constraint(equalTo: newsImage.topAnchor, constant: 20),
            isFavourite.trailingAnchor.constraint(equalTo: newsImage.trailingAnchor, constant: -20),
            
            HstackSiteData.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 10),
            HstackSiteData.leadingAnchor.constraint(equalTo: newsImage.leadingAnchor, constant: 15),
            HstackSiteData.trailingAnchor.constraint(equalTo: newsImage.trailingAnchor, constant: -15),
            
            mainLabel.topAnchor.constraint(equalTo: HstackSiteData.bottomAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: newsImage.leadingAnchor,constant: 20),
            mainLabel.trailingAnchor.constraint(equalTo: newsImage.trailingAnchor,constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
