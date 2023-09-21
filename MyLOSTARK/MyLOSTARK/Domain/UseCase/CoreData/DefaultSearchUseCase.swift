//
//  DefaultSearchUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/21.
//

class DefaultSearchUseCase {
    private let repository: DefaultRecentSearchRepository
    
    init(repository: DefaultRecentSearchRepository) {
        self.repository = repository
    }
    
    func delete(_ character: RecentCharacterInfo) {
        self.repository.delete(character)
    }
    
    func deleteAll() {
        self.repository.deleteAll()
    }
    
    func create(_ character: RecentCharacterInfo) {
        self.repository.create(character)
    }
}
