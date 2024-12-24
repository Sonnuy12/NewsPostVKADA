//
//  CustomVKNewsCell.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//

import UIKit
class CustomVKNewsCell: UICollectionViewCell {
    static let reuseId = "CustomVKNewsCell"
    
    private let vkCellTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let vkCellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(vkCellImage)
        contentView.addSubview(vkCellTitle)
        
        // Пример размещения элементов
        vkCellImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 0.6)
        vkCellTitle.frame = CGRect(x: 5, y: vkCellImage.frame.maxY + 5, width: frame.width - 10, height: frame.height * 0.4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: VKResponseItem) {
        vkCellTitle.text = item.text.isEmpty ? "Без текста" : item.text
        if let imageUrl = item.attachments?.compactMap({ attachment in
            if attachment.type == "photo", let photo = attachment.photo, let size = photo.sizes?.last {
                return size.url
            } else if attachment.type == "video", let video = attachment.video, let size = video.image?.last {
                return size.url
            }
            return nil
        }).first, let url = URL(string: imageUrl) {
            loadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.vkCellImage.image = image
                }
            }
        } else {
            vkCellImage.image = UIImage(systemName: "photo") // Заглушка
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }.resume()
    }
}

