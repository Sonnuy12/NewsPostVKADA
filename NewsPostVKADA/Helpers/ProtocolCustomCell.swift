//
//  ProtocolCustomCell.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 14.12.2024.
//

import Foundation

// MARK: - протокол для создания кастомной ячейки
protocol SetupNewCell: AnyObject {
    static var reuseId: String { get }
    func setupConstraints()
}
