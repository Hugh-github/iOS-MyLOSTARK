//
//  ContentsRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/22.
//

class ContentsRepository: DefaultFetchAPIDataRepository {
    typealias ResultDTO = [Contents]
    
    private let apiService = LOSTARKAPIService.shared
    
    func fetch() async throws -> [Contents] {
        return try await self.apiService.getContents().map{ dto in
            dto.toDomain()
        }
    }
}
