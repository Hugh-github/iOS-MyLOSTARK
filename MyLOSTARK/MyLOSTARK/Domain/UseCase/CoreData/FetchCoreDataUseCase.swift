//
//  FetchCoreDataUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/15.
//

class FetchCoreDataUseCase<T> {
    private let repository: any DefaultCoreDataRepository
    
    init(repository: any DefaultCoreDataRepository) {
        self.repository = repository
    }
    
    func execute() async -> [T] {
        let entity = await self.repository.fetch().compactMap { any in
            any as? T
        }
        
        return entity
    }
}
