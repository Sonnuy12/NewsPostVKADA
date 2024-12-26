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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel") // Укажите имя вашей модели
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

       func saveToFavorites(news: NewsArticle) {
           let favorite = NewsEntity(context: context)
           favorite.title = news.title
           favorite.descriptionText = news.description
           favorite.imageURL = news.urlToImage ?? ""
           favorite.datePublicationPost = dateFromString(news.publishedAt)
           favorite.website = news.url
           favorite.isFavourite = true

           do {
               try context.save()
           } catch {
               print("Error saving to Core Data: \(error.localizedDescription)")
           }
       }

    func fetchFavorites() -> [NewsArticle] {
        let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results.map { newsEntity in
                NewsArticle(
                               title: newsEntity.title ?? "",
                               description: newsEntity.descriptionText ?? "",
                               urlToImage: newsEntity.imageURL,
                               publishedAt: newsEntity.datePublicationPost != nil ? stringFromDate(newsEntity.datePublicationPost!) : "", // Преобразование даты в строку
                               url: newsEntity.website ?? "",
                               isFavorite: true
                )
            }
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
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
    func addNews(_ news: NewsArticle) {
        let newEntity = NewsEntity(context: context)
        newEntity.title = news.title
        newEntity.descriptionText = news.description
        newEntity.imageURL = news.urlToImage
        newEntity.datePublicationPost = dateFromString(news.publishedAt) 
        newEntity.website = news.url
        saveContext()
    }
//    func fetchNews() -> [NewsEntity] {
//        let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            print("Error fetching news: \(error)")
//            return []
//        }
//    }
    func deleteNews(_ news: NewsArticle) {
        let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", news.title )

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
}
    // MARK: - User CRUD Operations
    //    func addUserData(firstName: String, lastName: String, avatarURL: String?) {
    //        let newUserEntity = NewsEntity(context: context)
    //        newUserEntity.userFirstName = firstName
    //        newUserEntity.userLastName = lastName
    //        newUserEntity.userAvatar = avatarURL
    //        saveContext()
    //    }
    
//    func fetchUserDetails() -> [(firstName: String?, lastName: String?, avatar: String?)] {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NewsEntity")
//        fetchRequest.resultType = .dictionaryResultType
//        fetchRequest.propertiesToFetch = ["userFirstName", "userLastName", "userAvatar"]
//
//        do {
//            let results = try context.fetch(fetchRequest) as? [[String: Any]]
//            return results?.compactMap {
//                let firstName = $0["userFirstName"] as? String
//                let lastName = $0["userLastName"] as? String
//                let avatar = $0["userAvatar"] as? String
//                return (firstName, lastName, avatar)
//            } ?? []
//        } catch {
//            print("Error fetching user details: \(error)")
//            return []
//        }
//    }
//}
    
//    func deleteUserDetails() {
//        let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "userFirstName != nil OR userLastName != nil OR userAvatar != nil")
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            for object in results {
//                context.delete(object)
//            }
//            try context.save()
//            print("Данные пользователя успешно удалены")
//        } catch {
//            print("Ошибка при удалении данных пользователя: \(error)")
//        }
//    }
    // MARK: - FetchedResultsController
//    func setupNewsFetchedResultsController(delegate: NSFetchedResultsControllerDelegate) {
//        let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        let controller = NSFetchedResultsController(
//            fetchRequest: fetchRequest,
//            managedObjectContext: context,
//            sectionNameKeyPath: nil,
//            cacheName: nil
//        )
//        
//        controller.delegate = delegate
//        self.fetchedResultsController = controller
//        
//        do {
//            try controller.performFetch()
//        } catch {
//            print("Error fetching news: \(error)")
//        }
//    }
//    
//    func getAllNews() -> [NewsEntity]? {
//        return fetchedResultsController?.fetchedObjects
//    }
//}
//
//// MARK: - Example Delegate Implementation
//
extension CoreDataManager: NSFetchedResultsControllerDelegate {
    // Этот метод вызывается, когда данные изменяются в Core Data.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Уведомите UI об изменениях
        print("Данные в Core Data обновлены. Требуется обновить UI.")
    }
}
