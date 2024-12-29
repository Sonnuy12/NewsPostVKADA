//
//  Ext.String.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 22.12.2024.
//

import Foundation

extension String {
    // Преобразует строку даты в читаемый формат, как на скриншоте.
    func toReadableDate() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Укажите формат входящей строки
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM yyyy" // Формат для отображения
            outputFormatter.locale = Locale(identifier: "ru_RU") // Русский язык
            
            return outputFormatter.string(from: date)
        }
        return nil
    }
}
