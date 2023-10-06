//
//  CoreDataManager.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/03.
//

import CoreData

class CoreDataRecentSearchStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func fetchRecentSearch() async throws -> [RecentSearch] {
        let request = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
        
        return try coreDataStorage.viewContext.fetch(request)
    }
    
    func createRecentSearch(_ search: RecentCharacterInfo) {
        guard let name = search.name else { return }
        
        self.coreDataStorage.performBackgroundTask { context in
            let request = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
            request.predicate = NSPredicate(format: " name = %@ ", name as CVarArg)
            
            do {
                let object = try context.fetch(request)
                
                if object.isEmpty {
                    self.create(search)
                } else {
                    object.first!.setValue(search.name, forKey: "name")
                    object.first!.setValue(search.itemLevel, forKey: "itemLevel")
                    object.first!.setValue(search.jobClass, forKey: "jobClass")
                    object.first!.setValue(search.isBookmark, forKey: "isBookmark")
                }
                
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateRecentSearch(_ search: RecentCharacterInfo) {
        guard let name = search.name else { return }
        
        self.coreDataStorage.performBackgroundTask { context in
            let request = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
            request.predicate = NSPredicate(format: " name = %@ ", name as CVarArg)
            
            do {
                let object = try context.fetch(request)
                
                if object.isEmpty {
                    return
                }
                
                object.first!.setValue(search.name, forKey: "name")
                object.first!.setValue(search.itemLevel, forKey: "itemLevel")
                object.first!.setValue(search.jobClass, forKey: "jobClass")
                object.first!.setValue(search.isBookmark, forKey: "isBookmark")
                
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteRecentSearch(_ name: String) {
        self.coreDataStorage.performBackgroundTask { context in
            let request = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
            request.predicate = NSPredicate(format: " name = %@ ", name as CVarArg)
            
            do {
                guard let object = try context.fetch(request).first else { return }
                context.delete(object)
                
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAllSearch() {
        self.coreDataStorage.performBackgroundTask { context in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearch")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                try context.execute(deleteRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func rollBack() {
        self.coreDataStorage.viewContext.rollback()
    }
}

extension CoreDataRecentSearchStorage {
    private func create(_ search: RecentCharacterInfo) {
        self.coreDataStorage.performBackgroundTask { context in
            let recentObject = NSEntityDescription.insertNewObject(forEntityName: "RecentSearch", into: context)
            recentObject.setValue(search.name, forKey: "name")
            recentObject.setValue(search.itemLevel, forKey: "itemLevel")
            recentObject.setValue(search.jobClass, forKey: "jobClass")
            recentObject.setValue(search.isBookmark, forKey: "isBookmark")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
