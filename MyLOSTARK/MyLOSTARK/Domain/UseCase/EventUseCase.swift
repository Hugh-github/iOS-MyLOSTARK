//
//  APIUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

class EventUseCase {
    private let repository: any DefaultFetchListDataRepository
    
    init(repository: any DefaultFetchListDataRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Event] {
        guard let entity = try await self.repository.fetch() as? [Event] else { return [] }
        
        return entity
    }
}
