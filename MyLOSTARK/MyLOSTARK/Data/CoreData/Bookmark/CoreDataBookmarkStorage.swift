//
//  CoreDataBookmarkStorage.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

import CoreData

class CoreDataBookmarkStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: Delete 추가 해야 한다.
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
}
