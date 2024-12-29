//
//  NewsEntity+CoreDataClass.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 26.12.2024.
//
//

import Foundation
import CoreData

@objc(NewsEntity)
public class NewsEntity: NSManagedObject {

}
extension NewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsEntity> {
        return NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
    }

    @NSManaged public var datePublicationPost: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var title: String?
    @NSManaged public var website: String?

}

extension NewsEntity : Identifiable {

}
