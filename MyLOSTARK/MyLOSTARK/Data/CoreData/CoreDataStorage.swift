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
    
    private var backgroundContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func performContextTask(_ task: @escaping (NSManagedObjectContext) -> Void) {
        task(viewContext)
    }
    
    // 여기를 async / await으로 바꿔야 효과가 있네 (perform을 사용하기 때문에 불가능 하다.)
    // perform 자체가 escapingClosure기 때문에 non - escaping closure를 캡처할 수 없다.
    func performBackgroundTask(_ task: @escaping (NSManagedObjectContext) -> Void) {
        backgroundContext.perform {
            task(self.backgroundContext)
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
