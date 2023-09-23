//
//  EventRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/23.
//

class EventRepository: DefaultFetchAPIDataRepository {
    typealias ResultDTO = [Event]
    
    private let apiService = LOSTARKAPIService.shared
    
    func fetch() async throws -> [Event] {
        return try await apiService.getEventList().map { dto in
            dto.toDomain()
        }
    }
}
