//
//  CoreDataStorage.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

import CoreData

// MARK: BackgroundViewContext에서 동작 하도록 코드를 작성해야 한다.

final class CoreDataStorage {
    static let shared = CoreDataStorage()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimpleCharacterInfo")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext() // mainContext의 Child Context를 사용한다는 의미이다.
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func performContextTask(_ task: @escaping (NSManagedObjectContext) -> Void) {
        task(viewContext)
    }
    
    func performBackgroundTask(_ task: @escaping (NSManagedObjectContext) -> Void) {
        backgroundContext.perform {
            task(self.viewContext)
        }
    }
    
    func saveContext() {
        do {
            try self.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
