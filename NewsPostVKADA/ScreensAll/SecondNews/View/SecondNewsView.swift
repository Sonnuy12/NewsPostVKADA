//
//  SecondNewsView.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 21.12.2024.
//

import UIKit

protocol SecondNewsViewProtocol: AnyObject {
    func showError(_ message: String)
    func openWebsite(url: URL)
}

class SecondNewsView: UIViewController ,SecondNewsViewProtocol {
 
    var presenter: SecondNewsPresenterProtocol!
    
    lazy var scroll: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = true
        return $0
    }(UIScrollView())
    
    lazy var contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    lazy var mainImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        return $0
    }(UIImageView())
    
    private let gradientLayer = CAGradientLayer()
    
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
        $0.widthAnchor.constraint(equalToConstant: 150).isActive = true
        $0.textColor = .white
        return $0
    }(UILabel())
    
    lazy var mainLabel: UILabel = AddLabel(fontText: 16, fontW: .bold, colorText: .black)
    lazy var descriptionLabel: UILabel = AddLabel(fontText: 16, fontW: .medium, colorText: .black)
    lazy var goToSiteButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Перейти на сайт", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        $0.layer.cornerRadius = 30
        return $0
    }(UIButton(primaryAction: goToSiteAction))

    lazy var goToSiteAction: UIAction = UIAction { [weak self] transition in
        self?.presenter.viewDidTapOpenWebsite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubViews(scroll,goToSiteButton)
        scroll.addSubview(contentView)
        contentView.addSubViews(mainImage,mainLabel,descriptionLabel)
        mainImage.addSubViews(HstackSiteData)
        setupElements()
        setupConstraints()
        addGradientToImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = mainImage.bounds
    }
    
    private func setupElements() {
        descriptionLabel.text = presenter.newsData.description
        mainLabel.text = presenter.newsData.title
        websiteLabel.text = presenter.newsData.url
        datePublication.text = presenter.newsData.publishedAt.toReadableDate()
        guard let url = URL(string: presenter.newsData.urlToImage ?? "") else { return }
        mainImage.sd_setImage(with: url)
       
        
    }

    private func setupConstraints() {
       
        NSLayoutConstraint.activate([
            
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            // Обязательные констрейнты для ширины
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor),
            
            mainImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainImage.heightAnchor.constraint(equalTo: mainImage.widthAnchor, multiplier: mainImage.image?.getRation() ?? 1),
           
            HstackSiteData.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -40),
            HstackSiteData.leadingAnchor.constraint(equalTo: mainImage.leadingAnchor, constant: 15),
            HstackSiteData.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -15),
           
            
            mainLabel.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: mainImage.leadingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -100),
         
            
           // goToSiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 80),
            goToSiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goToSiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            goToSiteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
           
        ])
    }
    
    private func addGradientToImageView() {
           // Создаём слой градиента
        gradientLayer.frame = mainImage.bounds

        // Устанавливаем цвета градиента (например, от прозрачного к чёрному)
        gradientLayer.colors = [
            UIColor.clear.cgColor,   // Прозрачный
            UIColor.black.cgColor    // Чёрный
        ]
        // Устанавливаем точки начала и конца градиента
     gradientLayer.locations = [0.5, 1.0]
        // Добавляем слой градиента в `imageView`
     mainImage.layer.insertSublayer(gradientLayer, at: 0)
       }
   
    func showError(_ message: String) {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
    // Реализация протокола `NewsViewProtocol`
        func openWebsite(url: URL) {
            UIApplication.shared.open(url)
        }
}
extension UIImage {
    func getRation() -> CGFloat? {
        return self.size.height / self.size.width
    }
}
