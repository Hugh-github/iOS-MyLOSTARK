//
//  DefaultFetchProfileRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/10/04.
//

protocol DefaultFetchProfileRepository {
    func fetch(_ name: String) async throws -> CharacterArmory
}
