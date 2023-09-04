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
    
    // MARK: Delete 추가 해야 한다.
    func fetchRecentCharaterList() throws -> [RecentCharacterInfo] {
        let request = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
        let result = try coreDataStorage.viewContext.fetch(request)
        
        return result.map { recent in
            recent.toDomain()
        }
    }
    
    func createRecentSearch(_ search: RecentCharacterInfo) {
        let recentObject = NSEntityDescription.insertNewObject(forEntityName: "RecentSearch", into: coreDataStorage.viewContext)
        recentObject.setValue(search.name, forKey: "name")
        recentObject.setValue(search.itemLevel, forKey: "itemLevel")
        recentObject.setValue(search.jobClass, forKey: "jobClass")
        
        self.coreDataStorage.saveContext()
    }
}
