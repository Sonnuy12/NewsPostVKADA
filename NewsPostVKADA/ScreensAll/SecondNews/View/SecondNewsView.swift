//
//  SecondNewsView.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 21.12.2024.
//

import UIKit

protocol SecondNewsViewProtocol: AnyObject {
    
}

class SecondNewsView: UIViewController ,SecondNewsViewProtocol {
 
    var presenter: SecondNewsPresenterProtocol!
    
    lazy var mainImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.heightAnchor.constraint(equalToConstant: 200).isActive = true
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
   
    lazy var datePublication: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    lazy var websiteLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    lazy var mainLabel: UILabel = AddLabel(fontText: 16, fontW: .bold, colorText: .black)
    lazy var descriptionLabel: UILabel = AddLabel(fontText: 16, fontW: .medium, colorText: .black)
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubViews(mainImage,mainLabel,descriptionLabel)
        mainImage.addSubViews(HstackSiteData)
        setupElements()
        setupConstraints()
    }
    private func setupElements() {
        descriptionLabel.text = presenter.newsData.description
        mainLabel.text = presenter.newsData.title
        websiteLabel.text = presenter.newsData.url
        datePublication.text = presenter.newsData.publishedAt
        guard let url = URL(string: presenter.newsData.urlToImage ?? "") else { return }
        mainImage.sd_setImage(with: url)
        
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
           
            HstackSiteData.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -20),
            HstackSiteData.leadingAnchor.constraint(equalTo: mainImage.leadingAnchor, constant: 15),
            HstackSiteData.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -15),
           
            
            mainLabel.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: mainImage.leadingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor),
           
        ])
    }
    
}
