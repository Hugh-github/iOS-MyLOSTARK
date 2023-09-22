//
//  APIUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

class EventUseCase {
    private let apiService = LOSTARKAPIService.shared
    
    func execute() async throws -> [Event] {
        return try await apiService.getEventList()
    }
}
