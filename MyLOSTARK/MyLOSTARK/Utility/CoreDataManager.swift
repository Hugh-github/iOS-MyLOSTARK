//
//  CoreDataManager.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/03.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Bookmark")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    func createCoreData(_ bookmark: CharacterBookmark) {
        guard let entity = NSEntityDescription.entity(forEntityName: "CharacterInfo", in: context) else {
            return
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(bookmark.jobClass, forKey: "jobClass")
        object.setValue(bookmark.itemLevel, forKey: "itemLevel")
        object.setValue(bookmark.name, forKey: "name")
        
        save()
    }
    
    func fetchCoreData() -> [CharacterBookmark] {
        let request = CharacterInfo.fetchRequest()
        var bookmark = [CharacterBookmark]()
        
        do {
            // Optional Unwrapping 작업 필요
            let result = try context.fetch(request)
            result.forEach { info in
                bookmark.append(CharacterBookmark(
                    jobClass: info.jobClass!,
                    itemLevel: info.itemLevel,
                    name: info.name!
                ))
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return bookmark
    }
    
    func updateCoreData(_ character: CharacterBookmark) {
        let request = CharacterInfo.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", character.name as CVarArg)
        
        do {
            let result = try self.context.fetch(request)
            
            let object = result[0] as NSManagedObject
            object.setValue(character.itemLevel, forKey: "itemLevel")
        } catch {
            print(error.localizedDescription)
        }
        
        save()
    }
    
    func deleteCoreData(_ character: CharacterBookmark) {
        let request = CharacterInfo.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", character.name as CVarArg)
        
        do {
            let result = try self.context.fetch(request)
            let object = result[0] as NSManagedObject
            
            context.delete(object)
        } catch {
            print(error.localizedDescription)
        }
        
        save()
    }
    
    
    private func save() {
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
