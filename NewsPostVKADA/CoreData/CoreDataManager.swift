//
//  CoreDataWork.swift
//  NewsPostVKADA
//
//  Created by сонный on 09.12.2024.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    
    private override init() {}
    
    private var fetchedResultsController: NSFetchedResultsController<NewsEntity>?
    
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
    // MARK: - News CRUD Operations
    func addNews(_ news: NewsEntity) {
        let newEntity = NewsEntity(context: context)
        newEntity.title = news.title
        newEntity.descriptionText = news.descriptionText
        newEntity.imageURL = news.imageURL
        newEntity.datePublicationPost = news.datePublicationPost
        newEntity.website = news.website
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
    
//    func deleteNews(_ news: NewsEntity) {
//        context.delete(news)
//        saveContext()
//    }
    func deleteNews(_ news: NewsEntity) {
        context.delete(news)
        do {
            try context.save()
        } catch {
            print("Ошибка при удалении новости: \(error)")
        }
    }
    
    // MARK: - FetchedResultsController
    func setupNewsFetchedResultsController(delegate: NSFetchedResultsControllerDelegate) {
        let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = delegate
        self.fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            print("Error fetching news: \(error)")
        }
    }
    
    func getAllNews() -> [NewsEntity]? {
        return fetchedResultsController?.fetchedObjects
    }
}

// MARK: - Example Delegate Implementation

extension CoreDataManager: NSFetchedResultsControllerDelegate {
    // Этот метод вызывается, когда данные изменяются в Core Data.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Уведомите UI об изменениях
        print("Данные в Core Data обновлены. Требуется обновить UI.")
    }
}
