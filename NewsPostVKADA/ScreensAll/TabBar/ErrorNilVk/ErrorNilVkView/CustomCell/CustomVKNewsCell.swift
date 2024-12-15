//
//  CustomVKNewsCell.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 12.12.2024.
//

import UIKit

class CustomVKNewsCell: UICollectionViewCell, SetupNewCell {
    
    static var reuseId: String = "CustomVKNewsCell"
    
    lazy var VKnewsImage: UIImageView = {
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
        $0.addArrangedSubview(VKwebsiteLabel)
        $0.addArrangedSubview(datePublication)
        return $0
    }(UIStackView())
    
    lazy var VKwebsiteLabel: UILabel = {
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
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItemsInContentViews()
        
        
    }
    
    private func setupItemsInContentViews() {
        contentView.backgroundColor = .newLightGrey
        contentView.layer.cornerRadius = 20
        contentView.addSubViews(VKnewsImage,HstackSiteData,mainLabel,descriptionLabel)
        setupConstraints()
    }
    
    func configure(with news: ModelVKNews) {
        mainLabel.text = news.title
        descriptionLabel.text = news.descriptionText
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
        datePublication.text = formatter.string(from: news.datePublicationPost)
                VKnewsImage.image = UIImage(named: news.imageURL ?? "No Image")
            
        }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            VKnewsImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            VKnewsImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            VKnewsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            VKnewsImage.heightAnchor.constraint(equalToConstant: 260),
            
            HstackSiteData.topAnchor.constraint(equalTo: VKnewsImage.bottomAnchor, constant: 10),
            HstackSiteData.leadingAnchor.constraint(equalTo: VKnewsImage.leadingAnchor, constant: 15),
            HstackSiteData.trailingAnchor.constraint(equalTo: VKnewsImage.trailingAnchor, constant: -15),
            HstackSiteData.heightAnchor.constraint(equalToConstant: 20),
            
            mainLabel.topAnchor.constraint(equalTo: HstackSiteData.bottomAnchor, constant: 20),
            mainLabel.leadingAnchor.constraint(equalTo: VKnewsImage.leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: VKnewsImage.trailingAnchor),
            
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

