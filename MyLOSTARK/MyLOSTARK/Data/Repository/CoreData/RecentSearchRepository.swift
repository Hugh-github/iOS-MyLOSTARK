//
//  RecentSearchRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/16.
//

class RecentSearchRepository: DefaultCoreDataRepository, InteractiveSearchRepository, DefaultRecentSearchRepository {
    typealias T = RecentCharacterInfo
    
    private let recentSearchStorage = CoreDataRecentSearchStorage()
    
    func fetch() async -> [RecentCharacterInfo] {
        var searchList = [RecentCharacterInfo]() 
        
        do {
            let list = try await recentSearchStorage.fetchRecentSearch()
            list.forEach { search in
                searchList.append(search.toDomain())
            }
        } catch {
            recentSearchStorage.rollBack()
        }
        
        return searchList
    }
    
    func create(_ search: RecentCharacterInfo) {
        self.recentSearchStorage.createRecentSearch(search)
    }
    
    func delete(_ search: RecentCharacterInfo) {
        guard let name = search.name else { return }
        
        self.recentSearchStorage.deleteRecentSearch(name)
    }
    
    func deleteAll() {
        self.recentSearchStorage.deleteAllSearch()
    }
    
    func update(_ search: RecentCharacterInfo) {
        self.recentSearchStorage.updateRecentSearch(search)
    }
}
