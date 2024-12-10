//
//  NewsEntity+CoreDataProperties.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 10.12.2024.
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

    @NSManaged public var descriptionText: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var title: String?
    @NSManaged public var website: String?
    @NSManaged public var attribute: String?
    @NSManaged public var datePublicationPost: Date?
    @NSManaged public var isFavourite: Bool

}

extension NewsEntity : Identifiable {

}
