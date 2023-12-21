//
//  CoreDataBookmarkStorage.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

import CoreData

class CoreDataBookmarkStorage {
    private var recentSearch: RecentSearch!
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func fetchBookmark() async throws -> [Bookmark] {
        let request = NSFetchRequest<Bookmark>(entityName: "Bookmark")
        
        return try coreDataStorage.viewContext.fetch(request)
    }
    
    func createBookmark(_ characterBookmark: CharacterBookmark, completionHandler: @escaping (Bookmark) -> Void) {
        self.coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            let bookmarkObject = NSEntityDescription.insertNewObject(forEntityName: "Bookmark", into: context)
            
            bookmarkObject.setValue(characterBookmark.name, forKey: "name")
            bookmarkObject.setValue(characterBookmark.jobClass, forKey: "jobClass")
            bookmarkObject.setValue(characterBookmark.itemLevel, forKey: "itemLevel")
            
            do {
                try context.save()
                completionHandler(bookmarkObject  as! Bookmark)
            } catch {
                self.rollBack()
            }
        }
    }
    
    func deleteBookmark(_ name: String, completionHandler: @escaping (Bookmark) -> Void) {
        self.coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            let request = NSFetchRequest<Bookmark>(entityName: "Bookmark")
            request.predicate = NSPredicate(format: " name = %@ ", name as CVarArg)
            
            do {
                guard let object = try context.fetch(request).first else { return }
                context.delete(object)
                try context.save()
                completionHandler(object)
            } catch {
                self.rollBack()
            }
        }
    }
    
    func rollBack() {
        self.coreDataStorage.viewContext.rollback()
    }
}
