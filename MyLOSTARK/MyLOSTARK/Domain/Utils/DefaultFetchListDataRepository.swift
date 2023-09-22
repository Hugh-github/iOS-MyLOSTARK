//
//  DefaultFetchListRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/22.
//

protocol DefaultFetchListDataRepository {
    associatedtype ResultDTO
    
    func fetch() async throws -> [ResultDTO]
}
