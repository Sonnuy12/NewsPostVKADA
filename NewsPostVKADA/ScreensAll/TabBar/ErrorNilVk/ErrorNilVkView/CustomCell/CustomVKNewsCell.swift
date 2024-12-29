//
//  CustomVKNewsCell.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//

import UIKit

class CustomVKNewsCell: UICollectionViewCell {
    static let reuseId = "CustomVKNewsCell"
    
    // Основной контейнер для всех элементов ячейки
    lazy var vkCellView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.backgroundColor = .newLightGrey
        $0.addSubview(vkCellImage)
        $0.addSubview(vStack)
        return $0
    }(UIView())
    
    // Изображение в верхней части ячейки
    lazy var vkCellImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    // Заголовок
    lazy var vkCellTitle: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    // Дата публикации
    lazy var vkCellDate: UILabel = {
        $0.textColor = UIColor(named: "dateColor")
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    // Описание (текст поста)
    lazy var vkCellDescription: UILabel = {
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    // Горизонтальный стек для заголовка и даты
    lazy var hStack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 22
        $0.addArrangedSubview(vkCellTitle)
        $0.addArrangedSubview(vkCellDate)
        return $0
    }(UIStackView())
    
    // Вертикальный стек для всех текстовых элементов
    lazy var vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 11
        $0.addArrangedSubview(hStack)
        $0.addArrangedSubview(vkCellDescription)
        return $0
    }(UIStackView())
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vkCellImage.image = nil
        vkCellDescription.text = nil
        vkCellTitle.text = nil
        vkCellDate.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(vkCellView)
        setConstraints()
    }
    
    func configure(with item: VKResponseItem) {
        vkCellTitle.text = "VK.com"
        vkCellDate.text = Date(timeIntervalSince1970: TimeInterval(item.date)).formatted(.dateTime)
        vkCellDescription.text = item.text.isEmpty ? "заголовок отсутствует" : item.text
        
        guard
            let attachments = item.attachments,
            let attachment = attachments.first
        else { return }
        
        switch attachment.type {
        case "photo":
            if let photo = attachment.photo,
               let maxResolution = photo.sizes?.last,
               let url = URL(string: maxResolution.url) {
                loadImage(from: url) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.vkCellImage.image = image
                    }
                }
            }
        case "video":
            if let video = attachment.video,
               let maxResolution = video.image?.last?.url,
               let url = URL(string: maxResolution) {
                loadImage(from: url) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.vkCellImage.image = image
                    }
                }
            }
        default:
            break
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            vkCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            vkCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            vkCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            vkCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            vkCellImage.topAnchor.constraint(equalTo: vkCellView.topAnchor),
            vkCellImage.leadingAnchor.constraint(equalTo: vkCellView.leadingAnchor),
            vkCellImage.trailingAnchor.constraint(equalTo: vkCellView.trailingAnchor),
            vkCellImage.heightAnchor.constraint(equalToConstant: 270),
            
            vStack.topAnchor.constraint(equalTo: vkCellImage.bottomAnchor, constant: 11),
            vStack.leadingAnchor.constraint(equalTo: vkCellView.leadingAnchor, constant: 18),
            vStack.trailingAnchor.constraint(equalTo: vkCellView.trailingAnchor, constant: -18),
            vStack.bottomAnchor.constraint(equalTo: vkCellView.bottomAnchor, constant: -29),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


