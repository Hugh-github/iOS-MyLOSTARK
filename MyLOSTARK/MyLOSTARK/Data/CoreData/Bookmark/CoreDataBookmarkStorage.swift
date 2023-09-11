//
//  CoreDataBookmarkStorage.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

import CoreData

// MARK: Fetch를 제외한 나머지 기능들은 background에서 동작하는게 이상적이다. -> Fetch는 화면을 그리는데 직접 연관되어 있기 때문

class CoreDataBookmarkStorage {
    private var recentSearch: RecentSearch!
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func fetchBookmark() throws -> [CharacterBookmark] {
        let request = NSFetchRequest<Bookmark>(entityName: "Bookmark")
        let result = try coreDataStorage.viewContext.fetch(request)
        
        return result.map { bookmark in
            bookmark.toDomain()
        }
    }
    
    func createBookmark(_ characterBookmark: CharacterBookmark) {
        let bookmarkObject = NSEntityDescription.insertNewObject(forEntityName: "Bookmark", into: coreDataStorage.viewContext)
        bookmarkObject.setValue(characterBookmark.name, forKey: "name")
        bookmarkObject.setValue(characterBookmark.jobClass, forKey: "jobClass")
        bookmarkObject.setValue(characterBookmark.itemLevel, forKey: "itemLevel")
        
        self.coreDataStorage.saveContext()
    }
    
    func deleteBookmark(_ name: String) {
        let request = NSFetchRequest<Bookmark>(entityName: "Bookmark")
        request.predicate = NSPredicate(format: " name = %@ ", name as CVarArg)
        
        do {
            guard let object = try coreDataStorage.viewContext.fetch(request).first else { return }
            self.coreDataStorage.viewContext.delete(object)
            self.coreDataStorage.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
}
