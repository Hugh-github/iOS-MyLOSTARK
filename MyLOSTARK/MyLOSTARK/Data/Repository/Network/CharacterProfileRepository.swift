//
//  CharacterProfileRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/23.
//

class CharacterProfileRepository: DefaultFetchProfileRepository {
    private let apiService = LOSTARKAPIService.shared
    
    func fetch(_ name: String) async throws -> CharacterArmory {
        return try await self.apiService.getCharacterProfile(
            name: name,
            query: [.profile, .equipment]
        ).toDomain()
    }
}
