//
//  FetchCoreDataUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/15.
//

class FetchCoreDataUseCase<T> {
    private let repository: any DefualtRepository
    
    init(repository: any DefualtRepository) {
        self.repository = repository
    }
    
    func execute() async -> [T] {
        let entity = await self.repository.fetch().compactMap { any in
            any as? T
        }
        
        return entity
    }
}
