//
//  CoreDataWork.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    
    func addNews(title: String, descriptionText: String, imageURL: String) {
        let news = NewsEntity(context: context)
        news.title = title
        news.descriptionText = descriptionText
        news.imageURL = imageURL
        saveContext()
    }
    
    func fetchNews() -> [NewsEntity] {
        let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching news: \(error)")
            return []
        }
    }
    
    func deleteNews(_ news: NewsEntity) {
        context.delete(news)
        saveContext()
    }
}
