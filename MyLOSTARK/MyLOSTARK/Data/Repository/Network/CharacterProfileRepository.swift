//
//  CharacterProfileRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/23.
//

class CharacterProfileRepository: DefaultFetchProfileRepository {
    private let apiService = LOSTARKAPIService.shared
    
    func fetch(_ name: String) async throws -> ArmoryProfile {
        return try await self.apiService.getCharacterProfile(
            name: name,
            query: [.profile]
        ).toDomain()
    }
}

protocol DefaultFetchProfileRepository {
    func fetch(_ name: String) async throws -> ArmoryProfile
}
