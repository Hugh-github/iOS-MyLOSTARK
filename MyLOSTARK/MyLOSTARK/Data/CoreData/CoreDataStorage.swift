//
//  CoreDataStorage.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

import CoreData

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
    
    func saveContext() {
        do {
            try self.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
