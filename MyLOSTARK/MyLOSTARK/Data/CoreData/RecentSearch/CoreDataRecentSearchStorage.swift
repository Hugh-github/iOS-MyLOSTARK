//
//  CoreDataManager.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/03.
//

import CoreData

// Fetch를 제외한 나머지를 Background에서 실행시킨다.
// Bookmark도 마찬가지

class CoreDataRecentSearchStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func fetchRecentCharaterList() throws -> [RecentCharacterInfo] {
        let request = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
        let result = try coreDataStorage.viewContext.fetch(request)
        
        return result.map { recent in
            recent.toDomain()
        }
    }
    
    func createRecentSearch(_ search: RecentCharacterInfo) {
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
    
    func updateResultSearch(_ search: RecentCharacterInfo) {
        guard let name = search.name else { return }
        
        self.coreDataStorage.performBackgroundTask { context in
            let request = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
            request.predicate = NSPredicate(format: " name = %@ ", name as CVarArg)
            
            do {
                guard let object = try context.fetch(request).first else { return }
                object.setValue(search.name, forKey: "name")
                object.setValue(search.itemLevel, forKey: "itemLevel")
                object.setValue(search.jobClass, forKey: "jobClass")
                object.setValue(search.isBookmark, forKey: "isBookmark")
                
                try context.save()
            } catch {
                print("update 에러")
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
}
