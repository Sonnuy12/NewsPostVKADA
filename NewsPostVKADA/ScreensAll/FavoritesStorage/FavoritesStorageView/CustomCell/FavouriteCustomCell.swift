//
//  FavouriteCustomCell.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 14.12.2024.
//

import UIKit

class FavouriteCustomCell: UICollectionViewCell,SetupNewCell {
    static var reuseId: String = "FavouriteCustomCell"
    
    lazy var FavouriteImage: UIImageView = {
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
        
      
    }
    
    private func setupItemsInContentViews() {
        contentView.backgroundColor = .newLightGrey
        contentView.layer.cornerRadius = 20
        contentView.addSubViews(FavouriteImage,HstackSiteData,mainLabel,descriptionLabel)
        FavouriteImage.addSubview(isFavourite)
        setupConstraints()
    }
    
     func configureElements(items: NewsEntity) {
        FavouriteImage.image = UIImage(named: items.imageURL)
       datePublication.text = items.datePublicationPost?.description
       mainLabel.text = items.title
        descriptionLabel.text = items.descriptionText
       websiteLabel.text = items.website
    }
    
     func setupConstraints() {
         NSLayoutConstraint.activate([
            
             FavouriteImage.topAnchor.constraint(equalTo: contentView.topAnchor),
             FavouriteImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             FavouriteImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             FavouriteImage.heightAnchor.constraint(equalToConstant: 260),
             
             isFavourite.topAnchor.constraint(equalTo: FavouriteImage.topAnchor, constant: 20),
             isFavourite.trailingAnchor.constraint(equalTo: FavouriteImage.trailingAnchor, constant: -20),
             
             HstackSiteData.topAnchor.constraint(equalTo: FavouriteImage.bottomAnchor, constant: 10),
             HstackSiteData.leadingAnchor.constraint(equalTo: FavouriteImage.leadingAnchor, constant: 15),
             HstackSiteData.trailingAnchor.constraint(equalTo: FavouriteImage.trailingAnchor, constant: -15),
             HstackSiteData.heightAnchor.constraint(equalToConstant: 20),
             
             mainLabel.topAnchor.constraint(equalTo: HstackSiteData.bottomAnchor, constant: 20),
             mainLabel.leadingAnchor.constraint(equalTo: FavouriteImage.leadingAnchor),
             mainLabel.trailingAnchor.constraint(equalTo: FavouriteImage.trailingAnchor),
             
             descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
             descriptionLabel.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor),
             descriptionLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor),
             descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
             
             
         ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

