//
//  Ext.Date.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 26.12.2024.
//

import Foundation

func createDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: date)
    }

 func stringFromDate(_ date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    return formatter.string(from: date)
}

 func dateFromString(_ dateString: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    return formatter.date(from: dateString)
}
