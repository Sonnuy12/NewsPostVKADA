//
//  CustomVKNewsCell.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//

import UIKit

//class CustomVKNewsCell: UICollectionViewCell {
//    static let reuseId = "CustomVKNewsCell"
//    
//    lazy var vkCellView: UIView = {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.layer.cornerRadius = 20
//        $0.clipsToBounds = true
//        $0.backgroundColor = UIColor(named: "postMainColor")
//        $0.addSubview(vkCellImage)
//        $0.addSubview(vStack)
//        return $0
//    }(UIView())
//    
//    
//    lazy var vkCellImage: UIImageView = {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.layer.cornerRadius = 20
//        $0.clipsToBounds = true
//        $0.contentMode = .scaleAspectFill
//        return $0
//    }(UIImageView())
//    
//    lazy var vkCellTitle: UILabel = {
//        $0.text = "vk.com"
//        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        return $0
//    }(UILabel())
//    
//    lazy var vkCellDate: UILabel = {
//        $0.textColor = UIColor(named: "dateColor")
//        $0.font = UIFont.systemFont(ofSize: 14)
//        return $0
//    }(UILabel())
//    
//    lazy var vkCellDescription: UILabel? = {
//        $0.numberOfLines = 0
//        return $0
//    }(UILabel())
//    
//    lazy var hStack: UIStackView = {
//        $0.axis = .horizontal
//        $0.spacing = 22
//        $0.addArrangedSubview(vkCellTitle)
//        $0.addArrangedSubview(vkCellDate)
//        return $0
//    }(UIStackView())
//    
//    
//    lazy var vStack: UIStackView = {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.axis = .vertical
//        $0.spacing = 11
//        $0.addArrangedSubview(hStack)
//        $0.addArrangedSubview(vkCellDescription ?? UIView())
//        return $0
//    }(UIStackView())
//    
//    override func prepareForReuse() {
//        vkCellImage.image = nil
//        vkCellDescription = nil
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(vkCellView)
//        setConstraints()
//    }
//    
//    func setCell(item: VKResponseItem){
//        
//        vkCellDate.text = item.date.formatted()
//        vkCellDescription?.text = item.text
//        
//        guard
//            let attachments = item.attachments,
//            let attachment = attachments.first
//        else { return }
//        
//        switch attachment.type {
//        case "photo":
//            let photo = attachment.photo
//            if
//                let maxResilution = photo?.sizes?.last,
//                let url = URL(string: maxResilution.url){
//                self.vkCellImage.load(url: url)
//            }
//        case "video":
//            let photo = attachment.video
//            if
//                let maxResilution = photo?.image?.last?.url,
//                let url = URL(string: maxResilution){
//                
//                self.vkCellImage.load(url: url)
//            }
//        default:
//            return
//        }
//    }
//    
//    private func setConstraints(){
//        NSLayoutConstraint.activate([
//            vkCellView.topAnchor.constraint(equalTo: topAnchor),
//            vkCellView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            vkCellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            vkCellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            vkCellView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
//            
//            vkCellImage.topAnchor.constraint(equalTo: vkCellView.topAnchor),
//            vkCellImage.leadingAnchor.constraint(equalTo: vkCellView.leadingAnchor),
//            vkCellImage.trailingAnchor.constraint(equalTo: vkCellView.trailingAnchor),
//            vkCellImage.heightAnchor.constraint(equalToConstant: 270),
//            
//            vStack.topAnchor.constraint(equalTo: vkCellImage.bottomAnchor, constant: 11),
//            vStack.leadingAnchor.constraint(equalTo: vkCellView.leadingAnchor, constant: 18),
//            vStack.trailingAnchor.constraint(equalTo: vkCellView.trailingAnchor, constant: -18),
//            vStack.bottomAnchor.constraint(equalTo: vkCellView.bottomAnchor, constant: -29),
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class CustomVKNewsCell: UICollectionViewCell {
    static let reuseId = "CustomVKNewsCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(newsImageView)

        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with news: ModelVKNewsErrorNil) {
        titleLabel.text = news.title ?? "нет текста в новости "
        descriptionLabel.text = news.description.description ?? "бля бла бля а не дата "
        if let url = URL(string: news.imageUrl ?? "риволаиовталовыоатоывтлоатлв") {
            // Используем URL для загрузки изображения
            loadImage(from: url)
        }
    }

    private func loadImage(from url: URL) {
        DispatchQueue.main.async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.newsImageView.image = image
                }
            }
        }
    }
}
