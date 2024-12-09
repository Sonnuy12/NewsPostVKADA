//
//  NewsEntity+CoreDataClass.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
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

    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var imageURL: String?

}

extension NewsEntity : Identifiable {

}
