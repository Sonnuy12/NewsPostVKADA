//
//  NewsEntity+CoreDataClass.swift
//  NewsPostVKADA
//
//  Created by сонный on 11.12.2024.
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

    @NSManaged public var attribute: String?
    @NSManaged public var datePublicationPost: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var imageURL: String
    @NSManaged public var isFavourite: Bool
    @NSManaged public var title: String?
    @NSManaged public var website: String?

}

extension NewsEntity : Identifiable {

}
